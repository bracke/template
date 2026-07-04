with Ada.Exceptions;
with AUnit.Assertions;
with AUnit.Test_Caller;
with Templates;
with Templates.Ast;
with Templates.Parser;

package body Templates_Parser_Tests is

   package Caller is new AUnit.Test_Caller (Fixture);
   use AUnit.Assertions;
   use type Templates.Ast.Node_Kind;

   procedure Expect_Error (Source : String) is
      Root : Templates.Ast.Node_Access;
   begin
      Root := Templates.Parser.Parse (Source);
      Templates.Ast.Release (Root);
      Assert (False, "expected parse error for " & Source);
   exception
      when Templates.Template_Error =>
         null;
   end Expect_Error;

   procedure Add_Tests (Suite : AUnit.Test_Suites.Access_Test_Suite) is
   begin
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("parser nodes", Test_Nodes'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("parser blocks", Test_Blocks'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("parser rejections", Test_Rejections'Access));
      AUnit.Test_Suites.Add_Test
        (Suite, Caller.Create ("parser positions", Test_Diagnostic_Position'Access));
   end Add_Tests;

   procedure Test_Nodes (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Root : Templates.Ast.Node_Access := Templates.Parser.Parse ("a {{user.name}} {{.}}");
   begin
      Assert (Templates.Ast.Child_Count (Root) = 4, "root child count");
      Assert (Templates.Ast.Child (Root, 1).Kind = Templates.Ast.Text_Node, "text node");
      Assert (Templates.Ast.Text (Templates.Ast.Child (Root, 1)) = "a ", "text content");
      Assert (Templates.Ast.Child (Root, 1).Line = 1, "text line");
      Assert (Templates.Ast.Child (Root, 1).Column = 1, "text column");
      Assert
        (Templates.Ast.Text (Templates.Ast.Child (Root, 2)) = "user.name",
         "dotted variable");
      Assert (Templates.Ast.Text (Templates.Ast.Child (Root, 4)) = ".", "current variable");
      Templates.Ast.Release (Root);
   end Test_Nodes;

   procedure Test_Blocks (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Source : constant String := "{{#each items}}{{#if name}}{{name}}{{/if}}{{/each}}";
      Root   : Templates.Ast.Node_Access := Templates.Parser.Parse (Source);
      Each_N : constant Templates.Ast.Node_Access := Templates.Ast.Child (Root, 1);
      If_N   : constant Templates.Ast.Node_Access := Templates.Ast.Child (Each_N, 1);
   begin
      Assert (Each_N.Kind = Templates.Ast.Each_Node, "each node");
      Assert (Templates.Ast.Text (Each_N) = "items", "each path");
      Assert (If_N.Kind = Templates.Ast.If_Node, "if node");
      Assert (Templates.Ast.Text (If_N) = "name", "if path");
      Assert (Templates.Ast.Child (If_N, 1).Kind = Templates.Ast.Variable_Node, "nested var");
      Templates.Ast.Release (Root);
   end Test_Blocks;

   procedure Test_Rejections (Item : in out Fixture) is
      pragma Unreferenced (Item);
   begin
      Expect_Error ("{{name");
      Expect_Error ("{{ }}");
      Expect_Error ("{{user.}}");
      Expect_Error ("{{user[0]}}");
      Expect_Error ("{{/if}}");
      Expect_Error ("{{#if ok}}{{/each}}");
      Expect_Error ("{{#if ok}}");
      Expect_Error ("{{#each items}}");
      Expect_Error ("{{#with user}}");
      Expect_Error ("{{#ifdef user}}");
      Expect_Error ("{{#if}}");
      Expect_Error ("{{#each}}");
      Expect_Error ("{{#ifuser}}");
      Expect_Error ("{{#eachitems}}");
      Expect_Error ("{{../name}}");
      Expect_Error ("{{user/name}}");
      Expect_Error ("{{this.name}}");
      Expect_Error ("{{.user}}");
      Expect_Error ("{{user..name}}");
   end Test_Rejections;

   procedure Test_Diagnostic_Position (Item : in out Fixture) is
      pragma Unreferenced (Item);
      Root : Templates.Ast.Node_Access;
   begin
      Root := Templates.Parser.Parse ("ok" & ASCII.LF & "  {{user.}}");
      Templates.Ast.Release (Root);
      Assert (False, "expected diagnostic");
   exception
      when Error : Templates.Template_Error =>
         Assert
           (Ada.Exceptions.Exception_Message (Error)'Length > 0,
            "message present");
         Assert
           (Ada.Exceptions.Exception_Message (Error) =
            "template parse error at line 2, column 3: invalid path syntax",
            "line and column");
   end Test_Diagnostic_Position;

end Templates_Parser_Tests;
