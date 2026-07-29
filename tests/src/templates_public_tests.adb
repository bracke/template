with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates;
with Templates.Values;

package body Templates_Public_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;
   use Templates.Values;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("public parse once", Test_Parse_Once_Render_Many'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("public error", Test_Public_Error'Access));
   end Add_Tests;

   procedure Test_Parse_Once_Render_Many (Item : in out Fixture) is
      pragma Unreferenced (Item);
      T  : constant Templates.Template := Templates.Parse ("Hello {{name}}");
      C1 : Value := Object;
      C2 : Value := Object;
   begin
      Set (C1, "name", String_Item ("Ada"));
      Set (C2, "name", String_Item ("Grace"));
      Assert (Templates.Render (T, C1) = "Hello Ada", "first render");
      Assert (Templates.Render (T, C2) = "Hello Grace", "second render");
   end Test_Parse_Once_Render_Many;

   procedure Test_Public_Error (Item : in out Fixture) is
      pragma Unreferenced (Item);
      T : Templates.Template;
   begin
      T := Templates.Parse ("{{#if ok}}");
      Assert (False,
              "malformed template did not raise; rendered: " & Templates.Render (T, Object));
   exception
      when Templates.Template_Error =>
         null;
   end Test_Public_Error;

end Templates_Public_Tests;
