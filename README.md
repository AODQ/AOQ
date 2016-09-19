# AoQ
An interpreted language based off OO, messaging and functional principles (smalltalk+lisp)


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
 (fn import |x|
   (foreach |y:x|c
     y:load_import ; << object oriented (y.load_import())
     OR
     (y load_import) ; << procedural (load_import(y))
   )
   :/
```

 which translates to

```
 (
   (
     (y load_import :) ; load_import <- : implies only use local definition on y
    |y:x| foreach ; (y load_import :)<- |y:x| <- foreach
   )
  |x| import fn ; |x| <- import <- fn gives function declaration (params + label)
                ; then anon func <- declaration gives label to that function definition
 )
;   label          params         return type (note {} implies constraints)
(fn square_and_add |x {is_scalar}| {is_scalar} ; is_scalar implies float, double, int, etc
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
(fn square_and_add |x {is_scalar: n| {is_scalar}
  x*2;
  x := (x+1);
)
```
