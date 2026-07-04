with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Templates.Diagnostics;

package body Templates.Parser is

   use type Ada.Containers.Count_Type;
   use type Templates.Ast.Node_Access;
   use type Templates.Ast.Node_Kind;

   package Node_Stack is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Templates.Ast.Node_Access);

   function Is_Whitespace (Ch : Character) return Boolean is
   begin
      return Ch in ' ' | ASCII.HT | ASCII.LF | ASCII.CR;
   end Is_Whitespace;

   function Is_Name_Character (Ch : Character) return Boolean is
   begin
      return Ch in 'A' .. 'Z'
        or else Ch in 'a' .. 'z'
        or else Ch in '0' .. '9'
        or else Ch = '_'
        or else Ch = '-';
   end Is_Name_Character;

   function Is_Valid_Path (Path : String) return Boolean is
      Previous_Dot : Boolean := False;
      In_Component : Boolean := False;
   begin
      if Path = "." then
         return True;
      end if;

      if Path'Length = 0
        or else Path (Path'First) = '.'
        or else Path (Path'Last) = '.'
        or else Path = "this.name"
      then
         return False;
      end if;

      for Ch of Path loop
         if Ch = '.' then
            if Previous_Dot or else not In_Component then
               return False;
            end if;
            Previous_Dot := True;
            In_Component := False;
         elsif Is_Name_Character (Ch) then
            Previous_Dot := False;
            In_Component := True;
         else
            return False;
         end if;
      end loop;

      return In_Component;
   end Is_Valid_Path;

   function Strip (Text : String) return String is
   begin
      return Ada.Strings.Fixed.Trim (Text, Ada.Strings.Both);
   end Strip;

   procedure Advance
     (Text   : String;
      Line   : in out Positive;
      Column : in out Positive)
   is
   begin
      for Ch of Text loop
         if Ch = ASCII.LF then
            Line := Line + 1;
            Column := 1;
         else
            Column := Column + 1;
         end if;
      end loop;
   end Advance;

   function Find_Close
     (Source : String;
      From   : Positive)
      return Natural
   is
   begin
      if From >= Source'Last then
         return 0;
      end if;

      for Position in From .. Source'Last - 1 loop
         if Source (Position) = '}' and then Source (Position + 1) = '}' then
            return Position;
         end if;
      end loop;

      return 0;
   end Find_Close;

   function Find_Open
     (Source : String;
      From   : Positive)
      return Natural
   is
   begin
      if From >= Source'Last then
         return 0;
      end if;

      for Position in From .. Source'Last - 1 loop
         if Source (Position) = '{' and then Source (Position + 1) = '{' then
            return Position;
         end if;
      end loop;

      return 0;
   end Find_Open;

   function Stack_Top (Stack : Node_Stack.Vector) return Templates.Ast.Node_Access is
   begin
      return Stack (Stack.Last_Index);
   end Stack_Top;

   procedure Validate_Path_Or_Error
     (Path   : String;
      Line   : Positive;
      Column : Positive)
   is
   begin
      if not Is_Valid_Path (Path) then
         Templates.Diagnostics.Raise_Error (Line, Column, "invalid path syntax");
      end if;
   end Validate_Path_Or_Error;

   procedure Close_Block
     (Stack  : in out Node_Stack.Vector;
      Kind   : Templates.Ast.Node_Kind;
      Name   : String;
      Line   : Positive;
      Column : Positive)
   is
      Top : constant Templates.Ast.Node_Access := Stack_Top (Stack);
   begin
      if Stack.Length = 1 then
         Templates.Diagnostics.Raise_Error
           (Line, Column, "/" & Name & " without open " & Name);
      elsif Top.Kind /= Kind then
         Templates.Diagnostics.Raise_Error
           (Line, Column, "/" & Name & " closes wrong block");
      end if;

      Stack.Delete_Last;
   end Close_Block;

   procedure Open_Block
     (Stack  : in out Node_Stack.Vector;
      Kind   : Templates.Ast.Node_Kind;
      Path   : String;
      Line   : Positive;
      Column : Positive)
   is
      Child : Templates.Ast.Node_Access;
   begin
      Validate_Path_Or_Error (Path, Line, Column);
      Child := Templates.Ast.Create (Kind, Path, Line, Column);
      Templates.Ast.Append_Child (Stack_Top (Stack), Child);
      Stack.Append (Child);
   end Open_Block;

   procedure Handle_Tag
     (Stack  : in out Node_Stack.Vector;
      Tag    : String;
      Line   : Positive;
      Column : Positive)
   is
      Clean : constant String := Strip (Tag);
      Child : Templates.Ast.Node_Access;
   begin
      if Clean'Length = 0 then
         Templates.Diagnostics.Raise_Error (Line, Column, "empty tag");
      elsif Clean = "/if" then
         Close_Block (Stack, Templates.Ast.If_Node, "if", Line, Column);
      elsif Clean = "/each" then
         Close_Block (Stack, Templates.Ast.Each_Node, "each", Line, Column);
      elsif Clean'Length >= 3 and then Clean (Clean'First .. Clean'First + 2) = "#if" then
         if Clean'Length = 3 then
            Templates.Diagnostics.Raise_Error (Line, Column, "#if without path");
         elsif Is_Whitespace (Clean (Clean'First + 3)) then
            declare
               Path : constant String := Strip (Clean (Clean'First + 4 .. Clean'Last));
            begin
               if Path'Length = 0 then
                  Templates.Diagnostics.Raise_Error (Line, Column, "#if without path");
               end if;
               Open_Block (Stack, Templates.Ast.If_Node, Path, Line, Column);
            end;
         else
            Templates.Diagnostics.Raise_Error (Line, Column, "unknown block syntax");
         end if;
      elsif Clean'Length >= 5 and then Clean (Clean'First .. Clean'First + 4) = "#each" then
         if Clean'Length = 5 then
            Templates.Diagnostics.Raise_Error (Line, Column, "#each without path");
         elsif Is_Whitespace (Clean (Clean'First + 5)) then
            declare
               Path : constant String := Strip (Clean (Clean'First + 6 .. Clean'Last));
            begin
               if Path'Length = 0 then
                  Templates.Diagnostics.Raise_Error (Line, Column, "#each without path");
               end if;
               Open_Block (Stack, Templates.Ast.Each_Node, Path, Line, Column);
            end;
         else
            Templates.Diagnostics.Raise_Error (Line, Column, "unknown block syntax");
         end if;
      elsif Clean (Clean'First) = '#' or else Clean (Clean'First) = '/' then
         Templates.Diagnostics.Raise_Error (Line, Column, "unknown block syntax");
      else
         Validate_Path_Or_Error (Clean, Line, Column);
         Child := Templates.Ast.Create
           (Templates.Ast.Variable_Node, Clean, Line, Column);
         Templates.Ast.Append_Child (Stack_Top (Stack), Child);
      end if;
   end Handle_Tag;

   function Parse (Source : String) return Templates.Ast.Node_Access is
      Root        : Templates.Ast.Node_Access;
      Stack       : Node_Stack.Vector;
      Position    : Positive := Source'First;
      Open_Pos    : Natural;
      Close_Pos   : Natural;
      Line        : Positive := 1;
      Column      : Positive := 1;
      Tag_Line    : Positive;
      Tag_Column  : Positive;
      Text_Line   : Positive;
      Text_Column : Positive;
      Child       : Templates.Ast.Node_Access;
   begin
      Root := Templates.Ast.Create (Templates.Ast.Root_Node, "", 1, 1);
      Stack.Append (Root);

      if Source'Length = 0 then
         return Root;
      end if;

      while Position <= Source'Last loop
         Open_Pos := Find_Open (Source, Position);

         if Open_Pos = 0 then
            Text_Line := Line;
            Text_Column := Column;
            Child := Templates.Ast.Create
              (Templates.Ast.Text_Node,
               Source (Position .. Source'Last),
               Text_Line,
               Text_Column);
            Templates.Ast.Append_Child (Stack_Top (Stack), Child);
            Advance (Source (Position .. Source'Last), Line, Column);
            exit;
         end if;

         if Open_Pos > Position then
            Text_Line := Line;
            Text_Column := Column;
            Child := Templates.Ast.Create
              (Templates.Ast.Text_Node,
               Source (Position .. Open_Pos - 1),
               Text_Line,
               Text_Column);
            Templates.Ast.Append_Child (Stack_Top (Stack), Child);
            Advance (Source (Position .. Open_Pos - 1), Line, Column);
         end if;

         Tag_Line := Line;
         Tag_Column := Column;
         Close_Pos := Find_Close (Source, Open_Pos + 2);

         if Close_Pos = 0 then
            Templates.Diagnostics.Raise_Error
              (Tag_Line, Tag_Column, "missing }}");
         end if;

         Advance (Source (Open_Pos .. Open_Pos + 1), Line, Column);
         Handle_Tag
           (Stack,
            Source (Open_Pos + 2 .. Close_Pos - 1),
            Tag_Line,
            Tag_Column);
         Advance (Source (Open_Pos + 2 .. Close_Pos + 1), Line, Column);
         Position := Close_Pos + 2;
      end loop;

      if Stack.Length /= 1 then
         declare
            Top : constant Templates.Ast.Node_Access := Stack_Top (Stack);
         begin
            if Top.Kind = Templates.Ast.If_Node then
               Templates.Diagnostics.Raise_Error
                 (Top.Line, Top.Column, "unclosed #if block");
            else
               Templates.Diagnostics.Raise_Error
                 (Top.Line, Top.Column, "unclosed #each block");
            end if;
         end;
      end if;

      return Root;
   exception
      when others =>
         Templates.Ast.Release (Root);
         raise;
   end Parse;

end Templates.Parser;
