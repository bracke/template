with Ada.Strings.Unbounded;
with Templates.Html;

package body Templates.Renderer is

   use Ada.Strings.Unbounded;
   use type Templates.Ast.Node_Access;
   use type Templates.Ast.Node_Kind;

   function Resolve
     (Context : Templates.Values.Value;
      Path    : String)
      return Templates.Values.Value
   is
      Dot_Position : Natural;
      Start        : Positive := Path'First;
      Current      : Templates.Values.Value := Context;
   begin
      if Path = "." then
         return Context;
      end if;

      loop
         Dot_Position := 0;
         for Position in Start .. Path'Last loop
            if Path (Position) = '.' then
               Dot_Position := Position;
               exit;
            end if;
         end loop;

         if Dot_Position = 0 then
            return Templates.Values.Lookup
              (Current, Path (Start .. Path'Last));
         end if;

         Current := Templates.Values.Lookup
           (Current, Path (Start .. Dot_Position - 1));
         Start := Dot_Position + 1;
      end loop;
   end Resolve;

   procedure Render_Node
     (Item    : Templates.Ast.Node_Access;
      Context : Templates.Values.Value;
      Output  : in out Unbounded_String);

   procedure Render_Children
     (Item    : Templates.Ast.Node_Access;
      Context : Templates.Values.Value;
      Output  : in out Unbounded_String)
   is
   begin
      for Child of Item.Children loop
         Render_Node (Child, Context, Output);
      end loop;
   end Render_Children;

   procedure Append_Value
     (Item   : Templates.Values.Value;
      Output : in out Unbounded_String)
   is
   begin
      case Templates.Values.Kind (Item) is
         when Templates.Values.String_Value =>
            Append (Output, Templates.Html.Escape (Templates.Values.As_String (Item)));
         when Templates.Values.Boolean_Value =>
            if Templates.Values.As_Boolean (Item) then
               Append (Output, "true");
            else
               Append (Output, "false");
            end if;
         when others =>
            null;
      end case;
   end Append_Value;

   procedure Render_Node
     (Item    : Templates.Ast.Node_Access;
      Context : Templates.Values.Value;
      Output  : in out Unbounded_String)
   is
      Resolved : Templates.Values.Value;
   begin
      case Item.Kind is
         when Templates.Ast.Root_Node | Templates.Ast.Text_Node =>
            if Item.Kind = Templates.Ast.Text_Node then
               Append (Output, Templates.Ast.Text (Item));
            else
               Render_Children (Item, Context, Output);
            end if;
         when Templates.Ast.Variable_Node =>
            Append_Value (Resolve (Context, Templates.Ast.Text (Item)), Output);
         when Templates.Ast.If_Node =>
            Resolved := Resolve (Context, Templates.Ast.Text (Item));
            if Templates.Values.Is_Truthy (Resolved) then
               Render_Children (Item, Context, Output);
            end if;
         when Templates.Ast.Each_Node =>
            Resolved := Resolve (Context, Templates.Ast.Text (Item));
            if Templates.Values.Kind (Resolved) = Templates.Values.List_Value then
               for Index in 1 .. Templates.Values.Length (Resolved) loop
                  Render_Children
                    (Item, Templates.Values.Element (Resolved, Index), Output);
               end loop;
            end if;
      end case;
   end Render_Node;

   function Render
     (Root    : Templates.Ast.Node_Access;
      Context : Templates.Values.Value)
      return String
   is
      Output : Unbounded_String;
   begin
      if Root /= null then
         Render_Node (Root, Context, Output);
      end if;

      return To_String (Output);
   end Render;

end Templates.Renderer;
