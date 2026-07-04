with Templates_Diagnostics_Tests;
with Templates_Html_Tests;
with Templates_Parser_Tests;
with Templates_Public_Tests;
with Templates_Renderer_Tests;
with Templates_Values_Tests;

package body Templates_Test_Suite is

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      Result : constant AUnit.Test_Suites.Access_Test_Suite :=
        AUnit.Test_Suites.New_Suite;
   begin
      Templates_Values_Tests.Add_Tests (Result);
      Templates_Html_Tests.Add_Tests (Result);
      Templates_Diagnostics_Tests.Add_Tests (Result);
      Templates_Parser_Tests.Add_Tests (Result);
      Templates_Renderer_Tests.Add_Tests (Result);
      Templates_Public_Tests.Add_Tests (Result);
      return Result;
   end Suite;

end Templates_Test_Suite;
