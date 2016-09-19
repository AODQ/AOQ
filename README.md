# AoQ
An interpreted, functional, message-based object-oriented language.
Made only to learn

example program
```
(module example_program)
(import (~ math io))
(import limits "")

(msg Sqrt_And_Double |x|
  {body
   $$ + (std:sqrt x x); return 2(sqrt(x)) - ($$ is local scope var and
                      ;                     defaults to current scope)
  }
  {in assert (x>0) "Must be > 0"}
  {unittest
    % 0 . % -23 . % 239 . % "asdf" . % 24.231
  }
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
  (| y | := $) ; Create new variable, set it to unnamed func var
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

how it works
```
(import io); import <- ioa
import [thread io math]; translates to (needs ;):
(import (~ thread io math))
(import (thread io math ~))
io <- ~ <- math becomes [io math]
thread <- ~ <- [io math] becomes [thread io math]
though later on [..] should skip this process
import <- [thread io math]
the import function looks like so:
(msg import |x|
  (foreach |y:x|c
    y:load_import ; << object oriented (y.load_import())
    OR
    (y load_import) ; << procedural (load_import(y))
  )
)
```

 which translates to

```
 (
   (
     (y load_import :) ; load_import <- : implies only use local definition on y
    |y:x| foreach ; (y load_import :)<- |y:x| <- foreach
   )
  |x| import msg ; |x| <- import <- msg gives function declaration (params + label)
                ; then anon func <- declaration gives label to that function definition
 )
;   label          params         return type (note {} implies constraints)
(msg square_and_add |x {is_scalar}| {is_scalar} ; is_scalar implies float, double, int, etc
  x*2 ; inline operators are allowed as long as both sides are "balanced"
      ; note this isn't stored into x, it's stored into the anon function register $
      ; interps: ($ (x 2 +) := )
  x := (x + 1) ; OR
  (:= x (x + 1)) ; OR
  (:= x (+ x 1)) ; OR
  (x (x 1 +) :=) ; (how it looks when fully interpreted)
  ; a function returns $ automatically, the last variable listed works too
)
```
in other words
```
(msg square_and_add |x {is_scalar: n| {is_scalar}
  x*2;
  x := (x+1);
)
```
