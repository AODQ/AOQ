  module AOQ.Types;

// Known symbols in an AOQ file
enum SymbolType {
  object,
  integer,
  floateger,
  stringeger,
  boolean
}

union CoreDataType {
  Obj objeger;
  int integer;
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
  floateger
};

immutable(string) Default_base_value_name = "__CORE__";

import AOQ.Backend.Obj;
alias Type_msg_2 = Obj function(Obj);
alias Type_msg_3 = Obj function(Obj, Obj);
