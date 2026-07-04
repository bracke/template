with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Basic is
   use Templates.Values;

   T       : constant Templates.Template :=
     Templates.Parse ("<p>Hello, {{name}}!</p>");
   Context : Value := Object;
begin
   Set (Context, "name", String_Item ("Ada & Lovelace"));
   Ada.Text_IO.Put_Line (Templates.Render (T, Context));
end Basic;
