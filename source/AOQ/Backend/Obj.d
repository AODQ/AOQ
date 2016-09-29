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
  void Activate(int value) {
    obj.values.length = 1;
    mixin(`obj.values[0].`~sym_type~` = value;`);
    Finalize_Make(obj);
  }
};

// private mixin template Make_Func(string f) {
//   mixin("static void Make_A_"~f~"(ref Obj obj, "~f
// }

struct Obj {
  static void Finalize_Make(ref Obj obj) {
    import Env = AOQ.Backend.Enviornment;
    Env.Push_Object(new Obj(obj));
  }
  static void Make_An_Object(ref Obj obj) {
    auto value_types = obj.base_class.value_types;
    obj.values.length = value_types.length;
    foreach ( i; 0 .. value_types.length ) {
      obj.values[i].objeger = Obj.Create(DefaultType.nil);
    }
  }
  static void Make_An_Integer(ref Obj obj, int i) {
    mixin Make_A_Thing!("integer", obj);
    Activate(i);
  }
  static void Make_A_Floateger(ref Obj obj, float i) {
    mixin Make_A_Thing!("floateger", obj);
    Activate(i);
  }
  static void Make_A_String(ref Obj obj, string i) {
    mixin Make_A_Thing!("stringeger", obj);
    Activate(i);
  }
  static void Make_A_Bool(ref Obj obj, bool i) {
    mixin Make_A_Thing!("booleaner", obj);
    Activate(i);
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
        Make_An_Integer(0);
      break;
      case DefaultType.floateger:
        Make_A_Floateger(0.0f);
      break;
      case DefaultType.stringeger:
        Make_A_String("");
      break;
      case DefaultType.booleaner:
        Make_A_Bool(false);
      break;
      case DefaultType.objeger: case DefaultType.nil:

        Make_An_Object(
      break;
      case DefaultType.nil:
        base_class = &classes[DefaultType.nil];
      break;
      default: assert(0);
    }
  }
  // copy
  void Create(Obj o) {
    Finalize_Make(o);
  }
  this(string str) {
    Make_A_String(str);
  }
  this(int i) {
    Make_An_Integer(i);
  }
  this(float i) {
    Make_A_Floateger(i);
  }
  this(bool i) {
    Make_A_Bool(i);
  }
  this(Class* _base_class) {
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
  }
  // this(Obj[] i) {
  //   this = Create(i);
  // }
  static Obj Create(DefaultType _class) {
    return Obj(&classes[_class]);
  }
  static Obj Create(Obj[] i) {
    auto obj = Obj();
    obj.base_class = &classes[DefaultType.array];
    obj.values.length = 1;
    obj.values[0].array = i;
    return obj;
  }
  static Obj Create(DefaultMessageClass _class) {
    return Obj(&symbol_classes[_class]);
  }
  static Obj Construct_Default() {
    return Obj(&classes[DefaultType.nil]);
  }
  Obj Receive_Msg(Obj context) {
    { // ---  DEBUG ---
      import std.stdio;
      // writeln("RECEIVED MESSAGE: ", msg_name.values[0].stringeger);
    } // --- EDEBUG ---
    auto msg_name = context.Call_Function("Stringify");
    return Call_Function(msg_name.values[0].stringeger);
  }
  Obj Receive_Msg(Obj sender, Obj context) {
    auto msg_name = context.Call_Function("Stringify");
    // { // ---  DEBUG ---
    //   import std.stdio;
    //   writeln("RECEIVED MESSAGE: ", msg_name.values[0].stringeger);
    // } // --- EDEBUG ---
    return Call_Function(msg_name.values[0].stringeger, sender);
  }
  import AOQ.Backend.Exception;
  /// Checks that functions exists and then calls it
  Obj Call_Function(string label) {
    auto loc = (label in base_class.message_table_2);
    if ( loc !is null ) {
      return (*loc)(this);
    }
    Throw_Exception("Communication undefined: (" ~ label ~ " "
                                                ~ Stringify ~ ")");
    return Obj();
  }
  /// Checks that functions exists and then calls it
  Obj Call_Function(string label, Obj s) {
    auto loc = (label in base_class.message_table_3);
    if ( loc !is null )
      return (*loc)(this, s);
    Throw_Exception("Communication undefined: (" ~ label ~ " "
                     ~ Stringify ~ " " ~ s.Stringify ~ ")");
    return Obj();
  }
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
