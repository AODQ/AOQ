module AOQ.BE.Functions;
import AOQ.Types;
import AOQ.BE.Exception;
import AOQ.BE.Class;
import AOQ.BE.Obj;

/// functions not compatible with AoQ.. yet
struct NonAOQFunc {
static:
  bool Fn_Compatible_Values(Obj r, Obj s, ulong r_i, ulong s_i, string msg,
                             bool throw_exception = true) {
    if ( r.base_class.value_names[r_i] != s.base_class.value_names[s_i] ) {
      // TODO: allow object to check if it implements the thing for the message
      Throw_Exception(msg ~ " does not allow value", throw_exception);
      return false;
    }
    return true;
  }
  bool Fn_Value_Length_Match(Obj r, Obj s, bool throw_exception = true,
                              string exception_msg = "") {
    if ( r.values.length != s.values.length ) {
      Throw_Exception("Length mismatch on: " ~ exception_msg, throw_exception);
      return false;
    }
    return true;
  }
  /// Assumes the operation is complaint (r <- fn+s is valid)
  void Do_Operation(ref CoreDataType r, ref CoreDataType s,
                    SymbolType  r_type, SymbolType  s_type, Obj fn) {
  }
}

// --- default functions ---
@disable Obj Fn_Check_Message_Exists_One_Param(Obj r, string fn) {
  return Obj();
}
@disable Obj Fn_Check_Message_Exists_Two_Param(Obj r, Obj s, string fn) {
  return Obj();
}


// --- default object functions ---
