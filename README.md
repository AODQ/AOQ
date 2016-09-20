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
