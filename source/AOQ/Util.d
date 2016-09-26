module AOQ.Util;

bool Find_Sym(ref string str, ref int it, char c, bool skip = false) {
  while ( it < str.length && (skip ? str[it] == c :
                                     str[it] != c) ) ++ it;
  return it < str.length;
}

void Parse_Err(string str, bool expression = false) {
  import std.stdio : writeln;
  if ( expression ) {
    writeln(str);
    import std.c.stdlib;
    exit(-1);
  }
}

bool Is_Operator(char c) {
  return (c == '.' || c == '=' || c == '+' || c == '-' || c == '/' || c == ':'
       || c == '~' || c == '\\'|| c == '^' || c == '*' );
}

enum PrintLevel {
  none, warnings, sparse, verbose
}

private PrintLevel print_level;

void Set_Print_Level(PrintLevel _print_level) {
  print_level = _print_level;
}

void Print(S...)(S args) {
  if ( cast(int)print_level > PrintLevel.none ) {
    import std.stdio : writeln;
    writeln(args);
  }
};
