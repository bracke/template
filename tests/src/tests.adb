with AUnit.Reporter.Text;
with AUnit.Run;
with Templates_Test_Suite;

procedure Tests is
   procedure Run is new AUnit.Run.Test_Runner (Templates_Test_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run (Reporter);
end Tests;
