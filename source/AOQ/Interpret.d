module AOQ.Interpret;
import AOQ.ParseTree;
import AOQ.Backend.Obj;
import AOQ.Util;

Obj Interpret_File(ParseTree tree) {
  import std.stdio : writeln, write;
  Print("----------------------------------------------");
  Print("---------------- interpreting ----------------");
  Print("----------------------------------------------");
  import AOQ.Parser.Symbol,
         AOQ.Parser.Types,
         AOQ.Types;
  import AOQ.Backend.Class, AOQ.Backend.Obj;
  auto result = tree.Evaluate();
  return result;
}

ParseTree Translate_String(string str) {
  import std.stdio : writeln, write;
  Print("Generating parse tree for: ");
  Print(str);
  return Generate_Parse_Tree(str);
}

ParseTree Translate_File(string filename) {
  import std.stdio : writeln, write;
  Print("----------------------------------------------");
  Print("---------------- parsing file ----------------");
  Print("----------------------------------------------");
  string file;
  {
    static import std.file;
    import std.conv : to;
    file = to!string(std.file.read(filename));
  }
  return Translate_String(file);
}

private struct Unit_Test {
  string name, program, expected_result;
  bool break_on_fail;
  this(string _name, string _program, string _expected, bool _break = true) {
    name = _name;
    program = _program;
    expected_result = _expected;
    break_on_fail = _break;
  }

  void Run() {
    auto rval = Interpret_File(Translate_String(program));
    import std.stdio : write, writeln;
    write(name, ": ");
    if ( rval.Stringify() != expected_result ) {
      writeln("FAIL! Value: ", rval.Stringify,
              " Expected: ", expected_result);
      if ( break_on_fail ) {
        import std.c.stdlib;
        exit(-1);
      }
    } else
      writeln("SUCCESS!");
  }
}


void Run_Unit_Tests() {
  import std.stdio : writeln;
  writeln(" ---- unit tests ---- ");
  Unit_Test[] Tests = [
    Unit_Test("success:", "( 0 )", "0"),
    Unit_Test("failure:", "( 0 )", "1", false),
    Unit_Test("Addition", "(+ 1 2 )", "3"),
    Unit_Test("If      ", "( If 0 0 )", "nil"),
    Unit_Test("If-Else ", "( ^ ( If 1 2 ) 1 )", "2"),
    Unit_Test("If-Elif ", "( ^ ( If 0 1 ) ( If 1 8 ) )", "8"),
    Unit_Test("Layers  ", "( ( ^ ( If 1 + ) * ) ( + 2 3 ) ( + 3 2 ) )", "10"),
    Unit_Test("Layers 2", "( ( ^ ( If 0 + ) * ) ( + 2 3 ) ( + 3 2 ) )", "25"),
    Unit_Test("Loop Sum", "( Loop_Sum ( Range 0 10 ) . )", "45"),
    Unit_Test("Arrays  ", "( ~ 1 2 )", "12"),
    Unit_Test("ArrayLbl", "( ~ Loop Range )", "LoopRange"),
    Unit_Test("Arrays 3", "( ~ ( ~ 1 ( ~ 2 3 ) ) ( ~ ( ~ 4 5 ) 6 )", "123456"),
  ];
  Set_Print_Level(PrintLevel.none);
  foreach ( u; Tests )
    u.Run();
  Set_Print_Level(PrintLevel.verbose);
  writeln(" -------------------- ");
}
