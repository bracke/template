with Templates.Ast;
with Templates.Parser;
with Templates.Renderer;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

package body Templates is

   procedure Free is new Ada.Unchecked_Deallocation
     (Value_Data, Value_Data_Access);

   function To_Address is new Ada.Unchecked_Conversion
     (Templates.Ast.Node_Access, System.Address);

   function To_Node_Access is new Ada.Unchecked_Conversion
     (System.Address, Templates.Ast.Node_Access);

   procedure Retain (Ptr : Value_Data_Access) is
   begin
      if Ptr /= null then
         Ptr.Ref_Count := Ptr.Ref_Count + 1;
      end if;
   end Retain;

   procedure Release (Ptr : in out Value_Data_Access) is
   begin
      if Ptr = null then
         return;
      end if;

      if Ptr.Ref_Count > 1 then
         Ptr.Ref_Count := Ptr.Ref_Count - 1;
         Ptr := null;
         return;
      end if;

      Free (Ptr);
   end Release;

   overriding procedure Adjust (Item : in out Value_Handle) is
   begin
      Retain (Item.Data_Ptr);
   end Adjust;

   overriding procedure Finalize (Item : in out Value_Handle) is
   begin
      Release (Item.Data_Ptr);
   end Finalize;

   function Parse
     (Source : String)
      return Template
   is
   begin
      return Result : Template do
         Result.Root := To_Address (Templates.Parser.Parse (Source));
      end return;
   end Parse;

   function Render
     (T       : Template;
      Context : Value)
      return String
   is
   begin
      return Templates.Renderer.Render (To_Node_Access (T.Root), Context);
   end Render;

   overriding procedure Adjust (T : in out Template) is
      Root : constant Templates.Ast.Node_Access := To_Node_Access (T.Root);
   begin
      Templates.Ast.Retain (Root);
   end Adjust;

   overriding procedure Finalize (T : in out Template) is
      Root : Templates.Ast.Node_Access := To_Node_Access (T.Root);
   begin
      Templates.Ast.Release (Root);
      T.Root := System.Null_Address;
   end Finalize;

end Templates;
