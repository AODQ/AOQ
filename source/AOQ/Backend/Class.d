module AOQ.Backend.Class;
import AOQ.Backend.Obj;
import std.string : string;
import AOQ.Backend.Exception;
import AOQ.Backend.Functions;
import AOQ.Types;

// class ClassString {
//   string string_name;
//   this(string _string_name) {
//     string_name = _string_name;
//   }
// }

Class[] classes = [];
Class[] symbol_classes = [];

struct Class {
public:
  string class_name;
  int[string]  value_indices;
  string[]     value_names;
  SymbolType[] value_types;
  Type_msg_2[string] message_table_2;
  Type_msg_3[string] message_table_3;

  /// Construct class
  this(string _class_name) {
    class_name = _class_name;
    import AOQ.Backend.Functions;
  }

  this(this) {
    class_name      = class_name.dup;
    value_indices   = value_indices.dup;
    value_names     = value_names.dup;
    value_types     = value_types.dup;
    message_table_2 = message_table_2.dup;
    message_table_3 = message_table_3.dup;
  }
}

mixin template Integer_Message_Table_T3(alias r, alias s,
                                        alias func, string sign) {
  Obj Execute_Fn() {
    // Size must be one, element must be valid
    if ( s.base_class.value_types.length != 1 )
      Throw_Exception(r, s, sign);
    switch ( s.base_class.value_types[0] ) {
      default: assert(0);
      case SymbolType.stringeger:
        Throw_Exception(r, s, sign);
        assert(0);
      case SymbolType.booleaner:
        return Obj(func(r.values[0].integer, cast(int)s.values[0].booleaner));
      case SymbolType.integer:
        return Obj(func(r.values[0].integer, s.values[0].integer));
      case SymbolType.floateger:
        return Obj(func(r.values[0].integer, s.values[0].floateger));
      case SymbolType.object:
        // Don't know how to handle this! Let the object do it!
        return s.Receive_Msg(Obj(sign), r);
    }
    assert(0);
  }
}

mixin template Floateger_Message_Table_T3(alias r, alias s,
                                        alias func, string sign) {
  Obj Execute_Fn() {
    // Size must be one, element must be valid
    if ( s.base_class.value_types.length != 1 )
      Throw_Exception(r, s, sign);
    switch ( s.base_class.value_types[0] ) {
      default: assert(0);
      case SymbolType.stringeger:
        Throw_Exception(r, s, sign);
        assert(0);
      case SymbolType.integer:
        return Obj(func(r.values[0].floateger, s.values[0].integer));
      case SymbolType.floateger:
        return Obj(func(r.values[0].floateger, s.values[0].floateger));
      case SymbolType.object:
        // Don't know how to handle this! Let the object do it!
        return s.Receive_Msg(Obj(sign), r);
    }
    assert(0);
  }
}


