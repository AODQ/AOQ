module AOQ.Parser.Symbol;
import AOQ.Parser.Context;
import AOQ.Types;

Symbol[] symbol_table;

class Symbol {
public:
  string receiver_str, sender_str, msg_str;
  SymbolType receiver_typ, sender_typ, msg_typ;
  this(string s) {
    s = ' ' ~ s ~ ' ';
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
    std.stdio.writeln("PARSED SYMBOLS: ", symbols);
    receiver_typ = sender_typ = msg_typ = Symbol_Type.unknown;
    foreach ( sym ; symbols ) {
      bool vinteger, vfloateger, vvariable, vsymbol;
      vinteger = vfloateger = vvariable = vsymbol = true;
      vfloateger = false;
      char s0 = sym[0];
      vsymbol = sym.length == 1 && Is_Operator(s0);
      import std.uni : toLower;
      vvariable = toLower(s0) >= 'a' && toLower(s0) <= 'z';
      foreach ( i; sym ) {
        if ( i < '0' || i > '9' ) vinteger = false;
        if ( !vsymbol && i == '.' && vinteger ) {
          Parse_Err("Float has multiple .s", vfloateger);
          vfloateger = true;
        }
        if ( vvariable && !((toLower(i) >= 'a' && toLower(i) <= 'z')
                        ||  (        i  >= '1' &&         i  <= '9')))
          vvariable = false;
      }

      Symol_Type sym_typ = Symbol_Type.unknown;
      if ( vinteger   ) sym_typ = Symbol_Type.integer;
      if ( vfloateger ) sym_typ = Symbol_Type.floateger;
      if ( vvariable  ) sym_typ = Symbol_Type.object;
      if ( vsymbol    ) sym_typ = Symbol_Type.object;
      Parse_Err("Unable to interpret symbol", vsymbol == Symbol_Type.unknown);
      switch ( sym_it ) {
        case 0:
          msg_str = sym; msg_typ = sym_typ;
        break;
        case 1:
          receiver_str = sym; receiver_typ = sym_typ;
        break;
        case 2:
          sender_str = sym; sender_typ = sym_typ;
        break;
        default:
          Parse_Err("Parser error, didn't break down context properly");
        break;
      }
      ++ sym_it;
    }
  }

  void Output() {
    import std.stdio : writeln;
    writeln("( "      , "{", receiver_str   , "{", receiver_typ, "} ",
                                  msg_str   , "{", msg_typ,      "} ",
                                  sender_str, "{", sender_typ,   "})");
  }
} 
