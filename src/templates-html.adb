with Ada.Strings.Unbounded;

package body Templates.Html is

   use Ada.Strings.Unbounded;

   function Escape (Text : String) return String is
      Result : Unbounded_String;
   begin
      for Ch of Text loop
         case Ch is
            when '&' =>
               Append (Result, "&amp;");
            when '<' =>
               Append (Result, "&lt;");
            when '>' =>
               Append (Result, "&gt;");
            when '"' =>
               Append (Result, "&quot;");
            when ''' =>
               Append (Result, "&#39;");
            when others =>
               Append (Result, Ch);
         end case;
      end loop;

      return To_String (Result);
   end Escape;

end Templates.Html;
