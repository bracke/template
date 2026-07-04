with Ada.Finalization;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with System;

package Templates is

   Template_Error : exception;

   type Value_Kind is
     (Null_Value,
      String_Value,
      Boolean_Value,
      Object_Value,
      List_Value);

   type Value is private;
   type Template is private;

   --  Parse a template source string into a reusable template handle.
   --  @param Source template source text
   --  @return parsed template
   function Parse
     (Source : String)
      return Template;

   --  Render a parsed template against a context value.
   --  @param T parsed template
   --  @param Context active rendering context
   --  @return rendered HTML with escaped variable output
   function Render
     (T       : Template;
      Context : Value)
      return String;

private

   type Value_Data;
   type Value_Data_Access is access Value_Data;

   type Value_Handle is new Ada.Finalization.Controlled with record
      Data_Ptr : Value_Data_Access := null;
   end record;

   overriding procedure Adjust (Item : in out Value_Handle);
   overriding procedure Finalize (Item : in out Value_Handle);

   type Value is record
      Handle : Value_Handle;
   end record;

   type Field_Entry is record
      Name : Ada.Strings.Unbounded.Unbounded_String;
      Item : Value;
   end record;

   package Field_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Field_Entry);

   package Value_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Value);

   type Value_Data (Kind : Value_Kind := Null_Value) is record
      Ref_Count : Natural := 1;
      case Kind is
         when Null_Value =>
            null;
         when String_Value =>
            Text : Ada.Strings.Unbounded.Unbounded_String;
         when Boolean_Value =>
            Flag : Boolean := False;
         when Object_Value =>
            Fields : Field_Vectors.Vector;
         when List_Value =>
            Items : Value_Vectors.Vector;
      end case;
   end record;

   type Template is new Ada.Finalization.Controlled with record
      Root : System.Address := System.Null_Address;
   end record;

   overriding procedure Adjust (T : in out Template);
   overriding procedure Finalize (T : in out Template);

end Templates;
