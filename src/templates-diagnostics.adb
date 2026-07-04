with Ada.Strings.Fixed;

package body Templates.Diagnostics is

   function Image (Number : Positive) return String is
   begin
      return Ada.Strings.Fixed.Trim
        (Positive'Image (Number),
         Ada.Strings.Both);
   end Image;

   function Message
     (Line    : Positive;
      Column  : Positive;
      Message : String)
      return String
   is
   begin
      return "template parse error at line " & Image (Line) & ", column " &
        Image (Column) & ": " & Message;
   end Message;

   procedure Raise_Error
     (Line    : Positive;
      Column  : Positive;
      Message : String)
   is
   begin
      raise Templates.Template_Error with Templates.Diagnostics.Message
        (Line, Column, Message);
   end Raise_Error;

end Templates.Diagnostics;
