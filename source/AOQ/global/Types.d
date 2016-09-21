module AOQ.Types;

// Known symbols in an AOQ file
enum SymbolType {
  object,
  integer,
  floateger,
  stringeger,
  boolean
}

// default classes in AOQ
enum DefaultClass {
  object,
  nil,
  integer,
  sym_add,
  stringeger,
};

immutable(string) Default_base_value_name = "__CORE__";

import AOQ.BE.Obj;
alias Type_msg_2 = Obj function(Obj);
alias Type_msg_3 = Obj function(Obj, Obj);