with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Parse_Once is
   use Templates.Values;

   T : constant Templates.Template :=
     Templates.Parse ("<p>{{name}}: {{#each tags}}<span>{{.}}</span>{{/each}}</p>");

   function Context_For
     (Name      : String;
      First_Tag : String;
      Last_Tag  : String)
      return Value
   is
      Context : Value := Object;
      Tags    : Value := List;
   begin
      Set (Context, "name", String_Item (Name));
      Append (Tags, String_Item (First_Tag));
      Append (Tags, String_Item (Last_Tag));
      Set (Context, "tags", Tags);
      return Context;
   end Context_For;
begin
   Ada.Text_IO.Put_Line
     (Templates.Render (T, Context_For ("Ada", "math", "code")));
   Ada.Text_IO.Put_Line
     (Templates.Render (T, Context_For ("Grace", "navy", "compiler")));
end Parse_Once;
