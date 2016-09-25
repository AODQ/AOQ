module AOQ.Parser.Util;

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
  return (c == '.' || c == '=' || c == '+' || c == '-' || c == '/' || c == ':');
}
