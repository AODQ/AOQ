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
  sym_add
};


immutable(string) Default_base_value_name = "__CORE__";
