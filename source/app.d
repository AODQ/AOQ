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
  import core.time;
  MonoTime aoq_before = MonoTime.currTime;
  std.stdio.writeln("Exited successfully with: ",
                     main_tree.Evaluate().Stringify());
  MonoTime aoq_after  = MonoTime.currTime;
  Duration aoq_time = aoq_after - aoq_before;
  std.stdio.writeln("AOQ --- Time took to execute: ", aoq_time);
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
