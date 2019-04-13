# Schmidty
[![Build Status](https://travis-ci.org/DKXXXL/Schmidty.svg?branch=by-llvm-pretty-print)](https://travis-ci.org/DKXXXL/Schmidty)

Customized Subtyping with sum type. Typing Core Scheme. An exercise in Haskell, since this world doesn't need yet another programming language anymore.

From now on, the focus will be on the formal semantic and the type system (See VSchmidty mentioned below) (or maybe other programming language features) instead of a real working implementation. 

Forked from Emesch.

## Functionality to implement ...
  - [x] LLVM backend, and thus to js, x86, etc
  - [ ] LLVM supported JIT compiler
  - [ ] LLVM supported FFI
  - [ ] Formally verified interpreter, for checking the soundness of this language : [VSchmidty](https://github.com/DKXXXL/VSchmidty)
  - [ ] A light interpreter on web
  - [ ] A Sound and Strong Type Inference
  - [ ] Some kind of Generic/Higher Kinded Type without destroying the ability of Type Inference
  
  
#
## Syntax
Syntax is one of the hardest to design. Thus currently I will only use S-expression and consider what this core language need. <br />The discussion of syntax is postponed.

However, showing syntax here can be helpful: with appropriate naming you can understand the language core and its semantic. <br />
*Currently not supporting commenting*

### lambda & let
``` 
$> ((lambda ((x Int)) 6) 7) 
   7
```


```
$> ((lambda ((x Int) (y Int)) 6) 7)
   <lambda:...>    # auto-curried
```

```
$> (let i Int 7 6)
   6
```

```
$> (let i Int (suc i) 6)
                   # Unhalt
```

```
$> (let i (-> Int Int) (lambda ((x Int)) (if (> x 0) (i (dec x)) 7)) (i 6))
    7
```


### Internal Functions
```
suc :: Int -> Int
dec :: Int -> Int
left tl T :: TSum (TypeOf tl) T
right T tr :: TSum T (TypeOf tr)
>, =, < :: Int -> Int -> Bool
#t :: Bool
#f :: Bool
beq :: Bool -> Bool -> Bool
ceq :: Char -> Char -> Bool
none :: None
```

### case & if
(if *crit* *trueBruch* *falseBrunch*) <br />
\# *trueBruch* & *falseBrunch* must yield same type <br />
\# *crit* must be Bool <br />

(case *crit* *leftBrunch* *rightBrunch*) <br />
where <br />
*crit* :: TSum TL TR <br />
*leftBrunch* :: TL -> TYRET <br />
*rightBrunch* :: TR -> TYRET <br />

### Record & FFI

(letrcd *constructorName* *NewRecordTypeName* *ItsSuperType* (Record [(*fieldname* *Type*)] <br />
   *body*) <br />
\# Custom Type Declaration works in a lexical scoping <br />
\# You will also get a function *constructorName* with input type of all fieldType and return a Type of *NewRecordTypeName*

(Field *Typename* *fieldname*) <br />
\# Gives you a function :: *Typename* -> (TypeOf *fieldname*)

(letext *externalName* *Type* *body*) <br />
\# Would be linking by LLVM itself. Because of the auto-currying thing, so you should <br />
\# make sure the environment and partially evaluated lambda would return, where you have to access environment info <br />
\# which hasn't been supported yet


## Usage
```
$> git clone ...
$> cd Schmidty
$> stack build
$> stack exec Schmidty < {-Source File-} > out.ll
# Use stdin and stdout
$> clang out.ll lib\sch.ll lib\gc.ll -o a.out
# a.out is what you want.
```

