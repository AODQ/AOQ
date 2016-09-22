module AOQ.Global.ParseTree;
import AOQ.Global.Types;

class ParseNode {
  ParseNode node_message, node_receiver, node_sender, node_parent;
/// NOTE: For an object, since it can't possibly be known
/// at parse-time what it can be, the CDT will be a string
  SymbolType type;
  CoreDataType data;
}

class ParseTree {
  ParseNode head;
  ParseNode current;
public:
  this(ParseNode _head) {
    current = head = _head;
  }
  void Down(ParseNode n) in {
    assert(current !is null)
  } body {
    if ( current.node_message == null )
      current = current.node_message = n;
    else if ( current.node_receiver == null )
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
