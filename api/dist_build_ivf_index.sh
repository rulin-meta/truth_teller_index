#!/bin/bash
#SBATCH --job-name=ivf_index
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1        
#SBATCH --hint=nomultithread      
#SBATCH --account fair_amaia_cw_explore
#SBATCH --qos explore
#SBATCH --gres=gpu:1          
#SBATCH --time 99:00:00           
#SBATCH --output=/checkpoint/amaia/explore/rulin/truth_teller/slurm_cache/slurm-%A_%a.out
#SBATCH --exclusive
#SBATCH --array=0-31


cd /checkpoint/amaia/explore/rulin/truth_teller_index
source /home/rulin/miniconda3/bin/activate
conda activate vllm

export PYTHONPATH=/checkpoint/amaia/explore/rulin/truth_teller_index

DOMAIN=rpj_c4
NUM_SHARDS=32
SHARD_ID=$SLURM_ARRAY_TASK_ID

python /checkpoint/amaia/explore/rulin/truth_teller_index/api/build_ivf_index.py \
    --domain $DOMAIN \
    --num_shards $NUM_SHARDS \
    --shard_id $SHARD_ID