# Combinatory Logic Evaluator

A dead-simple combinatory logic interpreter in Haskell. 

The 2 rules of combinatory logic are:
1. `K x y = x`
2. `S x y z = x z (y z)`

There is a third, optional rule: `I x = x` - though it can be derived from just the 2 previous rules.

These rules form a Turing-complete model of computation.

Here's an example session of the program:

```
COMBINATORY LOGIC EVALUATOR
Try (S x (K y w) (I z)) for example. Type 'quit' to exit
> (S x (K y w) (I z))
((x z) (y z))
> (I (I (I x)))
x
> quit
```

The source is reasonably well-commented and quite easy to follow. Feel free to browse it.