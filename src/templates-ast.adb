with Ada.Unchecked_Deallocation;

package body Templates.Ast is

   use Ada.Strings.Unbounded;

   procedure Free is new Ada.Unchecked_Deallocation (Node, Node_Access);

   function Create
     (Kind   : Node_Kind;
      Text   : String;
      Line   : Positive;
      Column : Positive)
      return Node_Access
   is
   begin
      return new Node'
        (Kind      => Kind,
         Text      => To_Unbounded_String (Text),
         Line      => Line,
         Column    => Column,
         Children  => Node_Vectors.Empty_Vector,
         Ref_Count => 1);
   end Create;

   procedure Append_Child
     (Parent : Node_Access;
      Child  : Node_Access)
   is
   begin
      Parent.Children.Append (Child);
   end Append_Child;

   procedure Retain (Item : Node_Access) is
   begin
      if Item /= null then
         Item.Ref_Count := Item.Ref_Count + 1;
      end if;
   end Retain;

   procedure Release (Item : in out Node_Access) is
      Child_Node : Node_Access;
   begin
      if Item = null then
         return;
      end if;

      if Item.Ref_Count > 1 then
         Item.Ref_Count := Item.Ref_Count - 1;
         Item := null;
         return;
      end if;

      for Child of Item.Children loop
         Child_Node := Child;
         Release (Child_Node);
      end loop;

      Free (Item);
   end Release;

   function Text (Item : Node_Access) return String is
   begin
      return To_String (Item.Text);
   end Text;

   function Child_Count (Item : Node_Access) return Natural is
   begin
      return Natural (Item.Children.Length);
   end Child_Count;

   function Child
     (Item  : Node_Access;
      Index : Positive)
      return Node_Access
   is
   begin
      return Item.Children (Index);
   end Child;

end Templates.Ast;
