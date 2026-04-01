# Trilinos Tpetra Map And Operator Playbook

## Map discipline

In `Tpetra`, map consistency is foundational.

Check these first:

- the row map matches matrix assembly ownership
- domain and range maps match the operator's actual action
- vectors used by the solver are created from compatible maps

If maps are inconsistent, solver tuning is noise.

## Import and export

When data moves between layouts:

- make the transfer path explicit through import or export objects
- verify the source and target maps are the ones the operator and preconditioner expect
- avoid hidden conversions that make debugging ownership impossible

## Operator construction

Before tuning `Belos`, `Ifpack2`, or `MueLu`, validate:

- the operator action is numerically plausible
- the matrix graph is assembled as intended
- preconditioners are built on the same operator family the solver sees
