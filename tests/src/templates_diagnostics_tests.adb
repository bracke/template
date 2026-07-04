with Ada.Exceptions;
with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates;
with Templates.Diagnostics;

package body Templates_Diagnostics_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("diagnostic message", Test_Message'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("diagnostic raise", Test_Raise_Error'Access));
   end Add_Tests;

   procedure Test_Message (Item : in out Fixture) is
      pragma Unreferenced (Item);
   begin
      Assert
        (Templates.Diagnostics.Message (4, 12, "bad") =
         "template parse error at line 4, column 12: bad",
         "message includes line and column");
   end Test_Message;

   procedure Test_Raise_Error (Item : in out Fixture) is
      pragma Unreferenced (Item);
   begin
      Templates.Diagnostics.Raise_Error (2, 3, "bad");
      Assert (False, "Raise_Error did not raise");
   exception
      when Error : Templates.Template_Error =>
         Assert
           (Ada.Exceptions.Exception_Message (Error) =
            "template parse error at line 2, column 3: bad",
            "exception message");
   end Test_Raise_Error;

end Templates_Diagnostics_Tests;
