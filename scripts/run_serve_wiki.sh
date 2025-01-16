#!/bin/bash
#SBATCH --job-name=wiki_serve
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
#SBATCH --array=0


cd /fsx-comem/rulin/truth_teller_index
conda activate scaling
export PYTHONPATH=/fsx-comem/rulin/truth_teller_index


CHUNK_ID=0 python /fsx-comem/rulin/truth_teller_index/api/serve_cw_wiki.py
