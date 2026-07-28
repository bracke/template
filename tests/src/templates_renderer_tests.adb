with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates;
with Templates.Values;

package body Templates_Renderer_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;
   use Templates.Values;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("renderer variables", Test_Variables'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("renderer if", Test_If_Blocks'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("renderer each", Test_Each_Blocks'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("renderer template copy", Test_Template_Copy'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("renderer raw variables", Test_Raw_Variables'Access));
   end Add_Tests;

   function User_Context return Value is
      User : Value := Object;
      Root : Value := Object;
      Arr  : Value := List;
   begin
      Set (User, "name", String_Item ("Ada & Lovelace"));
      Set (User, "email", String_Item ("ada@example.test"));
      Set (User, "empty", String_Item (""));
      Append (Arr, String_Item ("admin"));
      Append (Arr, String_Item ("dev"));
      Set (User, "roles", Arr);
      Set (Root, "user", User);
      Set (Root, "flag", Boolean_Item (True));
      Set (Root, "no", Boolean_Item (False));
      Set (Root, "obj", Object);
      Set (Root, "arr", Arr);
      Set (Root, "empty_arr", List);
      return Root;
   end User_Context;

   procedure Test_Variables (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Context : constant Value := User_Context;
   begin
      Assert (Templates.Render (Templates.Parse ("plain"), Context) = "plain", "plain");
      Assert
        (Templates.Render (Templates.Parse (" a" & ASCII.LF & " b "), Context) =
         " a" & ASCII.LF & " b ",
         "whitespace preserved");
      Assert
        (Templates.Render (Templates.Parse ("{{user.name}}"), Context) =
         "Ada &amp; Lovelace",
         "escaped variable");
      Assert (Templates.Render (Templates.Parse ("{{flag}} {{no}}"), Context) = "true false", "bools");
      Assert (Templates.Render (Templates.Parse ("{{missing}}"), Context) = "", "missing");
      Assert (Templates.Render (Templates.Parse ("{{obj}}{{arr}}"), Context) = "", "complex empty");
      Assert (Templates.Render (Templates.Parse ("{{.}}"), String_Item ("<x>")) = "&lt;x&gt;", "current");
   end Test_Variables;

   procedure Test_If_Blocks (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Context : constant Value := User_Context;
   begin
      Assert (Templates.Render (Templates.Parse ("{{#if flag}}yes{{/if}}"), Context) = "yes", "if true");
      Assert (Templates.Render (Templates.Parse ("{{#if no}}yes{{/if}}"), Context) = "", "if false");
      Assert (Templates.Render (Templates.Parse ("{{#if missing}}yes{{/if}}"), Context) = "", "missing");
      Assert (Templates.Render (Templates.Parse ("{{#if user.empty}}yes{{/if}}"), Context) = "", "empty");
      Assert
        (Templates.Render (Templates.Parse ("{{#if user.name}}yes{{/if}}"), Context) = "yes",
         "non-empty string");
      Assert
        (Templates.Render (Templates.Parse ("{{#if empty_arr}}yes{{/if}}"), Context) = "",
         "empty list false");
      Assert (Templates.Render (Templates.Parse ("{{#if arr}}yes{{/if}}"), Context) = "yes", "list true");
      Assert (Templates.Render (Templates.Parse ("{{#if obj}}yes{{/if}}"), Context) = "yes", "object true");
   end Test_If_Blocks;

   procedure Test_Each_Blocks (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Context : constant Value := User_Context;
   begin
      Assert
        (Templates.Render (Templates.Parse ("{{#each user.roles}}<{{.}}>{{/each}}"), Context) =
         "<admin><dev>",
         "each list");
      Assert
        (Templates.Render (Templates.Parse ("{{#each empty_arr}}x{{/each}}"), Context) = "",
         "empty each");
      Assert
        (Templates.Render (Templates.Parse ("{{#each missing}}x{{/each}}"), Context) = "",
         "missing each");
      Assert
        (Templates.Render
           (Templates.Parse ("{{#each user.roles}}{{#if .}}<{{.}}>{{/if}}{{/each}}"), Context) =
         "<admin><dev>",
         "nested if inside each");
      Assert
        (Templates.Render
           (Templates.Parse ("{{#if flag}}{{#each user.roles}}{{.}} {{/each}}{{/if}}"), Context) =
         "admin dev ",
         "nested each inside if");
   end Test_Each_Blocks;

   procedure Test_Template_Copy (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Context : constant Value := User_Context;
      T_A : constant Templates.Template := Templates.Parse ("{{user.email}}");
      T_B : constant Templates.Template := T_A;
      T_C     : Templates.Template := Templates.Parse ("old");
   begin
      Assert (Templates.Render (T_B, Context) = "ada@example.test", "copy renders");
      T_C := Templates.Parse ("{{user.name}}");
      Assert (Templates.Render (T_C, Context) = "Ada &amp; Lovelace", "assignment renders");
   end Test_Template_Copy;

   procedure Test_Raw_Variables (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Context : constant Value := User_Context;
   begin
      --  Triple braces emit the value verbatim, without HTML escaping.
      Assert
        (Templates.Render (Templates.Parse ("{{{user.name}}}"), Context) =
         "Ada & Lovelace",
         "raw variable is not escaped");
      --  Double braces still escape, side by side with a raw one.
      Assert
        (Templates.Render (Templates.Parse ("{{user.name}}|{{{user.name}}}"), Context) =
         "Ada &amp; Lovelace|Ada & Lovelace",
         "escaped and raw coexist");
      Assert
        (Templates.Render (Templates.Parse ("{{{.}}}"), String_Item ("<x>")) = "<x>",
         "raw current value");
      Assert
        (Templates.Render (Templates.Parse ("{{{missing}}}"), Context) = "",
         "raw missing renders empty");
   end Test_Raw_Variables;

end Templates_Renderer_Tests;
