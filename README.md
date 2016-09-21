# AoQ
An interpreted, dynamically-typed, functional, message-based object-oriented language.
Made only to learn

example program
```
(module example_program)
(import (~ math io))
(import limits "")

(msg Sqrt_And_Double |x!scalar|
  {body
   $$ + (std:sqrt x x); return 2(sqrt(x)) - ($$ is local scope var and
                      ;                     defaults to current scope)
  }
  {in assert (x>0) "Must be > 0"}
  {unittest
    % 0 . % -23 . % 239 . % "asdf" . % 24.231
  }
)

(msg Sqr_And_Double |x!array|
 {body
   (foreach x `(|n| ~= ((** n n)*2)));
   $@;
 }
 {in assert (foreach x `(|n!scalar| n>0)) "Must be > 0"}
)

(msg R_Sign |x|
  {body
    ((x < 0) ? false) . true
  }
  {in assert (scalar x) }
  {out assert (scalar $)}
  {unittest
    (% -3) = -1 . % (% 0) = 0 . (% 1) = 1
  }
)

(msg Sqrt_And_Double_Alternative | x |
  x (std:sqrt) x; infix squareroot
  (| y | := $) ; Create new variable, set it to unnamed var
  $ $ +; add, postfix no parens
  * 2 y; double, prefix no parens
)

(msg Log |x|
  (import time)
  {body
    ((std:io:out) "Log " ~ (std:time:now) ~ ": `x`") . nil
  }
  {in
   assert (`(x:tostr) != nil) "Tried to log an object with no tostr message"
  }
)

```

strange rules and oddities (until I can write proper documentation)
```
) Everything is an object. (+ 3 5) is an object, the + is an object, the 3 is an object, etc. Even
    the class is just an object.
) Every object/message can only take one or zero arguments
) Every object is constant
) Nearby operators are actualy two objects (:= becomes (= :))
) Infix messages (ei: 3 + 5) are allowed if either both sides are 'balanced' (there is only one object
    on each side), or there is no whitespace which allows for things like: x std:sqr y (two in-fix
    messages disguised as one: (x (std:sqrt) y)
) For oddities such as: std:math:sqrt. std:(math:sqrt) is clunky and nonsensical. In cases like this
    is when you would use (: std math sqrt) which is the equivalent. Useful for things like
    some_x!(~ (:x y z) (:a b c) d:f)
) ; is a comment, but also traverses to next statement '.' can be used for statements on one line
) $ is always returned if the last line ends with ; the value of which is the last calculation (if you
     wanted to, say, return an x, the variable by itself counts as a calculation)
) | x y | is actually (^ (~ x y)) and thus not only are the two combined and created, but
          | x y | := [2, 5]
  is valid syntax: ((= :) (^ (~ x y)) (~ 2 5))
) Since all objects can only have one operator, [x y z] becomes (~ (~ x y) z). So (x + y) + z is valid
) Objects do not inherit, they compose. The mixin object mixes all of another object into the current
    one, overriding any previous objects (so it is probably most practical for mixin to be the first
    part of a class definition).
) The { } scope is not for classes, definitions, etc. They are a "simplifier" -- they tell the
    parser to reinterpret the objects in that scope into a useful meaning.
) Objects that mixin the Operator can define a variable "Operator_Level." Then:
      {rfm 2 + 3*3 + 2*2 - 8)
    reformats to:
      (- (+ 2 (+ (*3 3) (*2 2))) 8)
```
For more information check notes: https://github.com/AODQ/AOQ/blob/master/test_programs/aoq_notes.aoq
