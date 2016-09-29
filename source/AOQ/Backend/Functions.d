module AOQ.Backend.Functions;
import AOQ.Types;
import AOQ.Backend.Exception;
import AOQ.Backend.Class;
import AOQ.Backend.Obj;

/// functions not compatible with AoQ.. yet
struct NonAOQFunc {
static:
  void Create_Class(Obj class_label) {
    Class nclass = classes[DefaultType.object];
    nclass.class_name = class_label.Stringify();
    symbol_classes ~= nclass;
  }
}
