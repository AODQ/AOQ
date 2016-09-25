  module AOQ.Types;

// Known symbols in an AOQ file
enum SymbolType {
  object,
  integer,
  floateger,
  stringeger,
  booleaner,
  nil
}

union CoreDataType {
  Obj objeger;
  int integer;
  bool booleaner;
  float floateger;
  string stringeger;
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
  UNKNOWN
};

enum DefaultMessageClass {
  // operators ---
  plus, minus, slash, asterik, percent, tilde, bslash,
  // functions ---
  stringify, _if
}

immutable(int[string]) DefaultMessageClass_map;
static this() {
  DefaultMessageClass_map = [
    // operators ---
    "+":  DefaultMessageClass.plus,    "-": DefaultMessageClass.minus,
    "/": DefaultMessageClass.slash,    "*": DefaultMessageClass.asterik,
    "%": DefaultMessageClass.percent,  "~": DefaultMessageClass.tilde,
    "\\": DefaultMessageClass.bslash,
    // functions ---
    "Stringify": DefaultMessageClass.stringify,
    "If":        DefaultMessageClass._if
  ];
}

immutable(string) Default_base_value_name = "__CORE__";

import AOQ.Backend.Obj;
alias Type_msg_2 = Obj function(Obj);
alias Type_msg_3 = Obj function(Obj, Obj);