void Construct_Default_Classes() {
  classes.length = DefaultClass.max+1;
  { // base_object
    auto _base_object = Class("object");
    _base_object.message_table_2 = [
      "R_ClassName"    : function(Obj r) {
        return Obj(r.base_class.class_name);
      },
      "Stringify"      : function(Obj r) {
        return Obj(r.base_class.class_name);
      },
      "Truthity"       : function(Obj r) {
        return Obj(true);
      },
      "Print"          : function(Obj r) {
        import std.stdio : writeln;
        writeln(r.base_class.class_name);
        return r;
      },
      "."           : function(Obj r) {
        return r;
      }
    ];
    _base_object.message_table_3 = [
      "If"             : function(Obj r, Obj s) {
        if ( r.Truthity() )
          return s;
        return Obj(SymbolType.nil);
      },
      "^"              : function(Obj r, Obj s) {
        if ( r.Truthity() )
          return r;
        return s;
      },
      "Cast"           : function(Obj r, Obj s) {
        if ( r.Stringify() == s.Stringify() ) {
          return r;
        }
        Throw_Exception("Unknown cast from " ~ r.Stringify() ~
                                      " to " ~ s.Stringify());
        assert(0);
      }
    ];
    classes[DefaultClass.object] = _base_object;
  }
  auto _base = classes[0];
  { // nil
    auto _nil = _base;
    _nil.class_name = "nil";
    _nil.message_table_2["Is"] = function(Obj r) {
      return Obj(false);
    };
    _nil.message_table_2["Truthity"] = function(Obj r) {
      return Obj(false);
    },
    classes[DefaultClass.nil] = _nil;
  }
  { // booleaner
    auto _bool = _base;
    _bool.class_name = "Bool";
    _bool.message_table_2["Stringify"] = function(Obj r) {
      return Obj(r.values[0].booleaner == true ? "True" : "False");
    };
    classes[DefaultClass.booleaner] = _bool;
  }
  { // array
    auto _array = _base;
    _array.class_name = "Array";
    _array.value_indices = [Default_base_value_name: 0];
    _array.value_names   = [Default_base_value_name];
    _array.value_types   = [SymbolType.array];
    _array.message_table_2["Stringify"] = function(Obj r) {
      string str = "";
      auto arr = r.values[0].array;
      foreach ( n; arr ) {
        str ~= n.Stringify();
      }
      return Obj(str);
    };
    _array.message_table_2["Truthity"] = function(Obj r) {
      return Obj(r.values[0].array.length != 0);
    };
    _array.message_table_2["Print"] = function(Obj r) {
      string str = "[";
      auto arr = r.values[0].array;
      if ( arr.length > 0 ) {
        foreach ( n; 0 .. arr.length - 1 ) {
          str ~= " " ~ arr[n].Stringify() ~ ",";
        }
        str ~= " " ~ arr[$-1].Stringify();
      }
      str ~= " ]";
      return Obj(str);
    };

    _array.message_table_3["~"] = function(Obj r, Obj s) {
       return Obj.Construct_Class(r.values[0].array ~ s);
    };
  }
  { // integer
    auto _int = _base;
    _int.class_name = "integer";
    _int.value_indices = [Default_base_value_name: 0];
    _int.value_names   = [Default_base_value_name];
    _int.value_types   = [SymbolType.integer];
    // -- define functions
    _int.message_table_2["Stringify"] = function(Obj r) {
      import std.conv : to;
      return Obj(to!string(r.values[0].integer));
    };
    _int.message_table_2["Truthity"]  = function(Obj r) {
      return Obj(cast(bool)(r.values[0].integer != 0));
    };
    _int.message_table_2["Print"] = function(Obj r) {
      import std.stdio : writeln;
      writeln(r.values[0].integer);
      return r;
    };

    // TODO: Possibly benchmark this to see how slow it is compared to not
    // using a template mixin

    _int.message_table_3["+"] = function(Obj r, Obj s) {
      auto f_add = function(float _r, float _s) { return _r + _s; };
      mixin Integer_Message_Table_T3!(r, s, f_add, "+");
      return Execute_Fn();
    };
    _int.message_table_3["-"] = function(Obj r, Obj s) {
      auto f_sub = function(float _r, float _s) { return _r - _s; };
      mixin Integer_Message_Table_T3!(r, s, f_sub, "-");
      return Execute_Fn();
    };
    _int.message_table_3["/"] = function(Obj r, Obj s) {
      auto f_div = function(float _r, float _s) {return cast(float)(_r / _s);};
      mixin Integer_Message_Table_T3!(r, s, f_div, "/");
      return Execute_Fn();
    };
    _int.message_table_3["\\"] = function(Obj r, Obj s) {
      auto f_div = function(float _r, float _s) {return cast(int)(_r / _s);};
      mixin Floateger_Message_Table_T3!(r, s, f_div, "/");
      return Execute_Fn();
    };
    _int.message_table_3["//"] = function(Obj r, Obj s) {
      auto f_mod = function(float _r, float _s) {
                     return cast(int)_r % cast(int)_s;
                   };
      mixin Integer_Message_Table_T3!(r, s, f_mod, "//");
      return Execute_Fn();
    };
    _int.message_table_3["*"] = function(Obj r, Obj s) {
      auto f_ast = function(float _r, float _s) { return _r * _s; };
      mixin Integer_Message_Table_T3!(r, s, f_ast, "*");
      return Execute_Fn();
    };
    _int.message_table_3["Range"] = function(Obj r, Obj s) {
      // R = low S = hi
      auto _range = Obj.Construct_Class(DefaultMessageClass.range);
      // TODO: needs a constructor of some sorts
      // TODO: Also needs to verify this is an integer
      _range.values[0].integer = r.values[0].integer;
      _range.values[1].integer = s.values[0].integer;
      return _range;
    };
    classes[DefaultClass.integer] = _int;
  }
  {
    auto _float = classes[DefaultClass.integer];
    _float.class_name = "floateger";
    _float.value_types = [SymbolType.floateger];
    // -- define functions
    _float.message_table_2["Stringify"] = function(Obj r) {
      import std.conv : to;
      return Obj(to!string(r.values[0].floateger));
    };
    _float.message_table_2["Truthity"]  = function(Obj r) {
      // TODO: make abs function
      return Obj(r.values[0].floateger < float.epsilon);
    };
    _float.message_table_3["+"] = function(Obj r, Obj s) {
      auto f_add = function(float _r, float _s) { return _r + _s; };
      mixin Floateger_Message_Table_T3!(r, s, f_add, "+");
      return Execute_Fn();
    };
    _float.message_table_3["-"] = function(Obj r, Obj s) {
      auto f_sub = function(float _r, float _s) { return _r - _s; };
      mixin Floateger_Message_Table_T3!(r, s, f_sub, "-");
      return Execute_Fn();
    };
    _float.message_table_3["/"] = function(Obj r, Obj s) {
      auto f_div = function(float _r, float _s) {return cast(float)(_r / _s);};
      mixin Floateger_Message_Table_T3!(r, s, f_div, "/");
      return Execute_Fn();
    };
    _float.message_table_3["\\"] = function(Obj r, Obj s) {
      auto f_div = function(float _r, float _s) {return cast(int)(_r / _s);};
      mixin Floateger_Message_Table_T3!(r, s, f_div, "\\");
      return Execute_Fn();
    };
    _float.message_table_3.remove("//");
    _float.message_table_3["*"] = function(Obj r, Obj s) {
      auto f_ast = function(float _r, float _s) { return _r * _s; };
      mixin Floateger_Message_Table_T3!(r, s, f_ast, "*");
      return Execute_Fn();
    };
    classes[DefaultClass.floateger] = _float;
  }
  { // symbol
    auto _symbol = _base;
    _symbol.class_name = "Symbol";
    _symbol.message_table_2["Stringify"] = function(Obj r) {
      auto e = Obj(r.base_class.class_name);
      return e;
    };
    classes[DefaultClass.symbol] = _symbol;
    // can construct symbol classes now that we have a symbol
    Construct_Default_Symbol_Classes();
  }
  { // stringeger
    auto _str = _base;
    _str.class_name = "String";
    _str.value_indices = [Default_base_value_name: 0];
    _str.value_names   = [Default_base_value_name];
    _str.value_types   = [SymbolType.stringeger];
    _str.message_table_2["Stringify"] = function(Obj r) {
      return r;
    };
    _str.message_table_3["~"]         = function(Obj r, Obj s) {
      return Obj(r.Stringify() ~ s.Stringify());
    };
  }
  
}


