module AOQ.ParseTree;
import AOQ.Types;
import AOQ.BE.Obj;

class ParseNode {
  ParseNode node_receiver, node_sender, node_parent;
  Obj data;

  this() {
    import AOQ.BE.Class;
    data = Obj.Construct_Default();
  }

  void Set(SymbolType t, string cdt) {
    import std.conv : to;
    switch ( t ) {
      default: assert(0);
      case SymbolType.integer:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.floateger:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.stringeger:
        data = Obj(to!int(cdt));
      break;
      case SymbolType.object:
        data = Obj(to!int(cdt));
      break;
    }
  }
}

class ParseTree {
  ParseNode Root, current;
  int deepest_layer; // useful for printing
  this() {
    Root = new ParseNode();
    deepest_layer = 2;
    Root.data = Obj("Stringify");
  }

  ParseNode R_Root() { return Root; }

  string opCast(T)() if (is(T == string)) {
    int layer = 0, c_layer_it = 0;
    bool left_side = false;
    string str = "";
    // search using breadth-first, print location
    void Print_Node ( ParseNode node ) {
      import std.stdio : writeln;
      bool nullify_node = false;
      if ( node is null ) {
        // writeln(node);
        node = new ParseNode;
        // writeln(node);
        nullify_node = true;
        node.data = Obj("NULL");
        // writeln(node.data);
      }
      int width = 3 + (deepest_layer*deepest_layer - layer)*2;
      foreach ( i; 0 .. width ) {
        str ~= " ";
      }
      // writeln("Sending message to node data");
      str ~= node.data.Receive_Msg(Obj("Stringify")).values[0].stringeger;
      // writeln("String parsed: ", str);
      if ( c_layer_it ++ == layer ) {
        c_layer_it = 0;
        layer += 2;
        str ~= "\n";
      }
      if ( nullify_node ) {
        // writeln("Deleting node");
        delete node;
        node = null;
      }
    }

    ParseNode[] q  = [ Root ];
    while ( q.length != 0 ) {
      auto t_node = q[$-1];
      q = q[0..$-1];
      Print_Node(t_node);
      // check left-hand
      if ( t_node.node_receiver !is null )
        q ~= t_node.node_receiver;
      else
        Print_Node(null);
      // check right-hand
      if ( t_node.node_sender   !is null )
        q ~= t_node.node_sender;
      else
        Print_Node(null);
    }
    return str;
  }

  void Down() in {
    assert(current !is null);
  } body {
    ++ deepest_layer;
    auto n = new ParseNode();
    n.node_parent = current;
    if      ( current.node_receiver is null )
      current = current.node_receiver = n;
    else if ( current.node_sender  is null )
      current = current.node_sender = n;
    else {
      throw new Exception("Failed to deepen, nowhere to go");
    }
  }

  void Up() in {
    assert(current !is null && current.node_parent !is null);
  } body {
    -- deepest_layer;
    current = current.node_parent;
  }

  void Set_Node_Info(string sym) {
    // --- parse symbol to check type
    bool vinteger, vfloateger, vvariable, vsymbol;
    vinteger = vfloateger = vvariable = vsymbol = true;
    import AOQ.Parser.Util;
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
    // if ( vinteger ) {
    //   type = SymbolType.integer;
    //   data.integer = to!int(sym);
    // } else if ( vfloateger ) {
    //   type = SymbolType.floateger;
    //   data.floateger = to!float(sym);
    // } else if ( vvariable || vsymbol ) {
    //   type = SymbolType.object;
    //   data.stringeger = sym;
    // } else {
    //   Parse_Err("Unable to interpret symbol: " ~ sym);
    // }
    current.data = Obj(sym);
  }
}
