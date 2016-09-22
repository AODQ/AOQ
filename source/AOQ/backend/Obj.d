module AOQ.BE.Obj;
import std.string : string;
import AOQ.Types;
import AOQ.BE.Class;

union CoreDataType {
  Obj objeger;
  int integer;
  float floateger;
  string stringeger;
}

string CoreDataType_To_String(CoreDataType cdt, SymbolType t) {
  import std.conv : to;
  switch ( t ) {
    default: assert(0);
    case SymbolType.integer:
      return to!string(cdt.integer);
  }
}

struct Obj {
  void Make_An_Integer(int i) {
    base_class = &classes[DefaultClass.integer];
    values.length = 1;
    values[0].integer = 0;
  }
  void Make_A_String(string str) {
  // ---  DEBUG ---
  import std.stdio : writeln;
  writeln("CLASS: ", cast(int)DefaultClass.stringeger, ", THEN: ",
                     classes[DefaultClass.stringeger]);
  // --- EDEBUG ---
    base_class = &classes[DefaultClass.stringeger];
    values.length = 1;
    values[0].stringeger = "";
  }
public:
  Class* base_class;
  CoreDataType[] values;
  this(SymbolType symbol) {
    switch ( symbol ) {
      case SymbolType.integer:
        Make_An_Integer(0);
      break;
      // case SymbolType.floateger:
      //   base_class = classes[DefaultClass.integer];
      //   values["CORE"] = 0;
      //   values[0].floateger = 0.0f;
      // break;
      case SymbolType.stringeger:
        Make_A_String("");
      break;
      default: assert(0);
    }
  }
  this(string str) {
    // ---  DEBUG ---
    import std.stdio : writeln;
    writeln("MAKING A STRING: " ~ str);
    // --- EDEBUG ---
    Make_A_String(str);
    // ---  DEBUG ---
    import std.stdio : writeln;
    writeln("BASE CLASS: ", base_class);
    // --- EDEBUG ---
  }
  this(int i) {
    Make_An_Integer(i);
  }
  this(Class* _base_class) {
    // ---  DEBUG ---
    import std.stdio : writeln;
    writeln("SETTING TO: ", base_class, " , + ", classes[DefaultClass.symbol]);
    // --- EDEBUG ---
    base_class = _base_class;
    values.length = base_class.value_names.length;
    foreach ( n ; 0 .. values.length )
      values[n].objeger = Obj(SymbolType.object);
  }
  Obj Receive_Msg(Obj context) {
    auto msg_name = context.Call_Function("Stringify");
    { // ---  DEBUG ---
      import std.stdio;
      writeln("RECEIVED MESSAGE: ", msg_name.values[0].stringeger);
    } // --- EDEBUG ---
    return Call_Function(msg_name.values[0].stringeger);
  }
  Obj Receive_Msg(Obj sender, Obj context) {
    auto msg_name = context.Call_Function("Stringify");
    { // ---  DEBUG ---
      import std.stdio;
      writeln("RECEIVED MESSAGE: ", msg_name);
      writeln("RECEIVED MESSAGE: ", msg_name.values[0].stringeger);
    } // --- EDEBUG ---
    return Call_Function(msg_name.values[0].stringeger, sender);
  }
  import AOQ.BE.Exception;
  /// Checks that functions exists and then calls it
  Obj Call_Function(string fn_name) {
    auto loc = (fn_name in base_class.message_table_2);
    if ( loc !is null ) {
      return (*loc)(this);
    }
    Throw_Exception("Calling non-existent function: " ~ fn_name);
    return Obj();
  }
  /// Checks that functions exists and then calls it
  Obj Call_Function(string fn_name, Obj s) {
    auto loc = (fn_name in base_class.message_table_3);
    if ( loc !is null )
      return (*loc)(this, s);
    Throw_Exception("Calling non-existent function: " ~ fn_name);
    return Obj();
  }
  string R_String_Value(ulong index) {
  // ---  DEBUG ---
  import std.stdio : writeln;
  // ---  DEBUG ---
  import std.stdio : writeln;
  writeln("BASE CLASS: ", base_class);
  // --- EDEBUG ---
writeln("BASE_CLASS: ", base_class.class_name, " LEN: ",
                          base_class.value_types.length,
                        " COMP: ",
                          values.length);
  // --- EDEBUG ---
    return CoreDataType_To_String(values[index],
                  base_class.value_types[index]);
  }
}
