module AOQ.Parser.Context;
import AOQ.Parser.Symbol;

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
    int[] lc_start;
    int breakers;
    do { // iterate through file
      if ( str[it] == '(' ) {
        std.stdio.writeln("Found a (");
        lc_start ~= it; // take note of pos
        ++ lower_contexts;
      }
      if ( str[it] == ')' ) {
        std.stdio.writeln("Found a )");
        if ( -- lower_contexts == 0 ) {
          Parse_Err("Empty parens not allowed", lc_start[0]+1 >= it);
          if ( lc_start[0]+1 < it ) {
          }
          context = str[lc_start[0]+1 .. it];
          break;
        }
        // create new context
        std.stdio.writeln("Creating new context");
        int t_it = 0;
        string t_str = str[lc_start[lower_contexts+1] .. it];
        nodes ~= new Context(t_str, t_it);
      }
      if ( str[it] == '.' || str[it] == ';' ) {
        std.stdio.writeln("Found a .");
        nodes ~= new Context(".");
        if ( str[it] == ';' ) {
          // TODO: ignore rest of line if ;
        }
      }
    } while ( ++ it < str.length );
    // --- found ending position, and generated all contexts
    if ( it >= str.length )
      Parse_Err("Unmatched paren");
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
    std.stdio.writeln(context);
    std.stdio.writeln("lower context: ", lower_contexts);
    std.stdio.writeln("nodes", nodes);
  }
}
