with Ada.Command_Line;
with Ada.Directories;
with Ada.Exceptions;
with Ada.Text_IO;

with GNAT.OS_Lib;
with Project_Tools.Files;
with Project_Tools.Processes;

procedure Check_Tests is

   function Project_Root return String is
      Here : constant String := Ada.Directories.Current_Directory;
   begin
      return Project_Tools.Files.Find_Root_Upward (Here, "templates.gpr");
   end Project_Root;

   Root : constant String := Project_Root;
   Alr  : constant String := Project_Tools.Processes.Locate_Command ("alr");

   procedure Run
     (Label   : String;
      Dir     : String;
      Program : String;
      Args    : GNAT.OS_Lib.Argument_List;
      Quiet   : Boolean := False) renames Project_Tools.Processes.Run;

begin
   if Root = "" then
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error,
         "check_tests must be run inside the templates source tree");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   Project_Tools.Processes.Require_Command
     ("alr", "alr is required to run the templates test tooling");
   Project_Tools.Processes.Require_Command
     ("gprbuild", "gprbuild is required to run the templates test tooling");

   Run ("library build", Root, Alr, [new String'("build")]);
   Run ("tests crate build", Root & "/tests", Alr, [new String'("build")]);
   Run ("AUnit tests", Root & "/tests", "./bin/tests", []);
   Run ("examples crate build", Root & "/examples", Alr, [new String'("build")]);
   Run ("example basic", Root & "/examples", "./bin/basic", []);
   Run ("example profile_page", Root & "/examples", "./bin/profile_page", []);
   Run ("example missing_data", Root & "/examples", "./bin/missing_data", []);
   Run ("example parse_once", Root & "/examples", "./bin/parse_once", []);

   Ada.Text_IO.Put_Line ("templates tests passed");
   Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
exception
   when Program_Error =>
      null;
   when Error : others =>
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error,
         "templates test tooling failed: " & Ada.Exceptions.Exception_Message (Error));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Check_Tests;
