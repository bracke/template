with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Public_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add public API tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test parse-once render-many behavior.
   --  @param Item AUnit fixture
   procedure Test_Parse_Once_Render_Many (Item : in out Fixture);

   --  Test public malformed-template exception.
   --  @param Item AUnit fixture
   procedure Test_Public_Error (Item : in out Fixture);

end Templates_Public_Tests;
