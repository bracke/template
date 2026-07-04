with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Diagnostics_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add diagnostic tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test diagnostic message formatting.
   --  @param Item AUnit fixture
   procedure Test_Message (Item : in out Fixture);

   --  Test diagnostic exception raising.
   --  @param Item AUnit fixture
   procedure Test_Raise_Error (Item : in out Fixture);

end Templates_Diagnostics_Tests;
