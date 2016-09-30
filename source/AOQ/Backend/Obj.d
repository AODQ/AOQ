module AOQ.Backend.Obj;
import std.string : string;
import AOQ.Types;
import AOQ.Backend.Class;
import AOQ.Util;

string CoreDataType_To_String(CoreDataType cdt, DefaultType t) {
  import std.conv : to;
  switch ( t ) {
    default: assert(0);
    case DefaultType.stringeger: return cdt.stringeger;
    case DefaultType.floateger:  return to!string(cdt.floateger);
    case DefaultType.integer:    return to!string(cdt.integer);
    case DefaultType.object:
      return cdt.objeger.Call_Function("Stringify").values[0].stringeger;
  }
}

private mixin template Make_A_Thing(string sym_type, alias obj) {
  Obj* Activate(T)(T value, ref Class _class) {
    auto obj = new Obj();
    obj.base_class = _class;
    obj.values.length = 1;
    mixin(`obj.values[0].`~sym_type~` = value;`);
    return Obj.Finalize_Make(obj);
  }
};

struct Obj {
  static Obj* Finalize_Make(ref Obj obj) {
    import Env = AOQ.Backend.Enviornment;
    Obj* obj = new Obj(obj);
    Env.Push_Object(obj);
    return obj;
  }
public:
  // ----- DATA -----
  Class* base_class;
  CoreDataType[] values;

  this(this) {
    values = values.dup();
  }

  // ----- Create functions -----
  void Create(DefaultType type) {
    auto obj = Obj();
    obj.base_class = &classes[cast(int)type];
    switch ( type ) {
      case DefaultType.integer:
        Make_An_Integer(obj, 0);
      break;
      case DefaultType.floateger:
        Make_A_Floateger(obj, 0.0f);
      break;
      case DefaultType.stringeger:
        Make_A_String(obj, "");
      break;
      case DefaultType.booleaner:
        Make_A_Bool(obj, false);
      break;
      case DefaultType.objeger: case DefaultType.nil:
        Make_An_Object(obj, obj);
      break;
      case DefaultType.nil:
        base_class = &classes[DefaultType.nil];
      break;
      default: assert(0);
    }
  }
  // copy
  static void Make_An_Object(ref Obj obj) {
    auto value_types = obj.base_class.value_types;
    obj.values.length = value_types.length;
    foreach ( i; 0 .. value_types.length ) {
      obj.values[i].objeger = Obj.Create(DefaultType.nil);
    }
  }
  static Obj* Create(int i) {
    mixin Make_A_Thing!("integer", obj);
    return Activate(i, DefaultType.integer);
  }
  static Obj* Create(float i) {
    mixin Make_A_Thing!("floateger", obj);
    return Activate(i);
  }
  static Obj* Create(string i) {
    mixin Make_A_Thing!("stringeger", obj);
    return Activate(i);
  }
  static Obj* Create(bool i) {
    mixin Make_A_Thing!("booleaner", obj);
    return Activate(i);
  }
  static Obj Create(DefaultType _class) {
    return Create(&classes[_class]);
  }
  static Obj Create(DefaultMessageClass _class) {
    return Create(&symbol_classes[_class]);
  }
  static Obj Create(Obj[] i) {
    auto obj = Obj();
    obj.base_class = &classes[DefaultType.array];
    obj.values.length = 1;
    obj.values[0].array = i;
    return obj;
  }
  static Obj* Create(Class* _base_class) {
    Obj obj = new Obj();
    base_class = _base_class;
    values.length = base_class.value_names.length;
    foreach ( n; 0 .. values.length ) {
      switch ( base_class.value_types[n] ) {
        default: assert(0);
        case DefaultType.integer:
          values[n].integer = 0;
        break;
        case DefaultType.floateger:
          values[n].floateger = 0.0f;
        break;
        case DefaultType.stringeger:
          values[n].stringeger = "";
        break;
        // case DefaultType.object:
        //   values[n] = Ob
        // break;
      }
    }
    Finalize_Make(obj);
  }
  Obj* Receive_Msg(Obj* sender, Obj* context) {
    import Env = AOQ.Backend.Enviornment;
    auto label = context.Call_Function("Stringify");
    auto loc = (label in (sender is null ? base_class.message_table_2
                                         : base_class.message_table_3));
    if ( loc !is null ) {
      Env.Push_Scope();
      Obj* ret = sender is null ? (*loc)(this) : (*loc)(this, s);
      Obj* n   = new Obj(*ret);
      Env.Pop_Scope();
      Env.Push_Object(n);
      return n;
    }
    Throw_Exception("Communication undefined: (" ~ label ~ " " ~ Stringify
                    ~ (sender is null ? "" : (" " ~ s.Stringify)) ~ ")");
    assert(0);
  }
  Obj* Receive_Msg(Obj* context) {
    return Receive_Msg(null, context);
  }
  /// Checks that functions exists and then calls it
  string R_String_Value(ulong index) {
  // --- EDEBUG ---
    return CoreDataType_To_String(values[index],
                  base_class.value_types[index]);
  }
  /// Returns a string that represents this object as a label
  string Stringify() {
    if ( base_class == null ) return "NULL";
    return Call_Function("Stringify").values[0].stringeger;
  }
  /// Returns an object that represents this object's value
  Obj Valueify() {
    if ( base_class == null ) {
      Throw_Exception("Class has no base");
    }
    return Call_Function("Valueify");
  }
  /// Returns a bool that represents the truthines of this object
  bool Truthity() {
    if ( base_class == null ) {
      Throw_Exception("Class has no base (AoQ bug?)");
      assert(0);
    }
    return Receive_Msg(Obj("Truthity")).values[0].booleaner;
  }
  /// useful for debugging
  void Print() {
    Receive_Msg(Obj("Print"));
  }
  Obj Cast(T)(T castee_class) {
    Obj castee = Obj(castee_class);
    return Call_Function("Cast", castee);
  }
}
