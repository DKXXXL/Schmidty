Require Import Coq.Arith.Arith.
Require Import Coq.Bool.Bool.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Relations.Relation_Definitions.

Inductive id: Type :=
  |Id : nat -> id.

SearchPattern ({_ = _} + {_ <> _}).

Theorem eq_id_dec :
  forall id1 id2: id, {id1 = id2} + {id1 <> id2}.
  intros id1 id2. elim id1; elim id2.
  intros. case (eq_nat_dec n n0). intros h; left; rewrite h; trivial.
  unfold not; intros h; right; intros. injection H; auto.
Qed.

Theorem eq_id_dec_id:
  forall (A:Type) (t f:A) x,
   (if (eq_id_dec x x) then t else f) = t.

  intros; case (eq_id_dec x x); auto.
  intros. elim (n eq_refl).
Qed.   
Definition beq_id id1 id2 :=
  match (eq_id_dec id1 id2) with
    | left _ => true
    | right _ => false
  end.

Theorem beq_id_refl :
  forall id, true = beq_id id id.
  unfold beq_id.
  intros. case (eq_id_dec id0 id0); auto.
  unfold not; intros. elim (n (eq_refl id0)).
Qed.


Theorem beq_id_true_iff :
  forall id1 id2: id,
    beq_id id1 id2 = true <-> id1 = id2.
  unfold beq_id.
  intros. case (eq_id_dec id1 id2); try(tauto;auto).
  unfold not; split; intros.
  discriminate H. elim (n H).
Qed.

Theorem beq_id_false_iff :
  forall x y : id,
    beq_id x y = false <-> x <> y.
  split; unfold beq_id. case (eq_id_dec x y); try (tauto; auto).
  intros. discriminate H.
  case (eq_id_dec x y); intros; auto.
  elim (H e).
Qed.

Definition total_map (A:Type) := id -> A.

Definition t_empty {A:Type} (v:A): total_map A :=
  fun _ => v.


Definition t_update {A:Type} (m: total_map A) (x:id) (v:A) : total_map A :=
  fun y =>
    match eq_id_dec x y with
      | left Heq => v
      | right Hneq => m y
    end.


  Lemma t_update_eq :
  forall A (m:total_map A) x v,
    (t_update m x v) x = v.
    intros. unfold t_update. case (eq_id_dec x x); [auto | intros h; elim (h (eq_refl _))].

  Qed.

  

Lemma t_update_neq:
  forall (X:Type) v x1 x2 (m:total_map X),
    x1 <> x2 -> (t_update m x1 v) x2 = m x2.

  intros. unfold t_update.
  case (eq_id_dec x1 x2); intros. elim (H e). trivial.
Qed.

Lemma eq_t_update_dec:
  forall A (m:total_map A) x1 x2 v,
    {(t_update m x1 v) x2 = m x2} + {(t_update m x1 v) x2 = v}.
  intros.
  unfold t_update.
  case (eq_id_dec x1 x2); intros; try tauto.
Qed.



Lemma t_update_shadow:
  forall A (m:total_map A) v1 v2 x,
    t_update (t_update m x v1) x v2 =
    t_update m x v2.

  intros.
  apply functional_extensionality.
  unfold t_update. intros.
  case (eq_id_dec x x0); intros; auto.
Qed.

Print reflect.

Lemma beq_idP:
  forall x y,
    reflect (x = y) (beq_id x y).

  intros. unfold beq_id.
  case (eq_id_dec x y);intros; [apply ReflectT | apply ReflectF] ; auto.
Qed.

Theorem t_update_same :
  forall X x (m: total_map X),
    t_update m x (m x) = m.

  intros.
  apply functional_extensionality.
  intros. unfold t_update.
  case (eq_id_dec x x0); intros.
  rewrite e; auto.
  trivial.
Qed.

Theorem t_update_permute:
  forall (X:Type) v1 v2 x1 x2
         (m: total_map X),
    x2 <> x1 ->
    (t_update (t_update m x2 v2) x1 v1) =
    (t_update (t_update m x1 v1) x2 v2).
  intros.
  apply functional_extensionality.
  intros. unfold t_update.
  case (eq_id_dec x1 x); case (eq_id_dec x2 x); intros; try tauto.
  rewrite <- e0 in e. elim (H e).
Qed.

Definition partial_map (A:Type) :=
  total_map (option A).

Definition empty {A:Type} : partial_map A :=
  t_empty None.

Definition update {A:Type} (m:partial_map A)
           (x: id) (v:A) :=
  t_update m x (Some v).

Lemma update_eq:
  forall A (m:partial_map A) x v,
    (update m x v) x = Some v.
  intros; unfold update. 
  rewrite t_update_eq; auto.
Qed.

Lemma update_neq:
  forall (X:Type) v x1 x2
         (m:partial_map X),
    x2 <> x1 ->
    (update m x2 v) x1 = m x1.

  intros; unfold update; rewrite t_update_neq; auto.
Qed.

Theorem eq_update_dec:
  forall (X:Type) v x1 x2
         (m:partial_map X),
    {(update m x1 v) x2 = m x2} + {(update m x1 v) x2 = Some v}.
  intros. unfold update.
  apply eq_t_update_dec.
Qed.

Lemma update_shadow:
  forall A (m:partial_map A) v1 v2 x,
    update (update m x v1) x v2 = update m x v2.
  intros; unfold update; apply t_update_shadow.
Qed.

Print t_update_same.

Lemma update_same:
  forall X v x (m:partial_map X),
    m x = Some v ->
    update m x v = m.
  intros; unfold update. rewrite <- H. apply t_update_same.
Qed.


Lemma update_permute:
  forall (X:Type) v1 v2 x1 x2
         (m:partial_map X),
    x2 <> x1 ->
    (update (update m x2 v2) x1 v1) =
    (update (update m x1 v1) x2 v2).

  intros; unfold update. apply t_update_permute. auto.
Qed.

Theorem symm_dif :
  forall {Z : Type} (x y:Z),
    x <> y ->
    y <> x.
    unfold not. intros. symmetry in H0; auto.
Qed.


Theorem eq_id_dec_dif0:
forall (A:Type) (t f:A) x y,
 x <> y ->
 (if (eq_id_dec x y) then t else f) = f.
 intros. destruct (eq_id_dec x y); eauto.
 destruct (H e).
Qed.

Theorem eq_id_dec_dif1 :
forall (A:Type) (t f:A) x y,
  x <> y ->
  (if (eq_id_dec y x) then t else f) = f.
  intros.
  eapply eq_id_dec_dif0. eapply symm_dif. auto.
Qed.


Lemma exclusive_mid:
forall A,
  {A} + {~A} ->
  (A <-> ~~A).

split; intros.
intro. destruct (H1 H0).
destruct H; auto.
destruct (H0 n).
Defined.

Lemma contrapositive:
forall A B : Prop,
(A -> B) ->
(~B -> ~A).

intros; intro; eauto.
Defined.

Lemma contrapositive_equiv:
forall A B: Prop,
{A} + {~A} ->
{B} + {~B} ->
((A -> B) <-> (~B -> ~A)).

split; intros; destruct H; destruct H0; try tauto.
Defined.


