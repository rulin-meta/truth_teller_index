# truth_teller_index
This repository provides an instruction on API serving for the TruthTeller project. Please refer to [the original repository](https://github.com/RulinShao/retrieval-scaling) for more details about datastore construction and offline evalaution.


# Sending Requests
If the API has been served, you can either send single or bulk query requests to it.

**Bash Examples.**

```bash
# single-query request
curl -X POST rulin@cw-h100-220-009:41077/search -H "Content-Type: application/json" -d '{"query": "Where was Marie Curie born?", "n_docs": 1, "domains": "MassiveDS"}'

# multi-query request
curl -X POST rulin@cw-h100-197-159:34621/search -H "Content-Type: application/json" -d '{"query": ["Where was Marie Curie born?", "What is the capital of France?", "Who invented the telephone?"], "n_docs": 2, "domains": "MassiveDS"}'
```

Example output of a multi-query request:
```json
{
  "message": "Search completed for '['Where was Marie Curie born?', 'What is the capital of France?', 'Who invented the telephone?']' from MassiveDS",
  "n_docs": 2,
  "query": [
    "Where was Marie Curie born?",
    "What is the capital of France?",
    "Who invented the telephone?"
  ],
  "results": {
    "n_docs": 2,
    "query": [
      "Where was Marie Curie born?",
      "What is the capital of France?",
      "Who invented the telephone?"
    ],
    "results": {
      "IDs": [
        [
          [3, 3893807],
          [17, 11728753]
        ],
        [
          [14, 12939685],
          [22, 1070951]
        ],
        [
          [28, 18823956],
          [22, 10406782]
        ]
      ],
      "passages": [
        [
          "Marie Skłodowska Curie (November 7, 1867 – July 4, 1934) was a physicist and chemist of Polish upbringing and, subsequently, French citizenship. ...",
          "=> Maria Skłodowska, better known as Marie Curie, was born on 7 November in Warsaw, Poland. ..."
        ],
        [
          "Paris is the capital and most populous city in France, as well as the administrative capital of the region of Île-de-France. ...",
          "[paʁi] ( listen)) is the capital and largest city of France. ..."
        ],
        [
          "Antonio Meucci (Florence, April 13, 1808 – October 18, 1889) was an Italian inventor. ...",
          "The telephone or phone is a telecommunications device that transmits speech by means of electric signals. ..."
        ]
      ],
      "scores": [
        [
          1.8422218561172485,
          1.8394594192504883
        ],
        [
          1.5528039932250977,
          1.5502511262893677
        ],
        [
          1.714379906654358,
          1.706493854522705
        ]
      ]
    }
  }
}
```


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