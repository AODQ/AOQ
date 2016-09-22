module AOQ.Parser.Context;
import AOQ.Parser.Symbol;
import AOQ.Parser.Util;

ParseTree Generate_Parse_Tree() {
}

class Context {
public:
  Context[] nodes;
  string context;
  int lower_contexts;
  this(string _context) {
    context = _context;
  }
  this(ref string str, ref int it) {
    // find starting position
    if ( Find_Sym(str, it, '(') == false ) {
      // end of file
      return;
    }
    // --- iterate through until found ending position
    import AOQ.Global.ParseTree;
  }
  // Returns the parsed symbol
  Symbol[] Parse() {
    // at lowest point
    if ( lower_contexts == 0 )
      return [new Symbol(context)];
    // at a higher point, call contexts
    Symbol[] sym_table;
    foreach ( n; nodes )
      sym_table ~= n.Parse();
    return sym_table;
  }

  void Output() {
    import std.stdio : writeln;
    writeln("Context: (", context, ")");
    writeln("lower context: ", lower_contexts);
    writeln("nodes", nodes);
  }
}
