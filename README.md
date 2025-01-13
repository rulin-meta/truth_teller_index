# truth_teller_index
This repository provides an instruction on API serving for the TruthTeller project. Please refer to [the original repository](https://github.com/RulinShao/retrieval-scaling) for more details about datastore construction and offline evalaution.


# Prepare Environment
```bash
conda env create -f environment.yml
conda activate scaling
```


# Serve the Index
First, search `rulin@` in this repo and replace with `<your_id@>`.

### Serve individual shards
To serve the prebuilt MassiveDS IVF index, first serve the index shards on different gpu nodes:
```bash
sbatch scripts/run_serve_c4.sh
sbatch scripts/run_serve_wiki.sh
```

### Serve the main node
Once the indices are on, the live endpoints will be logged in `running_ports_c4_wiki_ip_fixed.txt`. 
You can then serve a main node to perform distributed online search over all running endpoints (make sure all the endpoints in the file are running):
```bash
bash scripts run_serve_main_node.sh
```

The endpoint for the search main node will be logged in `running_ports_main_node.txt`. 


# Send Search Requests
For example, you can send a request to the main node
```bash
curl -X POST rulin@cw-h100-202-167:51325/search -H "Content-Type: application/json" -d '{"query": "Where was Marie Curie born?", "n_docs": 1, "domains": "MassiveDS", "subsample_ratio": 1.0}'
```
where `n_docs` specifies the number of retrieved documents and `subsample_ratio` (default=1.0) specifies the ratio of the documents you'd like to subsample from the entire datastore (which is useful for datastore scaling study).