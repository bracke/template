package Templates.Diagnostics is

   --  Build a template parse error message.
   --  @param Line one-based source line
   --  @param Column one-based source column
   --  @param Message diagnostic text
   --  @return formatted diagnostic message
   function Message
     (Line    : Positive;
      Column  : Positive;
      Message : String)
      return String;

   --  Raise Templates.Template_Error with a formatted parse diagnostic.
   --  @param Line one-based source line
   --  @param Column one-based source column
   --  @param Message diagnostic text
   procedure Raise_Error
     (Line    : Positive;
      Column  : Positive;
      Message : String);

end Templates.Diagnostics;
