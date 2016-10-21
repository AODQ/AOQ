module AOQ.Backend.Exception;

void Throw_Exception(string s, bool check = false) {
  if ( !check ) {
    import std.stdio;
    // TODO: Go through the current tree stack and list the current context.
    // Throwing both D and that will be very helpful, but at some point remove
    // throwing D exceptions unless a flag is used
    throw new Exception("Exception occurred: (" ~ s ~ ")");
  }
}

import AOQ.Backend.Obj;
void Throw_Exception(Obj* receiver, Obj* sender, string msg) {
  Throw_Exception(receiver.Stringify() ~ ' ' ~ msg ~ ' ' ~ sender.Stringify() ~
                    " has undefined communication");
}

void Throw_Exception(Obj* receiver, Obj* sender, Obj msg) {
  Throw_Exception(receiver, sender, msg.Stringify());
}
