with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Renderer_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add renderer tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test variable rendering.
   --  @param Item AUnit fixture
   procedure Test_Variables (Item : in out Fixture);

   --  Test conditional rendering.
   --  @param Item AUnit fixture
   procedure Test_If_Blocks (Item : in out Fixture);

   --  Test loop rendering.
   --  @param Item AUnit fixture
   procedure Test_Each_Blocks (Item : in out Fixture);

   --  Test copied and assigned templates.
   --  @param Item AUnit fixture
   procedure Test_Template_Copy (Item : in out Fixture);

   --  Test raw (unescaped) triple-brace variable rendering.
   --  @param Item AUnit fixture
   procedure Test_Raw_Variables (Item : in out Fixture);

end Templates_Renderer_Tests;
