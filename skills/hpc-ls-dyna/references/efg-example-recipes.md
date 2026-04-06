# EFG Example Recipes

## Source Focus

- `dynaexamples.com/efg`
- `dynaexamples.com/efg/metal-cutting`

## Use This Reference For

- deciding whether Element Free Galerkin (EFG) is the right formulation for cutting, forging, or severe deformation
- understanding when adaptive EFG is preferable to conventional Lagrangian or SPH approaches
- selecting which parts of the metal-cutting example to retain and which must be re-calibrated

## Starter Deck Mapping

EFG is currently a source-first branch in this skill.

- start from the upstream `Metal Cutting` example itself
- borrow repository organization from `assets/templates/model-include-tree.txt`
- use `assets/templates/explicit-impact-outline.k` only as a high-level explicit-output guide, not as a direct EFG keyword starter

## Why Source-First Matters

The EFG branch overview explicitly positions adaptive EFG as the method of choice for:

- cutting
- bulk forming
- forging

and notes that local mesh refinement together with implicit time integration is a key enabler. That means the deck structure is heavily formulation-specific and should remain anchored to the upstream example until validated.

## Metal Cutting

Applicable problem:

- bulk metal cutting
- severe material separation where mesh-free or adaptively refined formulation is advantageous

Key solver family:

- adaptive EFG for cutting

Copy these controls:

- the adaptive EFG workflow itself
- cutting-specific observability and step sequencing
- the split between tool and workpiece modeling

Do not copy blindly:

- cutting speed
- tool geometry
- friction coefficient
- local refinement settings
- implicit-versus-explicit assumptions from the example without matching your deformation rate

Starter:

- start from the upstream `Metal Cutting` example
- use `assets/templates/explicit-impact-outline.k` only as a generic output/staging checklist

