module AOQ.Backend.Functions;
import AOQ.Types;
import AOQ.Backend.Exception;
import AOQ.Backend.Class;
import AOQ.Backend.Obj;

/// functions not written in AoQ.. yet
struct NonAOQFunc {
static:
  void Create_Class(Obj* class_label) {
    Class nclass = classes[DefaultType.object];
    nclass.class_name = class_label.Stringify();
    symbol_classes ~= nclass;
  }
  void Evaluate_Object(Obj* r) {
    auto array = r.values[0].array;
    Obj* message  = array.length > 0 ? array[0] : null,
        * receiver = array.length > 1 ? array[1] : null,
        * sender   = array.length > 2 ? array[2] : null;
    if ( message is null ) // empty statement
      return Obj();
    Obj* eval_message = message.Receive_Msg("__Evaluate");
    if ( receiver is null ) // single statement (R)
      return eval_message;
    Obj* eval_receiver = message.Receive_Msg("__Evaluate");
    if ( sender is null ) // no sender (R < M)
      return eval_receiver.Receive_Msg(eval_message);
    Obj* eval_sender = sender.Receive_Msg("__Evaluate");
    return eval_receiver.Receive_Msg(eval_sender, eval_message);
  }
}
