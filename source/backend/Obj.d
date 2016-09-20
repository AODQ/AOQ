module AOQ.BE.Obj;
import std.string : string;

union CoreDataType {
  int integer;
  float floateger;
}

struct Obj {
public:
  int class_index;
  string name;
  CoreDataType[string] values;
  this() {
    class_index = 0;
  }
  this()
  void Receive_Msg(Obj intent) {
  }
  void Receive_Msg(Obj sender, Obj intent) {
  }
}
