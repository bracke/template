with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates.Values;

package body Templates_Values_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;
   use type Templates.Values.Value_Kind;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("values constructors", Test_Constructors_And_Missing'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("values object list", Test_Object_And_List'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("values truthiness", Test_Truthiness'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("values copy on write", Test_Copy_On_Write'Access));
   end Add_Tests;

   procedure Test_Constructors_And_Missing (Item : in out Fixture) is
      pragma Unreferenced (Item);
      use Templates.Values;
   begin
      Assert (Kind (Null_Item) = Null_Value, "null kind");
      Assert (As_String (String_Item ("abc")) = "abc", "string content");
      Assert (As_Boolean (Boolean_Item (True)), "boolean content");
      Assert (Kind (Lookup (String_Item ("x"), "name")) = Null_Value, "lookup on scalar");
      Assert (Kind (Element (String_Item ("x"), 1)) = Null_Value, "element on scalar");
   end Test_Constructors_And_Missing;

   procedure Test_Object_And_List (Item : in out Fixture) is
      pragma Unreferenced (Item);
      use Templates.Values;
      Obj : Value := Object;
      Arr : Value := List;
   begin
      Set (Obj, "name", String_Item ("A"));
      Set (Obj, "name", String_Item ("B"));
      Assert (As_String (Lookup (Obj, "name")) = "B", "set replaces");
      Assert (Kind (Lookup (Obj, "missing")) = Null_Value, "missing object field");
      Append (Arr, String_Item ("one"));
      Append (Arr, Boolean_Item (True));
      Assert (Length (Arr) = 2, "list length");
      Assert (As_String (Element (Arr, 1)) = "one", "list first item");
      Assert (As_Boolean (Element (Arr, 2)), "list second item");
      Assert (Kind (Element (Arr, 3)) = Null_Value, "list out of range");
   end Test_Object_And_List;

   procedure Test_Truthiness (Item : in out Fixture) is
      pragma Unreferenced (Item);
      use Templates.Values;
      Arr : Value := List;
   begin
      Assert (not Is_Truthy (Null_Item), "null false");
      Assert (not Is_Truthy (Boolean_Item (False)), "false false");
      Assert (Is_Truthy (Boolean_Item (True)), "true true");
      Assert (not Is_Truthy (String_Item ("")), "empty string false");
      Assert (Is_Truthy (String_Item ("x")), "string true");
      Assert (not Is_Truthy (Arr), "empty list false");
      Append (Arr, Null_Item);
      Assert (Is_Truthy (Arr), "non-empty list true");
      Assert (Is_Truthy (Object), "object true");
   end Test_Truthiness;

   procedure Test_Copy_On_Write (Item : in out Fixture) is
      pragma Unreferenced (Item);
      use Templates.Values;
      Obj_A : Value := Object;
      Arr_A : Value := List;
      Nested_A : Value := Object;
   begin
      Set (Obj_A, "name", String_Item ("A"));
      declare
         Obj_B : Value := Obj_A;
      begin
         Set (Obj_B, "name", String_Item ("B"));
         Assert (As_String (Lookup (Obj_A, "name")) = "A", "object copy remains");
         Assert (As_String (Lookup (Obj_B, "name")) = "B", "object copy changes");
      end;

      Append (Arr_A, String_Item ("A"));
      declare
         Arr_B : Value := Arr_A;
      begin
         Append (Arr_B, String_Item ("B"));
         Assert (Length (Arr_A) = 1, "list copy remains");
         Assert (Length (Arr_B) = 2, "list copy changes");
      end;

      Set (Nested_A, "child", Obj_A);
      declare
         Nested_B : Value := Nested_A;
         Child_B  : Value := Lookup (Nested_B, "child");
      begin
         Set (Child_B, "name", String_Item ("C"));
         Set (Nested_B, "child", Child_B);
         Assert
           (As_String (Lookup (Lookup (Nested_A, "child"), "name")) = "A",
            "nested copy remains");
      end;
   end Test_Copy_On_Write;

end Templates_Values_Tests;
