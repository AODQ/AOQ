  module AOQ.Types;

union CoreDataType {
  Obj    objeger;
  int    integer;
  bool   booleaner;
  float  floateger;
  string stringeger;
  Obj[]  array;
}


// default classes in AOQ that form the CoreDataType
enum DefaultType {
  object,
  nil,
  integer,
  symbol,
  stringeger,
  floateger,
  booleaner,
  array,
  UNKNOWN,
};

enum DefaultMessageClass {
  // operators ---
  plus, minus, slash, asterik, percent, tilde, bslash, caret, dot,
  // standard ---
  stringify, _if, loop, loop_sum, range, _cast,
  // class related ---
<<<<<<< Updated upstream
  _class, class_name, _new, class_body, class_declaration,
  class_definition,
=======
  _class, class_name, _new, class_message_name, class_message_params,
  class_message_body, class_message_header,
  unparsed_object,
>>>>>>> Stashed changes
}

int[string] message_map;
static this() {
  message_map = [
    // operators ---
    "+":  DefaultMessageClass.plus,    "-":  DefaultMessageClass.minus,
    "/":  DefaultMessageClass.slash,   "*":  DefaultMessageClass.asterik,
    "%":  DefaultMessageClass.percent, "~":  DefaultMessageClass.tilde,
    "\\": DefaultMessageClass.bslash,  "^":  DefaultMessageClass.caret,
    "." :               DefaultMessageClass.dot,
    // standard ---
    "Stringify":        DefaultMessageClass.stringify,
    "If":               DefaultMessageClass._if,
    "Loop":             DefaultMessageClass.loop,
    "LoopSum":          DefaultMessageClass.loop_sum,
    "Range":            DefaultMessageClass.range,
    "Cast":             DefaultMessageClass._cast,
    // class related ---
    "Class":            DefaultMessageClass._class,
    "ClassName":        DefaultMessageClass.class_name,
    "New":              DefaultMessageClass._new,
    "ClassBody":        DefaultMessageClass.class_body,
    "ClassDeclaration": DefaultMessageClass.class_declaration,
    "ClassDefinition":  DefaultMessageClass.class_definition,
  ];
}

immutable(string) Default_base_value_name = "__CORE__";

import AOQ.Backend.Obj;
alias Type_msg_2 = Obj function(Obj);
alias Type_msg_3 = Obj function(Obj, Obj);
