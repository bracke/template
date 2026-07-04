with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Html_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add HTML tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test HTML escaping behavior.
   --  @param Item AUnit fixture
   procedure Test_Escape (Item : in out Fixture);

end Templates_Html_Tests;
