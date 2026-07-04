with Ada.Command_Line;
with Ada.Directories;
with Ada.Exceptions;
with Ada.Text_IO;

with GNAT.OS_Lib;
with Project_Tools.Files;
with Project_Tools.Processes;

procedure Check_All is

   function Project_Root return String is
      Here : constant String := Ada.Directories.Current_Directory;
   begin
      return Project_Tools.Files.Find_Root_Upward (Here, "templates.gpr");
   end Project_Root;

   Root : constant String := Project_Root;

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
         "check_all must be run inside the templates source tree");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   Run ("templates test tooling", Root, "./tools/bin/check_tests", []);
   Run ("templates release check", Root, "./tools/bin/release_check", []);

   Ada.Text_IO.Put_Line ("templates full check passed");
   Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
exception
   when Program_Error =>
      null;
   when Error : others =>
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error,
         "templates full check failed: " & Ada.Exceptions.Exception_Message (Error));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Check_All;
