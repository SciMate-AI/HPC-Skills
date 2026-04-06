# Contact And Constraints

## Source Focus

- `dynasupport.com/howtos/contact/contact-overview`
- `dynasupport.com/howtos/contact/contact-stiffness-and-the-option-soft`
- `dynasupport.com/howtos/contact/contact-thickness`
- `dynasupport.com/howtos/contact/contact-timestep`
- `dynasupport.com/howtos/contact/edge-to-edge-contact`
- `dynasupport.com/howtos/contact/tied-contact`
- `dynasupport.com/howtos/contact/contacts-for-spotwelds-and-bolts`
- `dynaexamples.com/show-cases/contact-overview`
- `dynaexamples.com/show-cases/preload`

## Contact Selection Baseline

`dynasupport.com/howtos/contact/contact-overview` separates broad automatic contact families from more specific pair definitions. Start with the smallest robust contact set that covers the expected interfaces:

- automatic single-surface for self-contact and many-part interaction
- automatic surface-to-surface when master/slave pairing is still useful
- edge-aware options when shell edge interaction matters
- tied or tiebreak logic when separation should be prohibited or controlled

Avoid stacking many redundant contacts over the same interface unless the precedence is explicit and justified.

## Contact Stiffness And SOFT

Contact stiffness can fix penetration or create timestep collapse depending on the interface and scale. Treat stiffness tuning as a balance among:

- penetration tolerance
- force noise
- timestep size
- surface discretization

If contact is unstable, inspect geometry, gap, thickness, and normals before increasing stiffness aggressively.

## Contact Thickness

`dynasupport.com/howtos/contact/contact-thickness` makes thickness handling a first-class issue for shell-dominant models. Review:

- whether shell thickness should contribute to contact gap
- whether offsets already account for geometric distance
- whether initial penetrations are geometric or thickness-induced

Many false contact problems are actually thickness-interpretation problems.

## Contact-Driven Timestep Problems

When the timestep collapses only after contact activation:

1. locate the activating interface
2. inspect tiny edge lengths or local mesh mismatch
3. simplify the contact family if possible
4. re-check shell thickness and segment quality
5. only then consider stiffness or scaling adjustments

## Tied Contacts And Connectors

Use tied contact when two surfaces should move together without separation. Use tiebreak or failure-capable interfaces when the bond may release. For bolts, spot welds, and fastener idealization, choose between:

- discrete connector abstractions
- tied interfaces
- local detailed geometry with contact

The choice depends on whether local clamp/load path fidelity or system-level efficiency is the priority.

## Edge-To-Edge And Shell Interfaces

Load `edge-to-edge-contact` when shell edges can hook, slide, or interpenetrate in ways that face-only contact misses. This matters in folded sheet metal, spotweld neighborhoods, and thin components with exposed free edges.

## Constraint And Preload Patterns

The `dynaexamples.com/show-cases/preload` lineage is useful when the model requires preload transfer before the main event. Common sequence:

1. establish assembly and contact closure
2. apply pretension or preload logic
3. lock or carry the preload state
4. continue with service loading or dynamic event

## Contact Review Checklist

Before launch:

- confirm every major interface has exactly the intended contact behavior
- confirm shell normals and segment definitions are coherent
- inspect initial penetrations and gap consistency
- verify tied interfaces are not masking a missing part connection elsewhere
- ensure outputs exist to diagnose contact force and interface status

## Failure Signals

Common signs that contact is the real root cause:

- severe force chatter
- timestep drop coincident with first touch
- nonphysical ejection or locking
- large contact energy without corresponding deformation logic
- apparent material instability that vanishes when contact is simplified