void Construct_Default_Symbol_Classes() {
  auto symbol = classes[DefaultClass.symbol];
  symbol_classes.length = DefaultMessageClass.max + 1;
  { // +
    auto _plus = symbol;
    _plus.class_name = "+";
    symbol_classes[DefaultMessageClass.plus] = _plus;
  }

  { // -
    auto _minus = symbol;
    _minus.class_name = "-";
    symbol_classes[DefaultMessageClass.minus] = _minus;
  }
  { // /
    auto _slash = symbol;
    _slash.class_name = "/";
    // _slash.message_table_2["/"] = function(Obj r) {
    //   // // convert to modulo
    //   // auto o = r;
    //   // o.message_table_2["Stringify"] = function(Obj r) {
    //   //   return "//";
    //   // };
    //   // return o;
    //   return Obj();
    // };
    symbol_classes[DefaultMessageClass.slash] = _slash;
  }
  { // //
  }
  { // *
    auto _asterik = symbol;
    _asterik.class_name = "*";
    symbol_classes[DefaultMessageClass.asterik] = _asterik;
  }
  { // %
    auto _percent = symbol;
    _percent.class_name = "%";
    symbol_classes[DefaultMessageClass.percent] = _percent;
  }
  { // ~
    auto _tilde = symbol;
    _tilde.class_name = "~";
    symbol_classes[DefaultMessageClass.tilde] = _tilde;
  }
  { // ^
    auto __caret = symbol;
    __caret.class_name = "^";
    symbol_classes[DefaultMessageClass.caret] = __caret;
  }
  { // \
    auto _bslash = symbol;
    _bslash.class_name = "\\";
    symbol_classes[DefaultMessageClass.bslash] = _bslash;
  }
  { // dot
    auto _dot = symbol;
    _dot.class_name = ".";
    symbol_classes[DefaultMessageClass.dot] = _dot;
  }
  { // Stringify
    auto _stringify = symbol;
    _stringify.class_name = "Stringify";
    symbol_classes[DefaultMessageClass.stringify] = _stringify;
  }
  { // If
    auto __if = symbol;
    __if.class_name = "If";
    symbol_classes[DefaultMessageClass._if] = __if;
  }
  { // loop
    auto _loop = symbol;
    _loop.class_name = "Loop";
    symbol_classes[DefaultMessageClass.loop] = _loop;
  }
  { // loop
    auto _loop = symbol;
    _loop.class_name = "Loop_Sum";
    symbol_classes[DefaultMessageClass.loop_sum] = _loop;
  }
  { // range
    auto _range = symbol;
    _range.class_name = "Range";
    _range.value_indices = ["low" : 0,
                            "high": 1];
    _range.value_names   = ["low", "high"];
    _range.value_types   = [SymbolType.integer, SymbolType.integer];
    _range.message_table_3["Loop_Sum"] = function(Obj r, Obj s) {
      int low = r.values[0].integer,
          hi  = r.values[1].integer;
      if ( low >= hi )
        return Obj(0);
      Obj sum;
      foreach ( it; low .. hi ) {
        Obj nval = Obj(it).Receive_Msg(s);
        if ( it == low )
          sum = nval;
        else {
          // { // ---  DEBUG ---
          //   import std.stdio;
          //   writeln("Adding ", sum.base_class.class_name, " (", sum.Stringify,
          //           ") with ", nval.base_class.class_name, " (",
          //           nval.Stringify, ")");
          // } // --- EDEBUG ---
          sum = sum.Receive_Msg(nval, Obj("+"));
          // { // ---  DEBUG ---
          //   import std.stdio;
          //   writeln("New sum: ", sum.base_class.class_name, " (", sum.Stringify,
          //           ")");
          // } // --- EDEBUG ---
        }
      }
      return sum;
    };
    _range.message_table_3["Loop"] = function(Obj r, Obj s) {
      int low = r.values[0].integer,
          hi  = r.values[1].integer;
      if ( low >= hi )
        return Obj(0);
      foreach ( it; low .. hi ) {
        Obj(it).Receive_Msg(s);
      }
      return Obj(SymbolType.nil);
    };
    symbol_classes[DefaultMessageClass.range] = _range;
  }
}