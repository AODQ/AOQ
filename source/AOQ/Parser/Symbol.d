module AOQ.Parser.Symbol;
import AOQ.Parser.Types;
import AOQ.Types;
import AOQ.Util;

Symbol[] symbol_table;

class Symbol {
public:
  string receiver_str, sender_str, msg_str;
  DefaultType receiver_typ, sender_typ, msg_typ;
  this(string s) {
    s = ' ' ~ s ~ ' ';
    { // ---  DEBUG ---
      import std.stdio;
      writeln("PARSING SYMBOL: (", s, ")");
    } // --- EDEBUG ---
    string[] symbols;
    for ( int it = 0;; ) {
      if ( !Find_Sym(s, it, ' ') ) break;
      int start = it++ + 1;
      if ( !Find_Sym(s, it, ' ') ) break;
      symbols ~= s[start .. it];
    }

    Parse_Err("Parser error, found multiple symbols in a context (shouldn't"
              " happen!)", symbols.length > 3);
    Parse_Err("Found symbol with no message", symbols.length < 1);

    // parse symbol
    int sym_it = 0;
    import std.stdio : writeln;
    writeln("PARSED SYMBOLS: ", symbols);
    foreach ( sym ; symbols ) {
    }
  }

  void Output() {
    import std.stdio : writeln;
    writeln("( "      , "{", receiver_str   , "{", receiver_typ, "} ",
                                  msg_str   , "{", msg_typ,      "} ",
                                  sender_str, "{", sender_typ,   "})");
  }
} 
