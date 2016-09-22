module AOQ.Parser.Context;
import AOQ.Parser.Symbol;
import AOQ.Parser.Util;

ParseTree Generate_Parse_Tree() {
  ParseTree tree;
  tree.Set_Node_Info("Stringify");
  int start_pos = -1;
  for ( i ; 0 .. str.length ) {
    if ( str[i] == '(' ) {
      tree.Down();
      continue;
    } if ( str[i] == ')' ) {
      tree.Up();
      continue;
    }
    if ( start_pos == -1 ) {
      if ( str[i] != ' ' )
        start_pos = i;
    } else if ( str[i] == ' ' ) {
        Sent_Node_Info(str[start_pos .. i-1]);
        start_pos = -1;
      }
    }
  }
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
