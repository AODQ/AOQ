module AOQ.Class;
import AOQ.BE.Obj;
import std.string : string;

Class[] classes = [
  new Class()
];

class Class {
public:
  string class_name;
  alias Type_msg_2 = Obj function(ref Obj);
  alias Type_msg_3 = Obj function(ref Obj, Obj);
  Type_msg_2[string] message_table_2;
  Type_msg_3[string] message_table_3;

  this() {
    class_name = "Object";
  }
  this(string _class_name) {
    class_name = _class_name;
    import AOQ.BE.Functions;
    message_table_2 = [
      "R_Name"        : Def_R_Name,
      "R_ClassName"   : Def_R_ClassName,
      "Op_Constraits" : Def_Constraints
    ];
  }
}

void Construct_Default_Classes() {
  { // integer
    [
      "Op_Sub"  : Def_Sub,
      "Op_Div"  : Def_Divide,
      "Op_Mult" : Def_Multiply,
    ];
  }
  { // float
  }
  { // list
  }
}

