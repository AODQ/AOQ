# AoQ
An interpreted, dynamically-typed language to be
used with my AoD engine. Heavily based off D and LISP.

example program
```
-- is an AOD Entity
entity Ball {
  This |x_ y_| {
    (Set_Position x_ y_)
    (= something (slice 1 2 ([1, 2, 3, 4])))
    (~ something 20.0)
  }
  Update {
    (> y 0 '(++ x) '(= y (- y))
  }
}

Sqr_And_Double |x| {
  (map x '(|n| { * n 2 }))
}
```
-- pipe dreams --
```
) modules
    module ball;
    import square, rectangle;
) static import
    square:Square
) type constraints
    Sqr_And_Double |x!array|
) assertions
    (assert some_condition error_message)
) objects with mixins (composability)

```
-- Why? --
```
) ties directly into AOD
) allows for fast, continous development
```
