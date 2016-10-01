module AOQ.Backend.Obj;
import std.string : string;
import AOQ.Types;
import AOQ.Backend.Class;
import AOQ.Util;

string CoreDataType_To_String(CoreDataType cdt, SymbolType t) {
  import std.conv : to;
  switch ( t ) {
    default: assert(0);
    case SymbolType.stringeger: return cdt.stringeger;
    case SymbolType.floateger:  return to!string(cdt.floateger);
    case SymbolType.integer:    return to!string(cdt.integer);
    case SymbolType.object:
      return cdt.objeger.Call_Function("Stringify").values[0].stringeger;
  }
}

struct Obj {
  void Make_An_Integer(int i) {
    base_class = &classes[DefaultClass.integer];
    values.length = 1;
    values[0].integer = i;
  }
  void Make_A_Floateger(float i) {
    base_class = &classes[DefaultClass.floateger];
    values.length = 1;
    values[0].floateger = i;
  }
  void Make_A_String(string str) {
    base_class = &classes[DefaultClass.stringeger];
    values.length = 1;
    values[0].stringeger = str;
  }
  void Make_A_Bool(bool i) {
    base_class = &classes[DefaultClass.booleaner];
    values.length = 1;
    values[0].booleaner = i;
  }
public:
  Class* base_class;
  CoreDataType[] values;

  this(SymbolType symbol) {
    switch ( symbol ) {
      case SymbolType.integer:
        Make_An_Integer(0);
      break;
      case SymbolType.floateger:
        Make_A_Floateger(0.0f);
      break;
      case SymbolType.stringeger:
        Make_A_String("");
      break;
      case SymbolType.booleaner:
        Make_A_Bool(false);
      break;
      case SymbolType.nil:
        base_class = &classes[DefaultClass.nil];
      break;
      default: assert(0);
    }
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
        case SymbolType.integer:
          values[n].integer = 0;
        break;
        case SymbolType.floateger:
          values[n].floateger = 0.0f;
        break;
        case SymbolType.stringeger:
          values[n].stringeger = "";
        break;
        // case SymbolType.object:
        //   values[n] = Ob
        // break;
      }
    }
  }
  // this(Obj[] i) {
  //   this = Create(i);
  // }
  static Obj Create(DefaultClass _class) {
    return Obj(&classes[_class]);
  }
  static Obj Create(Obj[] i) {
    auto obj = Obj();
    obj.base_class = &classes[DefaultClass.array];
    obj.values.length = 1;
    obj.values[0].array = i;
    return obj;
  }
  static Obj Create(DefaultMessageClass _class) {
    return Obj(&symbol_classes[_class]);
  }
  static Obj Construct_Default() {
    return Obj(&classes[DefaultClass.nil]);
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
  string R_String_Value(size_t index) {
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
