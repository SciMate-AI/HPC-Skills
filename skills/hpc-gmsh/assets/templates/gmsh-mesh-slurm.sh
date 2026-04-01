#!/bin/bash
#SBATCH --job-name=gmsh_mesh
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

input_geo="${1:-minimal_rectangle_2d.geo}"
dim="${2:-2}"
output_mesh="${3:-mesh.msh}"

cd "${SLURM_SUBMIT_DIR:-$PWD}"

# module purge
# module load gmsh

gmsh "${input_geo}" -"${dim}" -format msh4 -o "${output_mesh}"
