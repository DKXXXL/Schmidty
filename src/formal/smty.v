(*
    Schmidty.
*)
Add LoadPath "src/formal".
Require Import Maps.
Require Import Context.
Import Context.Context.
Require Import Coq.Lists.List.

Definition tyid := id.

Inductive ty : Set :=
    | TNat : ty 
    | TChr : ty
    | TFun : ty -> ty -> ty
    | TBool : ty
    | TSum : ty -> ty -> ty
    | TNone : ty
    | TRcd : ty -> list (id* ty) -> ty
    | TVar : tyid -> ty.

Inductive tm : Set :=
    | tnone : tm 
    | tif: tm -> tm -> tm -> tm 
    | tvar : id -> tm
    | tzero : tm
    | tsuc : tm -> tm 
    | tngt : tm -> tm -> tm 
    | tnlt : tm -> tm -> tm 
    | tneq : tm -> tm -> tm
    | tchr : nat -> tm 
    | tceq : tm -> tm -> tm 
    | tfun : id -> ty -> tm -> tm 
    | tapp : tm -> tm -> tm
    | tlet : id -> tm -> tm -> tm
    | ttrue : tm
    | tfalse : tm 
    | tbeq : tm -> tm -> tm 
    | tleft : tm -> ty -> tm 
    | tright : ty -> tm -> tm
    | tcase : tm -> tm -> tm -> tm 
        (*
            tcase (\ x -> x) (\ y -> y)
        *)
        (*
            type information is 
            lexical scoped
        *)
    | tletrcd : id -> tyid -> ty -> list (id* ty) -> tm -> tm
        (*
            letRcd (contructorA TypeA ParentType ((a, Int) (b, Int))
            in ... 
                 TypeA <: ParentType
            then constructorA :: Int -> Int -> TypeA
                 TypeA.a :: TypeA -> Int

            letRcd (i J (Nat Nat))
            then i :: Int -> Int -> J
        *)
    | tfield : ty -> id -> tm -> tm 
        (*
            TypeA.a :: TypeA -> Int
        *)
    | tseq : tm -> tm.

