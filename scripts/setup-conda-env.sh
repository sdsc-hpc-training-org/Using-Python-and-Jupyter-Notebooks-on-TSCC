#!/bin/bash
#PBS -q condo
#PBS -N "conda-setup-env"
#PBS -l nodes=1:ppn=4  
#PBS -l walltime=03:00:00
#PBS -V
#PBS -m abe

module purge
module list
printenv


declare -xr STORE_DIR="/oasis/tscc/scratch/${USER}"
declare -xr LUSTRE_SCRATCH_DIR="/oasis/tscc/scratch/${USER}"
declare -xr LOCAL_SCRATCH_DIR="$TMPDIR"

echo "Local scratch: ${LOCAL_SCRATCH_DIR}"

declare -xr CONDA_DISTRIBUTION='miniconda'
declare -xr CONDA_VERSION='3'
declare -xr CONDA_PYTHON_VERSION='py37'
declare -xr CONDA_INSTALLER_VERSION='4.9.2'
declare -xr CONDA_ARCH='Linux-x86_64'
declare -xr CONDA_INSTALLER="${CONDA_DISTRIBUTION^}${CONDA_VERSION}-${CONDA_PYTHON_VERSION}_${CONDA_INSTALLER_VERSION}-${CONDA_ARCH}.sh"
declare -xr CONDA_ROOT_URL='https://repo.anaconda.com'

declare -xr CONDA_ROOT_DIR="${LOCAL_SCRATCH_DIR}"
declare -xr CONDA_INSTALL_DIR="${CONDA_ROOT_DIR}/${CONDA_DISTRIBUTION}/${CONDA_VERSION}/${CONDA_INSTALLER_VERSION}/${CONDA_PYTHON_VERSION}"
declare -xr CONDA_ENVS_PATH="${CONDA_INSTALL_DIR}/envs"
declare -xr CONDA_PKGS_DIRS="${CONDA_INSTALL_DIR}/pkgs"

module purge
module list
printenv

cd "${CONDA_ROOT_DIR}"

wget "${CONDA_ROOT_URL}/${CONDA_DISTRIBUTION}/${CONDA_INSTALLER}"
chmod +x "${CONDA_INSTALLER}"
time -p "./${CONDA_INSTALLER}" -b -p "${CONDA_INSTALL_DIR}"

source "${CONDA_INSTALL_DIR}/etc/profile.d/conda.sh"
conda activate base

time -p conda env create --name myenv --file "${STORE_DIR}/environment.yml"

conda activate myenv

time -p conda pack -n myenv -o myenv.tar.gz

time -p cp myenv.tar.gz "${STORE_DIR}"
