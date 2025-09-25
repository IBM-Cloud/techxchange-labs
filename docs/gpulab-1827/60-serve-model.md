
## Serve a model for inferencing

### 1. List the models available on the VSI 

* Use the `ilab` command to list the models available on the VSI

``` bash
ilab model list
```

**Output:**

``` bash
[root@txc-gpulab-group1-vsi ~]# ilab model list
+-------------------------------------+---------------------+---------+---------------------------------------------+
| Model Name                          | Last Modified       | Size    | Absolute path                               |
+-------------------------------------+---------------------+---------+---------------------------------------------+
| ibm-granite/granite-3.3-8b-instruct | 2025-08-25 19:53:15 | 15.2 GB | /root/.cache/instructlab/models/ibm-granite |
| ibm-granite/granite-3.3-2b-instruct | 2025-08-25 19:53:15 | 4.7 GB  | /root/.cache/instructlab/models/ibm-granite |
+-------------------------------------+---------------------+---------+---------------------------------------------+
```

These models were already downloaded to the image that was used to bring up the VSI.

<p>&nbsp;</p>

### 2. Serve the model using the ilab command 

* Use the `ilab` command to serve the model for inferencing
* Utilize 2 GPUs
* Serve the `8b` model

``` bash
ilab model serve --model-path /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct  --backend vllm --gpus 2 -- --disable-custom-all-reduce --enforce-eager
```

**Output:**

``` bash
...

INFO 08-27 15:13:36 [api_server.py:1081] Starting vLLM API server on http://127.0.0.1:8000
INFO 08-27 15:13:36 [launcher.py:26] Available routes are:
INFO 08-27 15:13:36 [launcher.py:34] Route: /openapi.json, Methods: GET, HEAD
INFO 08-27 15:13:36 [launcher.py:34] Route: /docs, Methods: GET, HEAD
INFO 08-27 15:13:36 [launcher.py:34] Route: /docs/oauth2-redirect, Methods: GET, HEAD
INFO 08-27 15:13:36 [launcher.py:34] Route: /redoc, Methods: GET, HEAD
INFO 08-27 15:13:36 [launcher.py:34] Route: /health, Methods: GET
INFO 08-27 15:13:36 [launcher.py:34] Route: /load, Methods: GET
INFO 08-27 15:13:36 [launcher.py:34] Route: /ping, Methods: GET, POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /tokenize, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /detokenize, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/models, Methods: GET
INFO 08-27 15:13:36 [launcher.py:34] Route: /version, Methods: GET
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/chat/completions, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/completions, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/embeddings, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /pooling, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /score, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/score, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/audio/transcriptions, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /rerank, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v1/rerank, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /v2/rerank, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /invocations, Methods: POST
INFO 08-27 15:13:36 [launcher.py:34] Route: /metrics, Methods: GET
INFO:     Started server process [46]
INFO:     Waiting for application startup.
INFO:     Application startup complete.

...
```
<p>&nbsp;</p>

> [!NOTE]
> Wait till the `Application startup complete` message is displayed.


### 3. Chat with the model 

* Open another terminal window and run the ssh command to login and chat with the model using the `ilab` command


``` bash
ilab model chat --endpoint-url http://127.0.0.1:8000/v1
```

**Output:**

``` bash

[root@txc-gpulab-group1-vsi ~]# ilab model chat --endpoint-url http://127.0.0.1:8000/v1
INFO 2025-08-27 15:32:52,506 instructlab.model.chat:816: Requested model /root/.cache/instructlab/models/granite-3.1-8b-lab-v2 is not served by the server. Proceeding to chat with served model: /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct
╭─────────────────────────────────────────────────── system ───────────────────────────────────────────────────╮
│ Welcome to InstructLab Chat w/ GRANITE-3.3-8B-INSTRUCT (type /h for help)                                    │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
>>> Tell me about Raleigh, NC                                                                       [S][default]
╭────────────────────────────────────────── granite-3.3-8b-instruct ───────────────────────────────────────────╮
│ Raleigh is the capital city of North Carolina, United States. It's part of the Research Triangle             │
│ metropolitan area, known for its educational and research institutions.                                      │
│                                                                                                              │
│ Here are some key points about Raleigh:                                                                      │
│                                                                                                              │
│ 1. Location: It's located in Wake County, central North Carolina.                                            │
│ 2. Population: As of 2020, the estimated population is about 473,143.                                        │
│ 3. Education and Research: Raleigh is renowned for its rich array of research institutions. North Carolina   │
│ State University, Duke University, and the University of North Carolina at Chapel Hill are all within close  │
│ proximity.                                                                                                   │
│ 4. Technology Hub: Raleigh, along with its neighboring cities Durham and Chapel Hill, forms the Research     │
│ Triangle, an area known for its concentration of technology companies and research institutions.             │
│ 5. Parks and Outdoor Activities: The city is also home to several parks including Millbrook Park, Pullen     │
│ Park, and Umstead State Park which is one of the largest municipally owned parks in the southeastern United  │
│ States. It offers numerous outdoor activities such as hiking, camping, and fishing.                          │
│ 6. Arts and Culture: Raleigh also boasts a thriving arts and culture scene with numerous galleries, museums, │
│ and performance venues. Notable attractions include the North Carolina Museum of Art, the North Carolina     │
│ Museum of Natural Sciences, and the Raleigh Contemporary Art Center (BC).                                    │
│ 7. Climate: Raleigh experiences humid subtropical climate, with hot summers and mild winters.                │
╰────────────────────────────────────────────────────────────────────────────────────── elapsed 6.146 seconds ─╯
>>> quit                                                                                            [S][default]
```
<p>&nbsp;</p>

### 4. Interact with the model using `curl`

* Use `curl` command to interact with the model

``` bash
curl http://localhost:8000/v1/chat/completions   -H "Content-Type: application/json"   -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "What is the capital of US?"}
    ]
  }' | jq .

  ```

**Output:**

``` json
{
  "id": "chatcmpl-5020a5286b234c7b812988a99123cdac",
  "object": "chat.completion",
  "created": 1756309047,
  "model": "/root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "reasoning_content": null,
        "content": "The capital of the United States is Washington, D.C.",
        "tool_calls": []
      },
      "logprobs": null,
      "finish_reason": "stop",
      "stop_reason": null
    }
  ],
  "usage": {
    "prompt_tokens": 26,
    "total_tokens": 41,
    "completion_tokens": 15,
    "prompt_tokens_details": null
  },
  "prompt_logprobs": null
}
```