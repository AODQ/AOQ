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
private:
  ParseNode root, current;
  int R_Height(ParseNode pn) {
    if ( pn is null ) return -1;
    int r_height = R_Height(pn.node_receiver),
        s_height = R_Height(pn.node_sender);
    return r_height > s_height ? s_height+1 : r_height+1;
  }
public:
  int R_Height() {
    return R_Height(root) + 1;
  }
  this() {
    root = new ParseNode();
    root.data = Obj("Stringify");
    current = root;
  }

  ParseNode R_Root() { return root; }

  ParseNode R_Current() { return current; }

  string R_Current_ParseNode_String() {
    return current.data.Receive_Msg(Obj("Stringify")).values[0].stringeger;
  }

  /// Returns pretty-print version of tree
  /// Format:
  /** (* (+ (/ 3 (C X Y) 3) some_var) becomes
    Stringify
      |
      |-- *
          |
          |-- +
          |   |
          |   |--/
          |   |  |
          |   |  |-- 3
          |   |  |
          |   |  |-- C
          |   |      |
          |   |      |-- X
          |   |      |
          |   |      --- Y
          |   |
          |   --- 3
          |
          |--- some_var
  **/
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
      int deepest_layer = R_Height();
      writeln("DEEPEST LAYER: ", deepest_layer);
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

    ParseNode[] q  = [ root ];
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
    auto n = new ParseNode();
    n.node_parent = current;
    if      ( current.node_receiver is null )
      current = current.node_receiver = n;
    else
      current = current.node_sender = n;
    // else {
    //   throw new Exception("Failed to deepen, nowhere to go");
    // }
  }

  void Up() in {
    assert(current !is null && current.node_parent !is null);
  } body {
    current = current.node_parent;
  }

  void Next() {
    Up();
    Down();
  }

  void Set_Node_Info(string sym) in {
    assert(sym.length != 0);
  } body {
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
