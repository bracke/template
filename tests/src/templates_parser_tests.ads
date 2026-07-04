with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Parser_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add parser tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test parsed node structure and positions.
   --  @param Item AUnit fixture
   procedure Test_Nodes (Item : in out Fixture);

   --  Test parsed block nesting.
   --  @param Item AUnit fixture
   procedure Test_Blocks (Item : in out Fixture);

   --  Test parser rejection cases.
   --  @param Item AUnit fixture
   procedure Test_Rejections (Item : in out Fixture);

   --  Test parser diagnostic positions.
   --  @param Item AUnit fixture
   procedure Test_Diagnostic_Position (Item : in out Fixture);

end Templates_Parser_Tests;
