module AOQ.BE.Exception;

void Throw_Exception(string s, bool check = false) {
  if ( !check ) {
    import std.stdio;
    throw new Exception("Exception occurred: (" ~ s ~ ")");
  }
}
