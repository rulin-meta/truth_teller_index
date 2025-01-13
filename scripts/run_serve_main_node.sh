#!/bin/bash
#SBATCH --job-name=main_serve
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1        
#SBATCH --hint=nomultithread      
#SBATCH --account fair_amaia_cw_explore
#SBATCH --qos explore
#SBATCH --mem 100G       
#SBATCH --time 7-00:00:00           
#SBATCH --output=/checkpoint/amaia/explore/rulin/truth_teller/slurm_cache/serve/%A_%a.out
#SBATCH --exclusive
#SBATCH --array=0


cd /checkpoint/amaia/explore/rulin/truth_teller_index
conda activate scaling
export PYTHONPATH=/checkpoint/amaia/explore/rulin/truth_teller_index



python /checkpoint/amaia/explore/rulin/truth_teller_index/api/main_node_serve.py
