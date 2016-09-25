static import std.stdio, std.string;
import std.string : string;
import AOQ.ParseTree;

ParseTree main_tree;

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
  main_tree = Generate_Parse_Tree(file);

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
  import AOQ.Backend.Class, AOQ.Backend.Obj;

  // std.stdio.writeln(main_tree.Evaluate().Stringify());

  //   auto result = r.Receive_Msg(s, m);
  //   std.stdio.writeln("RETURN VALUE: ", result);
  //   std.stdio.writeln("(STRING FORM): ",
  //     result.Receive_Msg(Obj("Stringify")).R_String_Value(0));
  // }
}

int main(string[] argv) {
  argv = argv[1..$]; // remove our name, not useful
  argv ~= "test_programs/math_test.aoq";
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
  import AOQ.Backend.Class;
  Construct_Default_Classes();
  Translate_File(filename);
  Interpret_File();
  // ---  DEBUG ---
  import std.stdio : writeln;
  writeln("----------------------------------------------");
  writeln("----------------   finished   ----------------");
  writeln("----------------------------------------------");
  // --- EDEBUG ---
  return 0;
}
