with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package Templates.Ast is

   type Node_Kind is
     (Root_Node,
      Text_Node,
      Variable_Node,
      Raw_Variable_Node,
      If_Node,
      Each_Node);

   type Node;
   type Node_Access is access Node;

   package Node_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Node_Access);

   type Node is record
      Kind      : Node_Kind := Root_Node;
      Text      : Ada.Strings.Unbounded.Unbounded_String;
      Line      : Positive := 1;
      Column    : Positive := 1;
      Children  : Node_Vectors.Vector;
      Ref_Count : Natural := 1;
   end record;

   --  Allocate a node.
   --  @param Kind node kind
   --  @param Text node text, path, or empty root text
   --  @param Line source line
   --  @param Column source column
   --  @return allocated node
   function Create
     (Kind   : Node_Kind;
      Text   : String;
      Line   : Positive;
      Column : Positive)
      return Node_Access;

   --  Append a child to a parent node.
   --  @param Parent parent node
   --  @param Child child node
   procedure Append_Child
     (Parent : Node_Access;
      Child  : Node_Access);

   --  Increment a node reference count.
   --  @param Item node to retain
   procedure Retain (Item : Node_Access);

   --  Decrement a node reference count and free recursively at zero.
   --  @param Item node to release
   procedure Release (Item : in out Node_Access);

   --  Return node text.
   --  @param Item node to inspect
   --  @return node text
   function Text (Item : Node_Access) return String;

   --  Return the number of children.
   --  @param Item node to inspect
   --  @return child count
   function Child_Count (Item : Node_Access) return Natural;

   --  Return a child by one-based index.
   --  @param Item node to inspect
   --  @param Index one-based child index
   --  @return child node
   function Child
     (Item  : Node_Access;
      Index : Positive)
      return Node_Access;

end Templates.Ast;
