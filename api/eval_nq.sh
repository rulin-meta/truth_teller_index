RETRIEVED_FILE=/checkpoint/amaia/explore/rulin/truth_teller_index/examples/nq_open_ip_searched_4096_contriever.jsonl
lm_eval --model hf \
  --model_args pretrained="meta-llama/Llama-2-7b-hf" \
  --tasks nq_open \
  --batch_size auto \
  --inputs_save_dir examples \
  --retrieval_file $RETRIEVED_FILE \
  --concat_k 3 \
  --num_fewshot 5 \
  --results_only_save_path /checkpoint/amaia/explore/rulin/lm_eval_out/nq_open.5shots.3docs.ivf_flat_ip_4096_contriever.jsonl


lm_eval --model hf \
  --model_args pretrained="meta-llama/Llama-2-7b-hf" \
  --tasks nq_open \
  --batch_size auto \
  --num_fewshot 5
