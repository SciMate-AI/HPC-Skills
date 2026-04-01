#!/bin/bash
set -euo pipefail

input_geo="${1:-minimal_rectangle_2d.geo}"
dim="${2:-2}"
output_mesh="${3:-mesh.msh}"

gmsh "${input_geo}" -"${dim}" -format msh4 -o "${output_mesh}"
