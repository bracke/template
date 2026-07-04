with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

package body Templates.Values is

   use Ada.Strings.Unbounded;

   procedure Free is new Ada.Unchecked_Deallocation
     (Value_Data, Value_Data_Access);

   function New_Null_Data return Value_Data_Access is
   begin
      return new Value_Data'(Kind => Null_Value, Ref_Count => 1);
   end New_Null_Data;

   procedure Release (Ptr : in out Value_Data_Access) is
   begin
      if Ptr = null then
         return;
      end if;

      if Ptr.Ref_Count > 1 then
         Ptr.Ref_Count := Ptr.Ref_Count - 1;
         Ptr := null;
         return;
      end if;

      Free (Ptr);
   end Release;

   function Clone_Data (Ptr : Value_Data_Access) return Value_Data_Access is
   begin
      if Ptr = null then
         return New_Null_Data;
      end if;

      case Ptr.Kind is
         when Null_Value =>
            return New_Null_Data;
         when String_Value =>
            return new Value_Data'
              (Kind      => String_Value,
               Ref_Count => 1,
               Text      => Ptr.Text);
         when Boolean_Value =>
            return new Value_Data'
              (Kind      => Boolean_Value,
               Ref_Count => 1,
               Flag      => Ptr.Flag);
         when Object_Value =>
            return Result : Value_Data_Access := new Value_Data'
              (Kind      => Object_Value,
               Ref_Count => 1,
               Fields    => Field_Vectors.Empty_Vector)
            do
               for Field of Ptr.Fields loop
                  Result.Fields.Append (Field);
               end loop;
            end return;
         when List_Value =>
            return Result : Value_Data_Access := new Value_Data'
              (Kind      => List_Value,
               Ref_Count => 1,
               Items     => Value_Vectors.Empty_Vector)
            do
               for Item of Ptr.Items loop
                  Result.Items.Append (Item);
               end loop;
            end return;
      end case;
   end Clone_Data;

   procedure Ensure_Unique (Item : in out Value) is
      Old : Value_Data_Access;
   begin
      if Item.Handle.Data_Ptr = null then
         Item.Handle.Data_Ptr := New_Null_Data;
      elsif Item.Handle.Data_Ptr.Ref_Count > 1 then
         Old := Item.Handle.Data_Ptr;
         Item.Handle.Data_Ptr := Clone_Data (Old);
         Release (Old);
      end if;
   end Ensure_Unique;

   function Null_Item return Value is
   begin
      return Result : Value do
         Result.Handle.Data_Ptr := New_Null_Data;
      end return;
   end Null_Item;

   function String_Item (Text : String) return Value is
   begin
      return Result : Value do
         Result.Handle.Data_Ptr := new Value_Data'
           (Kind      => String_Value,
            Ref_Count => 1,
            Text      => To_Unbounded_String (Text));
      end return;
   end String_Item;

   function Boolean_Item (Flag : Boolean) return Value is
   begin
      return Result : Value do
         Result.Handle.Data_Ptr := new Value_Data'
           (Kind      => Boolean_Value,
            Ref_Count => 1,
            Flag      => Flag);
      end return;
   end Boolean_Item;

   function Object return Value is
   begin
      return Result : Value do
         Result.Handle.Data_Ptr := new Value_Data'
           (Kind      => Object_Value,
            Ref_Count => 1,
            Fields    => Field_Vectors.Empty_Vector);
      end return;
   end Object;

   function List return Value is
   begin
      return Result : Value do
         Result.Handle.Data_Ptr := new Value_Data'
           (Kind      => List_Value,
            Ref_Count => 1,
            Items     => Value_Vectors.Empty_Vector);
      end return;
   end List;

   procedure Set
     (Container : in out Value;
      Name      : String;
      Item      : Value)
   is
   begin
      if Kind (Container) /= Object_Value then
         return;
      end if;

      Ensure_Unique (Container);

      for Position in Container.Handle.Data_Ptr.Fields.First_Index ..
        Container.Handle.Data_Ptr.Fields.Last_Index
      loop
         if To_String (Container.Handle.Data_Ptr.Fields (Position).Name) = Name then
            Container.Handle.Data_Ptr.Fields.Replace_Element
              (Position,
               (Name => To_Unbounded_String (Name), Item => Item));
            return;
         end if;
      end loop;

      Container.Handle.Data_Ptr.Fields.Append
        (New_Item => Field_Entry'
           (Name => To_Unbounded_String (Name), Item => Item));
   end Set;

   procedure Append
     (Container : in out Value;
      Item      : Value)
   is
   begin
      if Kind (Container) /= List_Value then
         return;
      end if;

      Ensure_Unique (Container);
      Container.Handle.Data_Ptr.Items.Append (New_Item => Item);
   end Append;

   function Lookup
     (Container : Value;
      Name      : String)
      return Value
   is
   begin
      if Kind (Container) /= Object_Value then
         return Null_Item;
      end if;

      for Field of Container.Handle.Data_Ptr.Fields loop
         if To_String (Field.Name) = Name then
            return Field.Item;
         end if;
      end loop;

      return Null_Item;
   end Lookup;

   function Element
     (Container : Value;
      Index     : Positive)
      return Value
   is
   begin
      if Kind (Container) /= List_Value
        or else Index not in Container.Handle.Data_Ptr.Items.First_Index ..
          Container.Handle.Data_Ptr.Items.Last_Index
      then
         return Null_Item;
      end if;

      return Container.Handle.Data_Ptr.Items (Index);
   end Element;

   function Length (Container : Value) return Natural is
   begin
      case Kind (Container) is
         when Object_Value =>
            return Natural (Container.Handle.Data_Ptr.Fields.Length);
         when List_Value =>
            return Natural (Container.Handle.Data_Ptr.Items.Length);
         when others =>
            return 0;
      end case;
   end Length;

   function Kind (Item : Value) return Value_Kind is
   begin
      if Item.Handle.Data_Ptr = null then
         return Null_Value;
      end if;

      return Item.Handle.Data_Ptr.Kind;
   end Kind;

   function As_String (Item : Value) return String is
   begin
      if Kind (Item) = String_Value then
         return To_String (Item.Handle.Data_Ptr.Text);
      end if;

      return "";
   end As_String;

   function As_Boolean (Item : Value) return Boolean is
   begin
      return Kind (Item) = Boolean_Value and then Item.Handle.Data_Ptr.Flag;
   end As_Boolean;

   function Is_Truthy (Item : Value) return Boolean is
   begin
      case Kind (Item) is
         when Null_Value =>
            return False;
         when String_Value =>
            return As_String (Item)'Length > 0;
         when Boolean_Value =>
            return As_Boolean (Item);
         when Object_Value =>
            return True;
         when List_Value =>
            return Length (Item) > 0;
      end case;
   end Is_Truthy;

end Templates.Values;
