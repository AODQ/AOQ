module AOQ.Backend.Enviornment;
import AOQ.Backend.Obj;

private immutable(Obj*)[][] Scope;

void Push_Scope(immutable(Obj*)[] _Scope) {
  Scope ~= _Scope.dup();
}
void Push_Object(immutable(Obj*) object) {
  Scope[$-1] ~= object;
}

void Pop_Scope() {
  if ( Scope.length != 0 ) {
    foreach ( o; Scope[$-1] )
      delete o;
    -- enviornment_scope.length;
  }
}
