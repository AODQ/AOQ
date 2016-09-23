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
  ulong start_pos = 0;
  bool is_on_word = false;
  foreach ( i ; 0 .. str.length ) {
    writeln("C: ", str[i]);
    if ( str[i] == '(' ) {
      writeln("Tree down");
      tree.Down();
      continue;
    } if ( str[i] == ')' ) {
      writeln("Tree down");
      tree.Up();
      continue;
    }
    if ( !is_on_word ) {
      if ( str[i] != ' ' ) {
        start_pos = i;
        writeln("is on word");
        is_on_word = true;
      }
    } else if ( str[i] == ' ' ) {
      writeln("Setting node info, previous: ", tree.R_Current_ParseNode_String);
      tree.Set_Node_Info(str[start_pos .. i]);
      writeln("Now: ", tree.R_Current_ParseNode_String);
        tree.Next();
      is_on_word = false;
    }
  writeln("------------ tree diagram ------------");
  writeln(cast(string)tree);
  writeln("--------------------------------------");
  }
  writeln("------------ tree diagram ------------");
  writeln(cast(string)tree);
  writeln("--------------------------------------");
  return tree;
}
