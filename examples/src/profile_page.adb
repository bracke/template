with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Profile_Page is
   use Templates.Values;

   Source : constant String :=
     "<div class=""profile"">" & ASCII.LF &
     "  <h2>{{user.name}}</h2>" & ASCII.LF &
     "  {{#if user.email}}" & ASCII.LF &
     "    <p>{{user.email}}</p>" & ASCII.LF &
     "  {{/if}}" & ASCII.LF &
     "  <ul>" & ASCII.LF &
     "  {{#each user.roles}}" & ASCII.LF &
     "    <li>{{.}}</li>" & ASCII.LF &
     "  {{/each}}" & ASCII.LF &
     "  </ul>" & ASCII.LF &
     "</div>";

   T       : constant Templates.Template := Templates.Parse (Source);
   Context : Value := Object;
   User    : Value := Object;
   Roles   : Value := List;
begin
   Set (User, "name", String_Item ("Ada Lovelace"));
   Set (User, "email", String_Item ("ada@example.test"));
   Append (Roles, String_Item ("admin"));
   Append (Roles, String_Item ("developer"));
   Set (User, "roles", Roles);
   Set (Context, "user", User);

   Ada.Text_IO.Put_Line (Templates.Render (T, Context));
end Profile_Page;
