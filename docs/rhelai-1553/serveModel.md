## Serve the model

### Serve the model 

``` shell
 ilab -v model serve --model-path /mnt/djblock/demo/.cache/instructlab/models/instructlab/granite-7b-lab  --backend vllm --gpus 2 -- --served-model-name hello1
 ```
 
 ``` shell
 
 ...
 
INFO 09-19 20:46:19 api_server.py:257] Available routes are:
INFO 09-19 20:46:19 api_server.py:262] Route: /openapi.json, Methods: HEAD, GET
INFO 09-19 20:46:19 api_server.py:262] Route: /docs, Methods: HEAD, GET
INFO 09-19 20:46:19 api_server.py:262] Route: /docs/oauth2-redirect, Methods: HEAD, GET
INFO 09-19 20:46:19 api_server.py:262] Route: /redoc, Methods: HEAD, GET
INFO 09-19 20:46:19 api_server.py:262] Route: /health, Methods: GET
INFO 09-19 20:46:19 api_server.py:262] Route: /tokenize, Methods: POST
INFO 09-19 20:46:19 api_server.py:262] Route: /detokenize, Methods: POST
INFO 09-19 20:46:19 api_server.py:262] Route: /v1/models, Methods: GET
INFO 09-19 20:46:19 api_server.py:262] Route: /version, Methods: GET
INFO 09-19 20:46:19 api_server.py:262] Route: /v1/chat/completions, Methods: POST
INFO 09-19 20:46:19 api_server.py:262] Route: /v1/completions, Methods: POST
INFO 09-19 20:46:19 api_server.py:262] Route: /v1/embeddings, Methods: POST
INFO:     Started server process [34]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)

...
```


### Test the model

``` shell
# curl http://localhost:8000/version | jq .

{
  "version": "0.5.2.2"
}
```


```
# curl http://localhost:8000/v1/models | jq .

{
  "object": "list",
  "data": [
    {
      "id": "hello1",
      "object": "model",
      "created": 1726778941,
      "owned_by": "vllm",
      "root": "hello1",
      "parent": null,
      "max_model_len": 4096,
      "permission": [
        {
          "id": "modelperm-02142f12f187422c8b823a61312ed686",
          "object": "model_permission",
          "created": 1726778941,
          "allow_create_engine": false,
          "allow_sampling": true,
          "allow_logprobs": true,
          "allow_search_indices": false,
          "allow_view": true,
          "allow_fine_tuning": false,
          "organization": "*",
          "group": null,
          "is_blocking": false
        }
      ]
    }
  ]
}
```
