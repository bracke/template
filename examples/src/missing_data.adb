with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Missing_Data is
   use Templates.Values;

   Source : constant String :=
     "Name={{name}}" & ASCII.LF &
     "Email={{email}}" & ASCII.LF &
     "{{#if email}}email exists{{/if}}" & ASCII.LF &
     "{{#each roles}}role={{.}}{{/each}}";

   T       : constant Templates.Template := Templates.Parse (Source);
   Context : Value := Object;
begin
   Set (Context, "name", String_Item ("Ada"));
   Ada.Text_IO.Put_Line (Templates.Render (T, Context));
end Missing_Data;
