with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Directories;
with Ada.Exceptions;
with Ada.Text_IO;

with Project_Tools.Alire_Manifests.Validation;
with Project_Tools.AUnit_Checks;
with Project_Tools.Files;
with Project_Tools.Processes;
with Project_Tools.Release_Checks;
with Project_Tools.Text;
with Project_Tools.Tree_Checks;

procedure Release_Check is
   use type Ada.Directories.File_Kind;

   function Project_Root return String is
      Here : constant String := Ada.Directories.Current_Directory;
   begin
      return Project_Tools.Files.Find_Root_Upward (Here, "templates.gpr");
   end Project_Root;

   Root   : constant String := Project_Root;
   Checks : constant Project_Tools.Release_Checks.Checker :=
     Project_Tools.Release_Checks.Create (Root);

   procedure Require_File (Relative_Path : String) is
   begin
      Project_Tools.Release_Checks.Require_File (Checks, Relative_Path);
   end Require_File;

   procedure Require_Directory (Relative_Path : String) is
   begin
      Project_Tools.Release_Checks.Require_Directory (Checks, Relative_Path);
   end Require_Directory;

   procedure Require_Text (Relative_Path : String; Text : String) is
   begin
      Project_Tools.Release_Checks.Require_Text (Checks, Relative_Path, Text);
   end Require_Text;

   procedure Error
     (Errors  : in out Natural;
      Message : String)
   is
   begin
      Errors := Errors + 1;
      Ada.Text_IO.Put_Line (Ada.Text_IO.Standard_Error, "error: " & Message);
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end Error;

   function Is_Generated_Directory (Name : String) return Boolean is
   begin
      return Name = ".git"
        or else Name = "alire"
        or else Name = "bin"
        or else Name = "config"
        or else Name = "lib"
        or else Name = "obj";
   end Is_Generated_Directory;

   function Has_Shell_Extension (Name : String) return Boolean is
      Lower : constant String := Ada.Characters.Handling.To_Lower (Name);
   begin
      return Project_Tools.Text.Ends_With (Lower, ".sh")
        or else Project_Tools.Text.Ends_With (Lower, ".bash")
        or else Project_Tools.Text.Ends_With (Lower, ".zsh")
        or else Project_Tools.Text.Ends_With (Lower, ".ksh")
        or else Project_Tools.Text.Ends_With (Lower, ".fish");
   end Has_Shell_Extension;

   function Is_Checked_Text_File (Name : String) return Boolean is
      Lower : constant String := Ada.Characters.Handling.To_Lower (Name);
   begin
      return Project_Tools.Text.Ends_With (Lower, ".adb")
        or else Project_Tools.Text.Ends_With (Lower, ".ads")
        or else Project_Tools.Text.Ends_With (Lower, ".gpr")
        or else Project_Tools.Text.Ends_With (Lower, ".toml")
        or else Project_Tools.Text.Ends_With (Lower, ".md");
   end Is_Checked_Text_File;

   procedure Check_Text_File
     (Path   : String;
      Errors : in out Natural)
   is
      File            : Ada.Text_IO.File_Type;
      Buffer          : String (1 .. 4096);
      Last            : Natural;
      Line_Number     : Natural := 0;
      Previous_Blank  : Boolean := False;
      Current_Blank   : Boolean;
   begin
      Ada.Text_IO.Open (File, Ada.Text_IO.In_File, Path);
      while not Ada.Text_IO.End_Of_File (File) loop
         Ada.Text_IO.Get_Line (File, Buffer, Last);
         Line_Number := Line_Number + 1;
         Current_Blank := Last = 0;

         if Last > 119 then
            Error
              (Errors,
               Path & ":" & Natural'Image (Line_Number) & ": line exceeds 119 characters");
         end if;

         if Current_Blank and then Previous_Blank then
            Error
              (Errors,
               Path & ":" & Natural'Image (Line_Number) & ": consecutive blank lines");
         end if;

         Previous_Blank := Current_Blank;
      end loop;
      Ada.Text_IO.Close (File);
   exception
      when others =>
         if Ada.Text_IO.Is_Open (File) then
            Ada.Text_IO.Close (File);
         end if;
         raise;
   end Check_Text_File;

   procedure Check_Tree
     (Path   : String;
      Errors : in out Natural)
   is
      Search    : Ada.Directories.Search_Type;
      Item      : Ada.Directories.Directory_Entry_Type;
      Is_Open   : Boolean := False;
   begin
      if not Project_Tools.Files.Directory_Exists (Path) then
         return;
      end if;

      Ada.Directories.Start_Search
        (Search,
         Directory => Path,
         Pattern   => "*",
         Filter    =>
           [Ada.Directories.Ordinary_File => True,
            Ada.Directories.Directory     => True,
            Ada.Directories.Special_File  => False]);
      Is_Open := True;

      while Ada.Directories.More_Entries (Search) loop
         Ada.Directories.Get_Next_Entry (Search, Item);
         declare
            Name : constant String := Ada.Directories.Simple_Name (Item);
            Full : constant String := Ada.Directories.Full_Name (Item);
         begin
            if Name = "." or else Name = ".." then
               null;
            elsif Ada.Directories.Kind (Item) = Ada.Directories.Directory then
               if not Is_Generated_Directory (Name) then
                  Check_Tree (Full, Errors);
               end if;
            elsif Has_Shell_Extension (Name) then
               Error (Errors, Full & ": shell helper scripts are not allowed");
            elsif Is_Checked_Text_File (Name) then
               Check_Text_File (Full, Errors);
            end if;
         end;
      end loop;

      Ada.Directories.End_Search (Search);
      Is_Open := False;
   exception
      when others =>
         if Is_Open then
            Ada.Directories.End_Search (Search);
         end if;
         raise;
   end Check_Tree;

   procedure Check_Source_Hygiene is
      Errors        : Natural := 0;
      Python_Errors : Natural := 0;
   begin
      Check_Tree (Root & "/src", Errors);
      Check_Tree (Root & "/tests/src", Errors);
      Check_Tree (Root & "/examples/src", Errors);
      Check_Tree (Root & "/tools/src", Errors);
      Check_Tree (Root & "/docs", Errors);
      Check_Text_File (Root & "/README.md", Errors);
      Check_Text_File (Root & "/alire.toml", Errors);
      Check_Text_File (Root & "/templates.gpr", Errors);
      Check_Text_File (Root & "/tests/alire.toml", Errors);
      Check_Text_File (Root & "/tests/templates_tests.gpr", Errors);
      Check_Text_File (Root & "/examples/alire.toml", Errors);
      Check_Text_File (Root & "/examples/templates_examples.gpr", Errors);
      Check_Text_File (Root & "/examples/README.md", Errors);
      Check_Text_File (Root & "/tools/alire.toml", Errors);
      Check_Text_File (Root & "/tools/templates_tools.gpr", Errors);
      Check_Text_File (Root & "/tools/README.md", Errors);

      Project_Tools.Tree_Checks.Check_No_Generated_Python
        (Python_Errors, Root & "/src");
      Project_Tools.Tree_Checks.Check_No_Generated_Python
        (Python_Errors, Root & "/tests/src");
      Project_Tools.Tree_Checks.Check_No_Generated_Python
        (Python_Errors, Root & "/examples/src");
      Project_Tools.Tree_Checks.Check_No_Generated_Python
        (Python_Errors, Root & "/tools/src");

      if Errors + Python_Errors > 0 then
         raise Program_Error;
      end if;
   end Check_Source_Hygiene;

begin
   if Root = "" then
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error,
         "release_check must be run inside the templates source tree");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   Project_Tools.Processes.Require_Command
     ("alr", "alr is required to run the templates release checklist");

   Require_File ("alire.toml");
   Require_File ("templates.gpr");
   Require_File ("README.md");
   Require_Directory ("src");
   Require_Directory ("tests");
   Require_Directory ("examples");
   Require_Directory ("docs");
   Require_Directory ("tools");
   Require_File ("tools/alire.toml");
   Require_File ("tools/templates_tools.gpr");
   Require_File ("tools/src/check_tests.adb");
   Require_File ("tools/src/release_check.adb");
   Require_File ("tools/src/check_all.adb");
   Require_Text ("README.md", "./tests/bin/tests");
   Require_Text ("README.md", "examples/");
   Require_Text ("docs/testing.md", "./tests/bin/tests");
   Require_Text ("tools/alire.toml", "project_tools");
   Require_Text ("tools/alire.toml", "../../project_tools");
   Require_Text ("alire.toml", "gnat_native = ""=15.2.1""");
   Require_Text ("tests/alire.toml", "gnat_native = ""=15.2.1""");
   Require_Text ("examples/alire.toml", "gnat_native = ""=15.2.1""");
   Require_Text ("tools/alire.toml", "gnat_native = ""=15.2.1""");

   Project_Tools.Alire_Manifests.Validation.Require_Pin_Free_Crate_Manifest
     (Root & "/alire.toml", "templates");
   Project_Tools.Alire_Manifests.Validation.Require_Workspace_Pin
     (Root & "/tests/alire.toml", "templates", "..");
   Project_Tools.Alire_Manifests.Validation.Require_Workspace_Pin
     (Root & "/examples/alire.toml", "templates", "..");
   Project_Tools.Alire_Manifests.Validation.Require_Workspace_Pin
     (Root & "/tools/alire.toml", "templates", "..");
   Project_Tools.Alire_Manifests.Validation.Require_Workspace_Pin
     (Root & "/tools/alire.toml", "project_tools", "../../project_tools");

   Project_Tools.AUnit_Checks.Require_Registered_Test_Packages
     (Test_Dir               => Root & "/tests/src",
      Spec_Pattern           => "templates_*_tests.ads",
      Suite_Path             => Root & "/tests/src/templates_test_suite.adb",
      Documentation_Path     => Root & "/docs/testing.md",
      Documented_Stem_Prefix => "- `",
      Suite_Add_Prefix       => "",
      Suite_Add_Suffix       => ".Add_Tests (Result)",
      Registration_Token     => "Caller.Create",
      Required_Stem_Suffix   => "_tests",
      Section_Marker         => "procedure Add_Tests");

   Project_Tools.Release_Checks.Require_GPR_Main_Inventory
     (Project_File       => Root & "/examples/templates_examples.gpr",
      Documentation_File => Root & "/examples/README.md",
      Source_Directory   => Root & "/examples/src");

   Check_Source_Hygiene;

   Ada.Text_IO.Put_Line ("templates release checklist passed");
   Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);
exception
   when Program_Error =>
      null;
   when Error : others =>
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error,
         "templates release checklist failed: " & Ada.Exceptions.Exception_Message (Error));
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
end Release_Check;
