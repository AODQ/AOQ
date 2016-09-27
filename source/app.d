static import std.stdio, std.string;
import std.string : string;
import AOQ.Interpret;

void Print_Version_Information(bool verbose = false) {
  import std.stdio : writeln;
  writeln("AoQ 0.0.1, September 26, 2016");
  if ( verbose ) {
    writeln("");
  }
}

void Command_Line_Interpreter() {
  import std.stdio : writeln, write, readln;
  Print_Version_Information();
  while ( true ) {
    write("> ");
    auto str = readln();
    try {
      auto ret = Interpret_String(Translate_String(str));
      write(ret.Stringify(), ": ");
      ret.Print();
    } catch ( Exception e ) {
      writeln("Caught exception: ", e);
    }
  }
}

void File_Interpreter(string filename) {
  std.stdio.writeln("reading from " ~ filename);
  import core.time;
  MonoTime aoq_before = MonoTime.currTime;
  Interpret_String(Translate_File(filename));
  MonoTime aoq_after  = MonoTime.currTime;
  Duration aoq_time = aoq_after - aoq_before;
  import std.stdio : write, writeln;
  write("Exited successfully with: ");
  writeln("AOQ --- Time took to execute: ", aoq_time);
}

int main(string[] argv) {
  // --- initialize aoq
  import AOQ.Backend.Class;
  Construct_Default_Classes();
  // --- get parameters
  argv = argv[1..$]; // remove our name, not useful
  std.stdio.writeln("Parameters: ", argv);
  string filename;
  string[] flags;
  flags = argv;
  // --- check flags
  foreach ( f; flags ) {
    if ( f[0..2] != "--" ) {
      filename = f;
    }
    if ( f == "--help" ) {
    }
    if ( f == "--version" ) {
      Print_Version_Information();
    }
    if ( f == "--unittest" ) {
      Run_Unit_Tests();
    }
  }
  // --- run program
  if ( filename != "" ) {
    File_Interpreter(filename);
  } else {
    Command_Line_Interpreter();
  }
  return 0;
}
