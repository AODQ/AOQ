module AOQ.BE.Class;
import AOQ.BE.Obj;
import std.string : string;
import AOQ.BE.Exception;
import AOQ.BE.Functions;
import AOQ.Types;

Class[] classes = [];

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
}


void Construct_Default_Classes() {
  classes.length = SymbolType.max+1;
  { // base_object
    auto _base_object = Class("object");
    _base_object.message_table_2 = [
      "R_Name"         : function(Obj r) {
        Throw_Exception("Not yet implemented");
        return Obj();
      },
      "R_ClassName"    : function(Obj r) {
        return Obj(r.base_class.class_name);
      },
      "Stringify"      : function(Obj r) {
      // ---  DEBUG ---
      import std.stdio : writeln;
      writeln("ATTEMPING TO STRINGIFY");
      // --- EDEBUG ---
        import std.conv : to;
        string s = "{\n  ";
        auto bcl = r.base_class;
        foreach ( n ; 0 .. bcl.value_types.length ) {
          s ~= "\"" ~ to!string(bcl.value_names[n]) ~ "\"" ~
               " (" ~ to!string(bcl.value_types[n]) ~ ") " ~
               "= " ~          r.R_String_Value(n) ~ ";\n";
        }
        s ~= "}";
        return Obj(s);
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
  }
  { // integer
    auto _int = _base;
    _int.class_name = "integer";
    _int.value_indices = [Default_base_value_name: 0];
    _int.value_names   = [Default_base_value_name];
    _int.value_types   = [SymbolType.integer];
    // -- define functions
    _int.message_table_3["+"] = function(Obj r, Obj s) {
      NonAOQFunc.Fn_Value_Length_Match(r, s);
      foreach ( i; 0 .. r.values.length ) {
        NonAOQFunc.Fn_Compatible_Values(r, s, i, i, "Op_Add");
        auto receiver_type = r.base_class.value_types[i],
             sender_type   = s.base_class.value_types[i];
        // TODO: use a mixin to generalize this
        switch ( receiver_type ) {
          default: assert(0);
          // case SymbolType.object:
          //   switch ( sender_type ) {
          //     case SymbolType.object:
          //       r.object.Receive_Msg(s.object, fn);
          //     break;
          //   }
          // break;
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
  { // sym_add
    auto _sym_add = _base;
    _sym_add.class_name = "+";
    classes[DefaultClass.sym_add] = _sym_add;
  }
  { // stringeger
    auto _str = _base;
    _str.class_name = "String";
    _str.value_indices = [Default_base_value_name: 0];
    _str.value_names   = [Default_base_value_name];
    _str.value_types   = [SymbolType.stringeger];
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
