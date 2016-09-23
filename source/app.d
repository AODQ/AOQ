static import std.stdio, std.string;
import std.string : string;

void Translate_File(string filename) {
  std.stdio.writeln("----------------------------------------------");
  std.stdio.writeln("---------------- parsing file ----------------");
  std.stdio.writeln("----------------------------------------------");
  string file;
  {
    static import std.file;
    import std.conv : to;
    file = to!string(std.file.read(filename));
    // std.stdio.writeln(file);
    // file ~= ' '; // whitespace for parsing
  }
  int it = 0;
  // Generate all contexts, then parses them for symbol table
  import AOQ.Parser.Symbol,
         AOQ.Parser.Context;
  import std.stdio : writeln;
  writeln("Generating parse tree");
  Generate_Parse_Tree(file);

  // auto c = new Context(file, it);
  // std.stdio.writeln("---- parsed contexts ----");
  // c.Output();
  // std.stdio.writeln("---- created contexts, now parse symbols ----");
  // auto e = c.Parse();
  // std.stdio.writeln("---- parsed symbols ----");
  // std.stdio.writeln(e);
  // foreach ( el ; e )
  //   el.Output();
  // symbol_table = e;
}

void Interpret_File() {
  std.stdio.writeln("----------------------------------------------");
  std.stdio.writeln("---------------- interpreting ----------------");
  std.stdio.writeln("----------------------------------------------");
  import AOQ.Parser.Symbol,
         AOQ.Parser.Types,
         AOQ.Parser.Util,
         AOQ.Types;
  import AOQ.BE.Class, AOQ.BE.Obj;
  Obj Symbol_To_Object(SymbolType typ, string str) {
    // ---  DEBUG ---
    import std.stdio : writeln;
    writeln("SYMBOL: ", typ, " : VALUE: ", str);
    // --- EDEBUG ---
    import std.conv : to;
    switch ( typ ) {
      default: assert(0);
      case SymbolType.object:
        switch ( str ) {
          case "+":
            auto e = Obj(&classes[DefaultClass.symbol]);
            return e;
          default: assert(0);
        }
      // break;
      case SymbolType.integer:
        auto e = Obj(DefaultClass.integer);
        e.values[0].integer = to!int(str);
        return e;
      case SymbolType.floateger:
      break;
      case SymbolType.stringeger:
      break;
      case SymbolType.boolean:
      break;
    }
    Parse_Err("Don't know what a " ~ str ~ " is to be interpreted as");
    assert(0);
  }
  // TODO: this shouldn't be a foreach but a data tree of the functions
  foreach ( sym; symbol_table ) {
    auto r = Symbol_To_Object( sym.receiver_typ, sym.receiver_str ),
         s = Symbol_To_Object( sym.sender_typ,   sym.sender_str   ),
         m = Symbol_To_Object( sym.msg_typ,      sym.msg_str      );
    // ---  DEBUG ---
    import std.stdio : writeln;
    writeln("R: ", *r.base_class, '\n',
            "S: ", *s.base_class, '\n',
            "M: ", *m.base_class, '\n');
    // --- EDEBUG ---
    auto result = r.Receive_Msg(s, m);
    std.stdio.writeln("RETURN VALUE: ", result);
    std.stdio.writeln("(STRING FORM): ",
      result.Receive_Msg(Obj("Stringify")).R_String_Value(0));
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
  import AOQ.BE.Class;
  Construct_Default_Classes();
  Translate_File(filename);
  // Interpret_File();
  // ---  DEBUG ---
  import std.stdio : writeln;
  writeln("----------------------------------------------");
  writeln("----------------   finished   ----------------");
  writeln("----------------------------------------------");
  // --- EDEBUG ---
  return 0;
}
