#!/bin/bash
#SBATCH --job-name=ivf_serve
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1        
#SBATCH --hint=nomultithread      
#SBATCH --account comem
#SBATCH --qos comem_high
#SBATCH --gres=gpu:1
#SBATCH --mem 1000G       
#SBATCH --time 7-00:00:00           
#SBATCH --output=/fsx-comem/rulin/.cache/slurm_cache/serve/%A_%a.out
#SBATCH --exclusive
#SBATCH --array=0-3%4


cd /fsx-comem/rulin/truth_teller_index
source /home/rulin/miniconda3/bin/activate
conda activate scaling
export PYTHONPATH=/fsx-comem/rulin/truth_teller_index


for i in {0..6}; do
  CHUNK_ID=$((8*SLURM_ARRAY_TASK_ID+i))
  echo "C4 Chunk ID: $CHUNK_ID"
  CHUNK_ID=$CHUNK_ID CUDA_VISIBLE_DEVICES=$i python /fsx-comem/rulin/truth_teller_index/api/serve_cw.py &
done

i=7
CHUNK_ID=$((8*SLURM_ARRAY_TASK_ID+i))
echo "C4 Chunk ID: $CHUNK_ID"
CHUNK_ID=$CHUNK_ID CUDA_VISIBLE_DEVICES=$i python /fsx-comem/rulin/truth_teller_index/api/serve_cw.py
