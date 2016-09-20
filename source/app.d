static import std.stdio, std.string;
import std.string : string;

void Parse_Err(string str, bool expression = false) {
  if ( expression ) {
    std.stdio.writeln(str);
    import std.c.stdlib;
    exit(-1);
  }
}

bool Find_Sym(ref string str, ref int it, char c, bool skip = false) {
  while ( it < str.length && (skip ? str[it] == c :
                                     str[it] != c) ) ++ it;
  return it < str.length;
}

bool Is_Operator(char c) {
  return (c == '.' || c == '=' || c == '+' || c == '-' || c == '/' || c == ':');
}

void Translate_File(string filename) {
  string file;
  {
    static import std.file;
    import std.conv : to;
    file = to!string(std.file.read(filename));
    std.stdio.writeln(file);
    file ~= ' '; // whitespace for parsing
  }
  int it = 0;
  // Generate all contexts, then parses them for symbol table
  import AOQ.Parser.Symbol;
  auto c = new Context(file, it);
  std.stdio.writeln(c);
  std.stdio.writeln("----");
  c.Output();
  auto e = c.Parse();
  std.stdio.writeln(e);
  foreach ( el ; e )
    el.Output();
  symbol_table = e;
}

void Interpret_File() {
  import AOQ.Parser.Symbol;
  foreach ( sym; symbol_table ) {
    new Objl
  }
}

int main(string[] argv) {
  argv = argv[1..$]; // remove our name, not useful
  std.stdio.writeln(argv);
  if ( argv.length == 0 ) {
    std.stdio.writeln("Command line interpreter not implemented yet");
    return 5;
  }
  string filename = argv[0];
  string[] flags;
  if ( argv.length > 1 ) {
    flags = argv[1 .. $-1];
  }
  std.stdio.writeln("reading from " ~ filename);
  Translate_File(filename);
  Interpret_File();
  return 0;
}

