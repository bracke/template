pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__test_runner.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__test_runner.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E071 : Short_Integer; pragma Import (Ada, E071, "system__os_lib_E");
   E016 : Short_Integer; pragma Import (Ada, E016, "ada__exceptions_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__soft_links_E");
   E010 : Short_Integer; pragma Import (Ada, E010, "system__exception_table_E");
   E035 : Short_Integer; pragma Import (Ada, E035, "ada__containers_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "ada__io_exceptions_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "ada__numerics_E");
   E007 : Short_Integer; pragma Import (Ada, E007, "ada__strings_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__strings__maps_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "ada__strings__maps__constants_E");
   E040 : Short_Integer; pragma Import (Ada, E040, "interfaces__c_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exceptions_E");
   E082 : Short_Integer; pragma Import (Ada, E082, "system__object_reader_E");
   E047 : Short_Integer; pragma Import (Ada, E047, "system__dwarf_lines_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "system__soft_links__initialize_E");
   E034 : Short_Integer; pragma Import (Ada, E034, "system__traceback__symbolic_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "ada__assertions_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__strings__utf_encoding_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "ada__tags_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "ada__strings__text_buffers_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "gnat_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "ada__streams_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "system__file_control_block_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "system__finalization_root_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "ada__finalization_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "system__file_io_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "system__storage_pools_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "system__storage_pools__subpools_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "ada__strings__unbounded_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "ada__calendar_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "ada__text_io_E");
   E187 : Short_Integer; pragma Import (Ada, E187, "system__pool_global_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "aunit_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "aunit__memory_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "aunit__memory__utils_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "ada_containers__aunit_lists_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "aunit__tests_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "aunit__time_measure_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "aunit__test_results_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "aunit__assertions_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "aunit__test_filters_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "aunit__simple_test_cases_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "aunit__reporter_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "aunit__reporter__text_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "aunit__test_fixtures_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "aunit__test_caller_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "aunit__test_suites_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "aunit__run_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "templates_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "templates__ast_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "templates__diagnostics_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "templates__html_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "templates__parser_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "templates__values_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "templates__renderer_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "templates_diagnostics_tests_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "templates_html_tests_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "templates_parser_tests_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "templates_public_tests_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "templates_renderer_tests_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "templates_values_tests_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "templates_test_suite_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "templates_values_tests__finalize_body");
      begin
         E269 := E269 - 1;
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "templates_values_tests__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "templates_renderer_tests__finalize_body");
      begin
         E267 := E267 - 1;
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "templates_renderer_tests__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "templates_public_tests__finalize_body");
      begin
         E265 := E265 - 1;
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "templates_public_tests__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "templates_parser_tests__finalize_body");
      begin
         E261 := E261 - 1;
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "templates_parser_tests__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "templates_html_tests__finalize_body");
      begin
         E259 := E259 - 1;
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "templates_html_tests__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "templates_diagnostics_tests__finalize_body");
      begin
         E217 := E217 - 1;
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "templates_diagnostics_tests__finalize_spec");
      begin
         F12;
      end;
      E223 := E223 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "templates__parser__finalize_body");
      begin
         E241 := E241 - 1;
         F13;
      end;
      E229 := E229 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "templates__ast__finalize_spec");
      begin
         F14;
      end;
      declare
         procedure F15;
         pragma Import (Ada, F15, "templates__finalize_spec");
      begin
         F15;
      end;
      E213 := E213 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "aunit__test_suites__finalize_spec");
      begin
         F16;
      end;
      E221 := E221 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "aunit__test_fixtures__finalize_spec");
      begin
         F17;
      end;
      E205 := E205 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "aunit__reporter__text__finalize_spec");
      begin
         F18;
      end;
      E163 := E163 - 1;
      E165 := E165 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "aunit__simple_test_cases__finalize_spec");
      begin
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "aunit__test_filters__finalize_spec");
      begin
         F20;
      end;
      E167 := E167 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "aunit__assertions__finalize_spec");
      begin
         F21;
      end;
      E174 := E174 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "aunit__test_results__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "aunit__tests__finalize_spec");
      begin
         E185 := E185 - 1;
         F23;
      end;
      E187 := E187 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "system__pool_global__finalize_spec");
      begin
         F24;
      end;
      E134 := E134 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "ada__text_io__finalize_spec");
      begin
         F25;
      end;
      E235 := E235 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "ada__strings__unbounded__finalize_spec");
      begin
         F26;
      end;
      E225 := E225 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "system__storage_pools__subpools__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "system__file_io__finalize_body");
      begin
         E138 := E138 - 1;
         F28;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");
      Interrupts_Default_To_System : Integer;
      pragma Import (C, Interrupts_Default_To_System, "__gl_interrupts_default_to_system");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E010 := E010 + 1;
      Ada.Containers'Elab_Spec;
      E035 := E035 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E066 := E066 + 1;
      Ada.Numerics'Elab_Spec;
      E025 := E025 + 1;
      Ada.Strings'Elab_Spec;
      E007 := E007 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E053 := E053 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E056 := E056 + 1;
      Interfaces.C'Elab_Spec;
      E040 := E040 + 1;
      System.Exceptions'Elab_Spec;
      E019 := E019 + 1;
      System.Object_Reader'Elab_Spec;
      E082 := E082 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E047 := E047 + 1;
      System.Os_Lib'Elab_Body;
      E071 := E071 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E101 := E101 + 1;
      E012 := E012 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E034 := E034 + 1;
      E016 := E016 + 1;
      Ada.Assertions'Elab_Spec;
      E239 := E239 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E105 := E105 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E113 := E113 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E005 := E005 + 1;
      Gnat'Elab_Spec;
      E192 := E192 + 1;
      Ada.Streams'Elab_Spec;
      E125 := E125 + 1;
      System.File_Control_Block'Elab_Spec;
      E146 := E146 + 1;
      System.Finalization_Root'Elab_Spec;
      E141 := E141 + 1;
      Ada.Finalization'Elab_Spec;
      E139 := E139 + 1;
      System.File_Io'Elab_Body;
      E138 := E138 + 1;
      System.Storage_Pools'Elab_Spec;
      E191 := E191 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E225 := E225 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E235 := E235 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E182 := E182 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E134 := E134 + 1;
      System.Pool_Global'Elab_Spec;
      E187 := E187 + 1;
      E121 := E121 + 1;
      E119 := E119 + 1;
      E172 := E172 + 1;
      E169 := E169 + 1;
      Aunit.Tests'Elab_Spec;
      E185 := E185 + 1;
      Aunit.Time_Measure'Elab_Spec;
      E176 := E176 + 1;
      Aunit.Test_Results'Elab_Spec;
      E174 := E174 + 1;
      Aunit.Assertions'Elab_Spec;
      Aunit.Assertions'Elab_Body;
      E167 := E167 + 1;
      Aunit.Test_Filters'Elab_Spec;
      Aunit.Simple_Test_Cases'Elab_Spec;
      E165 := E165 + 1;
      E163 := E163 + 1;
      Aunit.Reporter'Elab_Spec;
      E123 := E123 + 1;
      Aunit.Reporter.Text'Elab_Spec;
      E205 := E205 + 1;
      Aunit.Test_Fixtures'Elab_Spec;
      E221 := E221 + 1;
      E219 := E219 + 1;
      Aunit.Test_Suites'Elab_Spec;
      E213 := E213 + 1;
      E211 := E211 + 1;
      Templates'Elab_Spec;
      Templates.Ast'Elab_Spec;
      E229 := E229 + 1;
      E247 := E247 + 1;
      E253 := E253 + 1;
      Templates.Parser'Elab_Body;
      E241 := E241 + 1;
      E255 := E255 + 1;
      E251 := E251 + 1;
      Templates'Elab_Body;
      E223 := E223 + 1;
      Templates_Diagnostics_Tests'Elab_Spec;
      Templates_Diagnostics_Tests'Elab_Body;
      E217 := E217 + 1;
      Templates_Html_Tests'Elab_Spec;
      Templates_Html_Tests'Elab_Body;
      E259 := E259 + 1;
      Templates_Parser_Tests'Elab_Spec;
      Templates_Parser_Tests'Elab_Body;
      E261 := E261 + 1;
      Templates_Public_Tests'Elab_Spec;
      Templates_Public_Tests'Elab_Body;
      E265 := E265 + 1;
      Templates_Renderer_Tests'Elab_Spec;
      Templates_Renderer_Tests'Elab_Body;
      E267 := E267 + 1;
      Templates_Values_Tests'Elab_Spec;
      Templates_Values_Tests'Elab_Body;
      E269 := E269 + 1;
      E215 := E215 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_test_runner");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_diagnostics_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_html_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_parser_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_public_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_renderer_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_values_tests.o
   --   /home/bent/Projekte/Ada/template/tests/obj/templates_test_suite.o
   --   /home/bent/Projekte/Ada/template/tests/obj/test_runner.o
   --   -L/home/bent/Projekte/Ada/template/tests/obj/
   --   -L/home/bent/Projekte/Ada/template/tests/obj/
   --   -L/home/bent/Projekte/Ada/template/lib/
   --   -L/home/bent/.local/share/alire/builds/aunit_26.0.0_b882e96a/78c67a8b011e08e5500962fc633efb7809a9c7391b64fc383bbaebb1096eadc4/lib/aunit/native-full/
   --   -L/home/bent/.local/share/alire/toolchains/gnat_native_15.2.1_4640d4b3/lib/gcc/x86_64-pc-linux-gnu/15.2.0/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
