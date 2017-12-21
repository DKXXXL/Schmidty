Module Context.

Require Import Maps.
Require Import Coq.Relations.Relation_Definitions.
Require Import LibTactics.

Inductive Context {type : Set} : Type :=
| empty : Context
| update : id -> type -> Context -> Context.

Hint Constructors Context.

Fixpoint byContext {type : Set} (ctx : Context) (i : id) : option type :=
match ctx with 
    | empty => None
    | update x Ty ctx' =>
        if (eq_id_dec i x) then Some Ty else byContext ctx' i
        end.
Definition byContextb {type : Set} (ctx : Context) (i : id) : bool :=
    match byContext (type := type) ctx i with
    | Some _ => true 
    | None => false
    end.


Definition context_equivalence {type : Set}  : relation Context :=
        fun (x y : Context (type := type)) => forall i, byContext x i = byContext y i.
    
    Notation "x '=-=' y" := (context_equivalence x y) (at level 40).
    
    
    Print reflexive.
    Print equiv.

    
    Theorem refl_ctxeq {x : Set}:
        reflexive _ (context_equivalence (type := x )).
        unfold reflexive; unfold context_equivalence. auto.
    Qed.
    
    Hint Unfold reflexive.

    Theorem symm_ctxeq {x : Set}:
        symmetric _ (context_equivalence (type := x)).
        unfold symmetric; unfold context_equivalence. auto.
    Qed.

    Hint Unfold symmetric.
    Theorem trans_ctxeq {x : Set}:
    transitive _ (context_equivalence (type :=x)).

    unfold transitive.
    
    unfold context_equivalence.
    intros. rewrite H; auto.
Qed.

Hint Unfold transitive.

Theorem equiv_ctxeq {x : Set}:
    equiv _ (context_equivalence (type := x)).

    unfold equiv.
    pose (refl_ctxeq (x := x)). pose (symm_ctxeq (x := x)). pose (trans_ctxeq (x:= x)).
    tauto.
Qed.
    
    Theorem update_shadow {z : Set}:
        forall i (x y : z) (U V : Context (type := z)),
            U =-= V ->
            update i x (update i y U) =-= update i x V.
            
        unfold context_equivalence. intros.
        cbn. destruct (eq_id_dec i0 i); auto.
    
    Qed.
    
    Theorem update_permute {z : Set}:
        forall i j (x y : z) U V,
            i <> j ->
            U =-= V ->
            update i x (update j y U) =-= update j y (update i x U).
    
        unfold context_equivalence. 
        intros. cbn. destruct (eq_id_dec i0 i); destruct (eq_id_dec i0 j); auto; subst.
        destruct (H eq_refl).
    Qed.
    
    Theorem update_inc {z : Set}:
        forall i (x: z) U V,
            U =-= V ->
            update i x U =-= update i x V.
    
        unfold context_equivalence.
        intros. cbn. destruct (eq_id_dec i0 i); subst; auto.
    Qed.


Inductive CtxEq {z : Set} : Context (type := z) -> Context (type := z) -> Prop :=
    | eqEmpty : CtxEq empty empty
    | eqUpdate : forall U V i x,
                CtxEq U V ->
                CtxEq (update i x U) (update i x V)
    | eqPermute : forall U V i j x y,
                CtxEq U V ->
                i <> j ->
                CtxEq (update i x (update j y U))
                        (update j y (update i x V))
    | eqShadow : forall U V i x y,
                CtxEq U V ->
                CtxEq (update i x (update i y U))
                        (update i x U)
    | eqSymm : forall U V,
                CtxEq U V ->
                 CtxEq V U
    | eqTrans : forall U V W,
                CtxEq U V ->
                CtxEq V W ->
                CtxEq U W.
                        

Hint Constructors CtxEq.


Lemma byCtxEq_CtxEq:
    forall {z: Set} (U V: Context (type := z)),
        U =-= V ->
        CtxEq  U V.
intros z U; induction U;
intros V; induction V; auto.
unfold context_equivalence; unfold byContext;
intros eq1. generalize (eq1 i). intro.
rewrite eq_id_dec_id in H. inversion H.
unfold context_equivalence; unfold byContext.
intros eq1.
pose (eq1 i). rewrite eq_id_dec_id in e. inversion e. 
intros; auto.
Abort.

(* It's a little hard. Either some lemma is missing either it cannot be proved.*)

Lemma CtxEq_byCtxEq :
    forall {z: Set} (U V: Context (type := z)),
        CtxEq  U V ->
        U =-= V.

    intros z U V h; induction h; unfold context_equivalence;
    try (intros; unfold byContext; compute in *; auto; fail);
    try (intros; cbn; auto).
    destruct (eq_id_dec i0 i); subst; auto.
    destruct (eq_id_dec i0 i); destruct (eq_id_dec i0 j); subst; auto.
    destruct (H eq_refl).
    destruct (eq_id_dec i0 i); subst; auto.
    
    eapply (trans_ctxeq); eauto. 
Qed.

Notation "x '-=-' y" := (CtxEq x y) (at level 41).

Axiom ctxeq_ext :
    forall {type :Set} (U V : Context (type := type)),
        U -=- V -> U = V.



Theorem CtxeqId:
    forall {type : Set} (U : Context (type := type)),
        U -=- U.
    intros T U;
    induction U; eauto.
Qed.

    
    

End Context.

