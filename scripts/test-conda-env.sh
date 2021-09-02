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

echo "Running the command before setting up myenv............"
# run test-env.py  (modify according to your environment)
python3 /home/manu1729/tscc-examples/test-env.py

cd "${LOCAL_SCRATCH_DIR}"
cp "${STORE_DIR}/myenv.tar.gz" ./
mkdir -p myenv
tar -xf myenv.tar.gz -C myenv/

source myenv/bin/activate
conda-unpack
echo "Running the command after setting up myenv............"
# run test-env.py  (modify according to your environment)
python3 /home/manu1729/tscc-examples/test-env.py
