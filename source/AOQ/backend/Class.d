module AOQ.BE.Class;
import AOQ.BE.Obj;
import std.string : string;
import AOQ.BE.Exception;
import AOQ.BE.Functions;
import AOQ.Types;

class ClassString {
  string string_name;
  this(string _string_name) {
    string_name = _string_name;
  }
}

Class[] classes = [];
ClassString[int] classes_indices = [];

struct Class {
public:
  string class_name;
  int[string]  value_indices;
  string[]     value_names;
  SymbolType[] value_types;
  Type_msg_2[string] message_table_2;
  Type_msg_3[string] message_table_3;

  /// Construct class
  this(string _class_name) {
    class_name = _class_name;
    import AOQ.BE.Functions;
  }

  this(this) {
    class_name      = class_name.dup;
    value_indices   = value_indices.dup;
    value_names     = value_names.dup;
    value_types     = value_types.dup;
    message_table_2 = message_table_2.dup;
    message_table_3 = message_table_3.dup;
  }
}


void Construct_Default_Classes() {
  classes.length = SymbolType.max+1;
  classes_indices = [
    "Object",
    "Nil",
    "Integer",
    "+",
    "Stringeger"
  ];
  { // base_object
    auto _base_object = Class("object");
    _base_object.message_table_2 = [
      "R_ClassName"    : function(Obj r) {
        return Obj(r.base_class.class_name);
      },
      "Stringify"      : function(Obj r) {
        return Obj(r.base_class.class_name);
      }
    ];
    _base_object.message_table_3 = [
      "!"  : function(Obj r, Obj s) {
        return Obj();
      }
    ];
    classes[DefaultClass.object] = _base_object;
  }
  auto _base = classes[0];
  { // nil
    auto _nil = _base;
    _nil.class_name = "null";
    classes[DefaultClass.nil] = _nil;
    _nil.message_table_2["Stringify"] = function(Obj r) {
      return Obj("nil");
    };
  }
  { // integer
    auto _int = _base;
    _int.class_name = "integer";
    _int.value_indices = [Default_base_value_name: 0];
    _int.value_names   = [Default_base_value_name];
    _int.value_types   = [SymbolType.integer];
    // -- define functions
    _int.message_table_2["Stringify"] = function(Obj r) {
      import std.conv : to;
      return Obj(to!string(r.values[0].integer));
    };
    _int.message_table_3["+"] = function(Obj r, Obj s) {
      NonAOQFunc.Fn_Value_Length_Match(r, s);
      foreach ( i; 0 .. r.values.length ) {
        NonAOQFunc.Fn_Compatible_Values(r, s, i, i, "Op_Add");
        auto receiver_type = r.base_class.value_types[i],
             sender_type   = s.base_class.value_types[i];
        // TODO: use a mixin to generalize this
        switch ( receiver_type ) {
          default: assert(0);
          case SymbolType.integer:
            switch ( sender_type ) {
              default: assert(0);
              case SymbolType.integer:
                r.values[i].integer += s.values[i].integer;
              break;
            }
          break;
        }
      }
      return r;
    };
    _int.message_table_3["-"] = function(Obj r, Obj s) {
      NonAOQFunc.Fn_Value_Length_Match(r, s);
      foreach ( i; 0 .. r.values.length ) {
        if ( NonAOQFunc.Fn_Compatible_Values(r, s, i, i, "Op_Sub") ) {
          r.values[i].integer += s.values[i].integer;
        }
      }
      return r;
    };
    classes[DefaultClass.integer] = _int;
  }
  { // symbol + (TODO: expand to allow - etc)
    auto _symbol = _base;
    _symbol.class_name = "+";
    _symbol.message_table_2["Stringify"] = function(Obj r) {
      auto e = Obj(r.base_class.class_name);
      return e;
    };
    classes[DefaultClass.symbol] = _symbol;
  }
  { // stringeger
    auto _str = _base;
    _str.class_name = "String";
    _str.value_indices = [Default_base_value_name: 0];
    _str.value_names   = [Default_base_value_name];
    _str.value_types   = [SymbolType.stringeger];
    _str.message_table_2["Stringify"] = function(Obj r) {
      return r;
    };
    classes[DefaultClass.stringeger] = _str;
  }
  // -- set to classes
  // { // boolean
  //   // auto _bool = Class("boolean");
  //   // _bool.value_names = [Default_base_value_name: SymbolType.boolean];
  //   // classes ~= _bool;
  //   // _bool.message_table_3["="]
  // }
  // { // float
  //   // auto 
  // }
  // { // list
}
