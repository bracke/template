with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates.Html;

package body Templates_Html_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("html escaping", Test_Escape'Access));
   end Add_Tests;

   procedure Test_Escape (Item : in out Fixture) is
      pragma Unreferenced (Item);
   begin
      Assert (Templates.Html.Escape ("plain") = "plain", "plain unchanged");
      Assert (Templates.Html.Escape ("&") = "&amp;", "ampersand escaped");
      Assert (Templates.Html.Escape ("<>") = "&lt;&gt;", "angles escaped");
      Assert (Templates.Html.Escape ("""") = "&quot;", "quote escaped");
      Assert (Templates.Html.Escape ("'") = "&#39;", "apostrophe escaped");
      Assert
        (Templates.Html.Escape ("<a x=""&"">'</a>") =
         "&lt;a x=&quot;&amp;&quot;&gt;&#39;&lt;/a&gt;",
         "mixed escaped");
      Assert (Templates.Html.Escape ("") = "", "empty string");
   end Test_Escape;

end Templates_Html_Tests;
