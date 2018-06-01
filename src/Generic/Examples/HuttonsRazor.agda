module Generic.Examples.HuttonsRazor where

open import Size
open import Data.Empty
open import Data.Unit
open import Data.Product
open import Data.Nat
open import Agda.Builtin.List
open import Agda.Builtin.Equality
open import Function

open import environment
open import Generic.Syntax
open import Generic.Semantics

-- Hutton's razor as a minimalistic example of a language
-- one may want to evaluate

data `HuttRaz : Set where Lit Add : `HuttRaz

HuttRaz : Desc ⊤
HuttRaz  = `σ `HuttRaz $ λ where
  Lit → `σ ℕ (λ _ → `∎ tt)
  Add → `X [] tt (`X [] tt (`∎ tt))

infixr 5 _[+]_
pattern lit n      = `con (Lit , n , refl)
pattern _[+]_ e f  = `con (Add , e , f , refl)

-- Because there are no variables whatsoever in this simple
-- language we can simply associated values of the empty to
-- them. The computation itself will deliver a natural number.

Eval : Sem HuttRaz (λ _ _ → ⊥) (λ _ _ → ℕ)
Sem.th^𝓥  Eval = ⊥-elim
Sem.var   Eval = ⊥-elim
Sem.alg   Eval = λ where
  (Lit , n , _)     → n
  (Add , m , n , _) → m + n

eval : Tm HuttRaz ∞ tt [] → ℕ
eval = Sem.closed Eval

-- And, sure enough, we are able to run these expressions

3+2 : eval (lit 3 [+] lit 2) ≡ 5
3+2 = refl

[2+6]+0 : eval ((lit 2 [+] lit 6) [+] lit 0) ≡ 8
[2+6]+0 = refl
