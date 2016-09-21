module AOQ.BE.Obj;
import std.string : string;
import AOQ.Types;
import AOQ.BE.Class;

union CoreDataType {
  Obj objeger;
  int integer;
  float floateger;
  string stringer;
}

struct Obj {
public:
  Class* base_class;
  CoreDataType[] values;
  this(SymbolType symbol) {
    class_index = symbol;
    switch ( symbol ) {
      case SymbolType.integer:
        values["CORE"] = 0;
        values[0].integer = 0;
      break;
      case SymbolType.floateger:
        values["CORE"] = 0;
        values[0].floateger = 0.0f;
      break;
      case SymbolType.stringeger:
        values["CORE"] = 0;
        values[0].stringeger = "";
      break;
      case SymbolType.variable:
      break;
      default:
      break;
    }
  }
  this(Class* _base_class) {
    base_class = _base_class;
    values.length = base_class.value_names.length;
    foreach ( n ; values.length )
      values[n].objeger = Obj(SymbolType.nil);
  }
  Obj Receive_Msg(Obj context) {
    return Call_Function(context.base_class.class_name);
  }
  Obj Receive_Msg(Obj sender, Obj context) {
    return Call_Function(sender, context.base_class.class_name);
  }
  /// Checks that functions exists and then calls it
  Obj Call_Function(string fn_name) {
    auto loc = (fn_name in message_table_2);
    if ( loc !is null ) {
      return (*loc)(r);
    }
    Throw_Exception("Calling non-existent function");
    return Obj();
  }
  /// Checks that functions exists and then calls it
  Obj Call_Function(string fn_name, Obj s) {
    auto loc = (fn_name in m);
    if ( loc !is null )
      return (*loc)(s);
    Throw_Exception("Calling non-existent function");
    return Obj();
  }
}
