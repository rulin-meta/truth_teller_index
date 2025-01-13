#!/bin/bash
#SBATCH --job-name=ivf_serve
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1        
#SBATCH --hint=nomultithread      
#SBATCH --account fair_amaia_cw_explore
#SBATCH --qos explore
#SBATCH --gres=gpu:8
#SBATCH --mem 1000G       
#SBATCH --time 7-00:00:00           
#SBATCH --output=/checkpoint/amaia/explore/rulin/truth_teller/slurm_cache/serve/%A_%a.out
#SBATCH --exclusive
#SBATCH --array=0-3%4


cd /checkpoint/amaia/explore/rulin/truth_teller_index
conda activate scaling
export PYTHONPATH=/checkpoint/amaia/explore/rulin/truth_teller_index


for i in {0..6}; do
  CHUNK_ID=$((8*SLURM_ARRAY_TASK_ID+i))
  echo "C4 Chunk ID: $CHUNK_ID"
  CHUNK_ID=$CHUNK_ID CUDA_VISIBLE_DEVICES=$i python /checkpoint/amaia/explore/rulin/truth_teller_index/api/serve_cw.py &
done

i=7
CHUNK_ID=$((8*SLURM_ARRAY_TASK_ID+i))
echo "C4 Chunk ID: $CHUNK_ID"
CHUNK_ID=$CHUNK_ID CUDA_VISIBLE_DEVICES=$i python /checkpoint/amaia/explore/rulin/truth_teller_index/api/serve_cw.py
