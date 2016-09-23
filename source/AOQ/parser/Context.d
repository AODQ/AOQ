module AOQ.Parser.Context;
import AOQ.Parser.Symbol;
import AOQ.Parser.Util;
import AOQ.ParseTree;

ParseTree Generate_Parse_Tree(string str) {
  import std.stdio : writeln;
  ParseTree tree = new ParseTree;
  writeln("------------ tree BEFORE  ------------");
  writeln(cast(string)tree);
  writeln("--------------------------------------");
  tree.Set_Node_Info("Stringify");
  ulong start_pos = 0;
  bool is_on_word = false;
  foreach ( i ; 0 .. str.length ) {
    if ( str[i] == '(' ) {
      tree.Down();
      continue;
    } if ( str[i] == ')' ) {
      tree.Up();
      continue;
    }
    if ( is_on_word ) {
      if ( str[i] != ' ' )
        start_pos = i;
    } else if ( str[i] == ' ' ) {
      tree.Set_Node_Info(str[start_pos .. i-1]);
      is_on_word = false;
    }
    writeln("------------ tree diagram ------------");
    writeln(cast(string)tree);
    writeln("--------------------------------------");
  }
  return tree;
}
