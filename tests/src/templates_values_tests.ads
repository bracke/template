with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

package Templates_Values_Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   --  Add value tests to a suite.
   --  @param Suite target AUnit suite
   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite);

   --  Test constructors and missing-data semantics.
   --  @param Item AUnit fixture
   procedure Test_Constructors_And_Missing (Item : in out Fixture);

   --  Test object and list operations.
   --  @param Item AUnit fixture
   procedure Test_Object_And_List (Item : in out Fixture);

   --  Test truthiness rules.
   --  @param Item AUnit fixture
   procedure Test_Truthiness (Item : in out Fixture);

   --  Test value copy-on-write behavior.
   --  @param Item AUnit fixture
   procedure Test_Copy_On_Write (Item : in out Fixture);

end Templates_Values_Tests;
