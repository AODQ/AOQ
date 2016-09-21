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
  import AOQ.BE.Class, AOQ.BE.Obj;
  Obj Symbol_To_Object(typ, str) {
    import std.conv : to;
    switch ( typ ) {
      default: assert(0);
      case SymbolType.object:
        switch ( str ) {
          default: assert(0);
          case "+":
            return Obj(DefaultClass.sym_add);
          break;
        }
      break;
      case SymbolType.integer:
        auto e = Obj(DefaultClass.integer);
        e.values[0] = to!int(str);
        return e;
      break;
      case SymbolType.floateger:
      break;
      case SymbolType.stringeger:
      break;
      case SymbolType.boolean:
      break;
    }
    Throw_Exception("Don't know what a " ~ str ~ " is to be interpreted as");
  }
  // TODO: this shouldn't be a foreach but a data tree of the functions
  foreach ( sym; symbol_table ) {
    auto r = Symbol_To_Object( sym.receiver_typ, sym.receiver_str ),
         s = Symbol_To_Object( sym.sender_typ,   sym.sender_str   ),
         m = Symbol_To_Object( sym.msg_typ,      sym.msg_str      );
    std.stdio.writeln(r.Receive_Msg(s, m));
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
