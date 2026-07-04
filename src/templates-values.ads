package Templates.Values is

   subtype Value_Kind is Templates.Value_Kind;
   Null_Value    : constant Value_Kind := Templates.Null_Value;
   String_Value  : constant Value_Kind := Templates.String_Value;
   Boolean_Value : constant Value_Kind := Templates.Boolean_Value;
   Object_Value  : constant Value_Kind := Templates.Object_Value;
   List_Value    : constant Value_Kind := Templates.List_Value;

   subtype Value is Templates.Value;

   --  Create a null value.
   --  @return null value
   function Null_Item return Value;

   --  Create a string value.
   --  @param Text string content
   --  @return string value
   function String_Item (Text : String) return Value;

   --  Create a boolean value.
   --  @param Flag boolean content
   --  @return boolean value
   function Boolean_Item (Flag : Boolean) return Value;

   --  Create an empty object value.
   --  @return object value
   function Object return Value;

   --  Create an empty list value.
   --  @return list value
   function List return Value;

   --  Set or replace an object field.
   --  @param Container object value to mutate
   --  @param Name field name
   --  @param Item field value
   procedure Set
     (Container : in out Value;
      Name      : String;
      Item      : Value);

   --  Append an item to a list value.
   --  @param Container list value to mutate
   --  @param Item item value
   procedure Append
     (Container : in out Value;
      Item      : Value);

   --  Look up an object field.
   --  @param Container object value
   --  @param Name field name
   --  @return field value, or null for missing/non-object values
   function Lookup
     (Container : Value;
      Name      : String)
      return Value;

   --  Return a list element by one-based index.
   --  @param Container list value
   --  @param Index one-based list index
   --  @return element value, or null for out-of-range/non-list values
   function Element
     (Container : Value;
      Index     : Positive)
      return Value;

   --  Return the length of an object or list value.
   --  @param Container value to inspect
   --  @return number of fields/items, or zero for scalar values
   function Length (Container : Value) return Natural;

   --  Return the value kind.
   --  @param Item value to inspect
   --  @return value kind
   function Kind (Item : Value) return Value_Kind;

   --  Return string content.
   --  @param Item value to inspect
   --  @return string content, or empty string for non-string values
   function As_String (Item : Value) return String;

   --  Return boolean content.
   --  @param Item value to inspect
   --  @return boolean content, or false for non-boolean values
   function As_Boolean (Item : Value) return Boolean;

   --  Return template truthiness for a value.
   --  @param Item value to inspect
   --  @return true when the value is truthy
   function Is_Truthy (Item : Value) return Boolean;

end Templates.Values;
