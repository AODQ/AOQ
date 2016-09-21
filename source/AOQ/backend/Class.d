module AOQ.BE.Class;
import AOQ.BE.Obj;
import std.string : string;
import AOQ.BE.Exception;

Class[] classes = [];

struct Class {
public:
  string class_name;
  int[string] value_indices;
  string[]    value_names;
  alias Type_msg_2 = Obj function(ref Obj);
  alias Type_msg_3 = Obj function(ref Obj, Obj);
  Type_msg_2[string] message_table_2;
  Type_msg_3[string] message_table_3;

  /// Construct class
  this(string _class_name) {
    class_name = _class_name;
    import AOQ.BE.Functions;
  }
}


void Construct_Default_Classes() {
  classes.length = SymbolType.size;
  { // base_object
    auto _base_object = new Class("object");
    message_table_2 = [
      "R_Name"         : function(Obj r) {
        Throw_Exception("Not yet implemented");
        return Obj();
      },
      "R_ClassName"    : function(Obj r) {
        return classes[r.class_index];
      },
      "Op_Constraint"  : function(Obj r, Obj s) {
        return Obj();
      }
    ];
    classes[Default_classes.object] = _base_object;
  }
  auto _base = classes[0];
  { // nil
    auto _nil = _base;
    classes[Default_classes.object] = _nil;
    classes[Default_classes.nil] = _nil;
  }
  { // integer
    auto _int = _base;
    _int.class_name = "integer";
    _int.value_names = [Default_base_value_name: SymbolType.integer];
    // -- define functions
    _int.message_table_3["+"] =function(Obj r, Obj s) {
      NonAOQFunc.Fn_Value_Length_Match(r, s);
      foreach ( i; 0 .. r.values.length ) {
        if ( NonAOQFunc.Fn_Compatible_Values(r, s, i, i, "Op_Add") ) {
          r.values[i] += s.values[i];
        }
      }
      return r;
    };
    _int.message_table_3["-"] = function(Obj r, Obj s) {
      NonAOQFunc.Fn_Value_Length_Match(r, s);
      foreach ( i; 0 .. r.values.length ) {
        if ( NonAOQFunc.Fn_Compatible_Values(r, s, i, i, "Op_Sub") ) {
          r.values[i] += s.values[i];
        }
      }
    };
  }
  { // sym_add
    auto _sym_add = _base;
    _sym_add.class_name = "+";
  }
  // -- set to classes
  // { // boolean
  //   // auto _bool = new Class("boolean");
  //   // _bool.value_names = [Default_base_value_name: SymbolType.boolean];
  //   // classes ~= _bool;
  //   // _bool.message_table_3["="]
  // }
  // { // float
  //   // auto 
  // }
  // { // list
  // }
}

