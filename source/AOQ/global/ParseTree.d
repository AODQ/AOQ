module AOQ.Global.ParseTree;
import AOQ.Global.Types;

class ParseNode {
  ParseNode node_receiver, node_sender;
  Obj data;

  this() {
    data = Obj(null);
  }

  void Set(SymbolType t, string cdt) {
    import std.conv : to;
    switch ( t ) {
      case SymbolType.integer:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.floateger:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.stringeger:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.objeger:
        data = Obj(to!int(cdt));
      break;
    }
  }
}

class ParseTree {
  ParseNode head, current;
  this() {
    current = head = new ParseNode();
  }

  ParseNode R_Head() { return head; }


  void Down() in {
    assert(current !is null)
  } body {
    auto n = new ParseNode();
    if      ( current.node_receiver == null )
      current = current.node_receiver = n;
    else if ( current.node_sender  == null )
      current = current.node_sender = n;
    else {
      throw new Exception("Failed to deepen, nowhere to go");
    }
  }

  void Up() in {
    assert(current !is null && current.node_parent !is null);
  } body {
    current = current.node_parent;
  }

  void Set_Node_Info(string sym) {
    // --- parse symbol to check type
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

    // --- symbol parsed, now set the type and convert the symbol
    //     to the correct data
    import std.conv : to;
    if ( vinteger ) {
      type = SymbolType.integer;
      data.integer = to!int(sym);
    } else if ( vfloateger ) {
      type = SymbolType.floateger;
      data.floateger = to!float(sym);
    } else if ( vvariable || vsymbol ) {
      type = SymbolType.object;
      data.stringeger = sym;
    } else {
      Parse_Err("Unable to interpret symbol: " ~ sym);
    }
  }
}
