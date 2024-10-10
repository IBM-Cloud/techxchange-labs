## Download a model

### Look into the .cache directory

``` shell
# ls -LR .cache/instructlab
.cache/instructlab:
models  oci

.cache/instructlab/models:

.cache/instructlab/oci:
```



### Download the model

``` shell
# ilab model download --repository instructlab/granite-7b-lab
```


``` shell
Downloading model from Hugging Face: instructlab/granite-7b-lab@main to /mnt/djblock/demo/.cache/instructlab/models...
Fetching 19 files:   0%|                                                                                                                  | 0/19 [00:00<?, ?it/s]
Downloading 'added_tokens.json' to '/mnt/djblock/demo/.cache/instructlab/models/instructlab/granite-7b-lab/.cache/huggingface/download/added_tokens.json.ab9131bbe927da43320e49abbd99b99ef56a9c9b.incomplete'

...
```

### List the model

``` shell
# ilab model list
+----------------------------+---------------------+---------+
| Model Name                 | Last Modified       | Size    |
+----------------------------+---------------------+---------+
| instructlab/granite-7b-lab | 2024-09-19 20:39:03 | 12.6 GB |
+----------------------------+---------------------+---------+
```


### Look into the .cache directory


``` shell
ls -LR .cache/instructlab
.cache/instructlab:
models  oci

.cache/instructlab/models:
instructlab

.cache/instructlab/models/instructlab:
granite-7b-lab

.cache/instructlab/models/instructlab/granite-7b-lab:
README.md          generation_config.json            model-00003-of-00003.safetensors  paper.pdf                tokenizer.model
added_tokens.json  model-00001-of-00003.safetensors  model-card                        special_tokens_map.json  tokenizer_config.json
config.json        model-00002-of-00003.safetensors  model.safetensors.index.json      tokenizer.json

.cache/instructlab/models/instructlab/granite-7b-lab/model-card:
'Model Card for Merlinite 7b 28cc0b72cf574a4a828140d3539ede4a_Screenshot_2024-02-22_at_11.26.13_AM.png'  'Model Card for Merlinite 7b 28cc0b72cf574a4a828140d3539ede4a_Untitled.png'
'Model Card for Merlinite 7b 28cc0b72cf574a4a828140d3539ede4a_Untitled 1.png'                            'Model Card for Merlinite 7b 28cc0b72cf574a4a828140d3539ede4a_intuition.png'
'Model Card for Merlinite 7b 28cc0b72cf574a4a828140d3539ede4a_Untitled 2.png'

.cache/instructlab/oci:
```
