module AOQ.ParseTree;
import AOQ.Types;
import AOQ.Backend.Obj;

ParseTree Generate_Parse_Tree(string str) {
  import std.stdio : writeln;
  ParseTree tree = new ParseTree;
  // writeln("------------ tree BEFORE  ------------");
  // writeln(cast(string)tree);
  // writeln("--------------------------------------");
  ulong start_pos = 0;
  bool is_on_word = false;
  foreach ( i ; 0 .. str.length ) {
    // writeln("C: ", str[i]);
    if ( str[i] == '(' ) {
      writeln("Tree down");
      tree.Down();
      continue;
    } if ( str[i] == ')' ) {
      // writeln("Tree up");
      tree.Up();
      continue;
    }
    if ( !is_on_word ) {
      if ( str[i] != ' ' ) {
        start_pos = i;
        // writeln("is on word");
        is_on_word = true;
      }
    } else if ( str[i] == ' ' ) {
      if ( tree.R_Current_ParseNode_String() != "null" ) {
        tree.Down();
        tree.Set_Node_Info(str[start_pos .. i]);
        // writeln("Setting Node: ", tree.R_Current_ParseNode_String);
        tree.Up();
      } else {
        tree.Set_Node_Info(str[start_pos .. i]);
        // writeln("Setting Node: ", tree.R_Current_ParseNode_String);
      }
      // writeln("------------ tree diagram ------------");
      // writeln(cast(string)tree);
      // writeln("--------------------------------------");
      is_on_word = false;
    }
  }
  writeln("------------ tree diagram ------------");
  writeln(cast(string)tree);
  writeln("--------------------------------------");
  return tree;
}

class ParseNode {
  ParseNode node_receiver, node_sender, node_parent;
  Obj data;

  this() {
    import AOQ.Backend.Class;
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

  // Adapted from Vasya Novikov's submission
  // http://stackoverflow.com/questions/4965335/how-to-print-binary-tree-diagram
  string Print() {
    string t;
    Print("", true, t);
    return t;
  }

  private void Print ( string prefix, bool tail, ref string o ) {
    import std.stdio : writeln;
    o ~= prefix ~ (tail ? "└── " : "├── ") ~ data.Stringify() ~ '\n';
    auto n_prefix = prefix ~ (tail ? "   " : "|   ");
    ParseNode[] n_list;
    if ( node_receiver !is null ) n_list ~= node_receiver;
    if ( node_sender   !is null ) n_list ~= node_sender;
    if ( n_list.length != 0 ) {
      foreach ( i; 0 .. n_list.length-1 )
        n_list[i].Print(n_prefix, false, o);
      n_list[$-1].Print(n_prefix, true, o);
    }
  }

  Obj Evaluate() {
    if ( node_receiver is null ) // leaf
      return data;
    auto receiver = node_receiver.Evaluate();
    if ( node_sender   is null ) // R < M
      return receiver.Receive_Msg(data);
    // R < M < D
    auto sender = node_sender.Evaluate();
    return receiver.Receive_Msg(sender, data);
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
  /** (* (+ 4 3) some_var) becomes
    Stringify
      |
      |-- *
          |-- +
          |   |-- 4
          |   '-- 3
          '--- some_var
  **/
  string opCast(T)() if (is(T == string)) {
    return root.Print();
  }


  void Down() in {
    assert(current !is null);
  } body {
    auto n = new ParseNode();
    n.node_parent = current;
    if        ( current.node_receiver is null ) {
      current = current.node_receiver = n;
    } else if ( current.node_sender   is null ) {
      current = current.node_sender = n;
    } else {
      throw new Exception("Failed to deepen, nowhere to go");
    }
  }

  void Up() in {
    assert(current !is null && current.node_parent !is null);
  } body {
    current = current.node_parent;
  }

  Obj Evaluate() {
    return root.Evaluate();
  }

  void Set_Node_Info(string sym) in {
    assert(sym.length != 0);
  } body {
  { // ---  DEBUG ---
    import std.stdio;
    writeln("Setting node info for: ", sym);
  } // --- EDEBUG ---
    // --- parse symbol to check type
    bool vinteger, vfloateger, vvariable, vsymbol;
    vinteger = vfloateger = vvariable = vsymbol = true;
    import AOQ.Parser.Util;
    vfloateger = false;
    char s0 = sym[0];
    vsymbol = sym.length == 1 && Is_Operator(s0);
    { // ---  DEBUG ---
      import std.stdio;
      writeln("IS OPERATOR: ", Is_Operator(s0), " FOR: ", s0);
    } // --- EDEBUG ---
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
      { // ---  DEBUG ---
        import std.stdio;
        writeln("INTEGER!");
      } // --- EDEBUG ---
      current.data = Obj(to!int(sym));
    } else if ( vfloateger ) {
      current.data = Obj(to!float(sym));
      { // ---  DEBUG ---
        import std.stdio;
        writeln("FLOATEGER!");
      } // --- EDEBUG ---
    } else if ( vvariable || vsymbol ) {
      { // ---  DEBUG ---
        import std.stdio;
        writeln("VAR OR SYM!");
      } // --- EDEBUG ---
      current.data = Obj(sym);
      // ---- interpret into global objects ----
      import AOQ.Backend.Class;
      auto sym_ind = (sym in DefaultMessageClass_map);
      if ( sym_ind ) {
        current.data = Obj(&symbol_classes[*sym_ind]);
        { // ---  DEBUG ---
          import std.stdio;
          writeln("Interpreted symbol: ", current.data.Stringify);
        } // --- EDEBUG ---
      } else {
      { // ---  DEBUG ---
        import std.stdio;
        writeln("Symbol not interpreted, must be variable: ", sym);
      } // --- EDEBUG ---
      }
    } else {
      Parse_Err("Unable to interpret symbol: " ~ sym);
    }
  }
}
