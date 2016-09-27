  module AOQ.Types;

// Known symbols in an AOQ file
enum SymbolType {
  object,
  integer,
  floateger,
  stringeger,
  booleaner,
  array,
  nil
}

union CoreDataType {
  Obj    objeger;
  int    integer;
  bool   booleaner;
  float  floateger;
  string stringeger;
  Obj[]  array;
}


// default classes in AOQ
enum DefaultClass {
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
  _class,
}

immutable(int[string]) DefaultMessageClass_map;
static this() {
  DefaultMessageClass_map = [
    // operators ---
    "+":  DefaultMessageClass.plus,    "-": DefaultMessageClass.minus,
    "/": DefaultMessageClass.slash,    "*": DefaultMessageClass.asterik,
    "%": DefaultMessageClass.percent,  "~": DefaultMessageClass.tilde,
    "\\": DefaultMessageClass.bslash,  "^": DefaultMessageClass.caret,
    "." : DefaultMessageClass.dot,
    // standard ---
    "Stringify": DefaultMessageClass.stringify,
    "If":        DefaultMessageClass._if,
    "Loop":      DefaultMessageClass.loop,
    "Loop_Sum":  DefaultMessageClass.loop_sum,
    "Range":     DefaultMessageClass.range,
    "Cast":      DefaultMessageClass._cast,
    "Class":     DefaultMessageClass._class,
    // class related ---
  ];
}

immutable(string) Default_base_value_name = "__CORE__";

import AOQ.Backend.Obj;
alias Type_msg_2 = Obj function(Obj);
alias Type_msg_3 = Obj function(Obj, Obj);
