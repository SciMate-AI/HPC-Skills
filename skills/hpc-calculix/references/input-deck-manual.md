# CalculiX Input-Deck Manual

## Contents

- Deck structure
- Core keyword families
- Include and set logic

## Deck structure

CalculiX uses Abaqus-style keyword decks in `.inp` files.

Practical structure:

1. nodes and elements
2. sets
3. materials and sections
4. boundary and loading definitions
5. one or more `*STEP` blocks

Keep the deck ordered enough that later references always point to already defined entities.

## Core keyword families

High-value families include:

- `*NODE`
- `*ELEMENT`
- `*NSET`
- `*ELSET`
- `*MATERIAL`
- `*ELASTIC`
- `*DENSITY`
- `*SOLID SECTION`
- `*BOUNDARY`
- `*CLOAD`
- `*STEP`

Use the narrowest keyword that matches the intended feature rather than overloading generic sets or loads.

## Include and set logic

Set names are the linking surface for many later keywords.

If a set name is wrong or missing, section assignment, loads, and output requests often all fail downstream.
