static import std.stdio, std.string;
import std.string : string;
import AOQ.ParseTree;

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
  import AOQ.Interpret;
  import core.time;
  Run_Unit_Tests();
  MonoTime aoq_before = MonoTime.currTime;
  Interpret_File(Translate_File(filename));
  MonoTime aoq_after  = MonoTime.currTime;
  Duration aoq_time = aoq_after - aoq_before;
  import std.stdio : write, writeln;
  write("Exited successfully with: ");
  writeln("AOQ --- Time took to execute: ", aoq_time);
  // ---  DEBUG ---
  import std.stdio : writeln;
  writeln("----------------------------------------------");
  writeln("----------------   finished   ----------------");
  writeln("----------------------------------------------");
  // --- EDEBUG ---
  return 0;
}
