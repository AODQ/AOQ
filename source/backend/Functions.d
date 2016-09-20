module AOQ.BE.Functions;
import AOQ.Types;

Obj Interpret_Function(ref Obj receiver, ref Obj message) {
  receiver.message_table_2[message](receiver);
}

Obj Interpet_Function(ref Obj receiver, ref Obj message, ref Obj sender) {
  receiver.message_table_3[message](receiver, sender);
}

// --- default object functions ---
import AOQ.BE.Exception;
void Def_Add(ref Obj receiver) {
  Throw_Exception("No definition for + on self");
}

void Def_Add

void Def_Add(ref Obj r, Obj s) {
  Throw_Exception("Length mismatch on add", r.values.length != s.values.length);
  foreach ( i; 0 .. r.values.length )
    r[i] += s.values[i];
}
