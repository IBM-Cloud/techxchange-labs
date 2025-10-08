## Run performance benchmark (with two GPUs)


### Performance run 2

Now run a test with same parameters as in the previous test, but with model hosted with two GPUs.

| **Parameters**  ||
|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Server           | gx3-48x240x2l40s                                 |
| vCPUs, Memory           | 48, 240 GiB                                          |
| GPUs Available   | 2 × L40S                                         |
| GPUs Used        | **2 (two)**                                               |
| Model Name                   | ibm-granite/granite-3.3-8b-instruct                                                                                                                             |
| Model Parameters             | 8 billion                                                                                                                                                       |
| Request Type                 | sweep, with 30 requests |
| Input Tokens                 | 512  |
| Output Tokens                | 256  |

**Request Type** - sweep: Automatically runs a range of benchmarks to determine the minimum and maximum rates that the server and model can support.

**Input Tokens** - 512: Simulates the input prompt size, e.g., a simple inferencing question may have about 10-15 tokens but a summarization or classification request will vary depending on the content and context.

**Output Tokens**	- 256: Simulates the output size, e.g., a classification request output will have just a few tokens, while a summarization request output will vary depending on the content and context.

Generally, 1 word=approximately 1.3 tokens. In the benchmark, we are simulating data size for summarization requests where input is about one standard page content 
(Approximately 400 words = 512 tokens), we will also be requesting summarization to half the size (Approximalty 200 words = 256 tokens). 


Steps to run the test:

1. Serve the model (in the model serving terminal session)

Stop the single model serving (Ctrl-C). 

Start the model serving with 2 GPUs. Note the --gpus argument.

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


2. Run guidellm (in the guidellm terminal session)

Run the gudellm test with command below. 

As the test progresses, check GPU stats in nvidia-smi terminal window. Also confirm "Processes" shows both GPUs in use.

``` bash
guidellm benchmark --target "http://127.0.0.1:8000" --rate-type sweep --max-requests 30  --data "prompt_tokens=512,output_tokens=256"
```

**Output:**


``` bash
Creating backend...
Backend openai_http connected to http://127.0.0.1:8000 for model /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct.
Creating request loader...
Created loader with 1000 unique requests from prompt_tokens=512,output_tokens=256.
                                                                                  
                                                                                  
╭─ Benchmarks ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ [20:10:02] ⠼ 100% synchronous   (complete)   Req:    0.2 req/s,    4.36s Lat,     1.0 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:   58.7 gen/s,  293.7 tot/s,  59.8ms TTFT,   16.8ms ITL,   512 Prompt,      256 Gen                        │
│ [20:12:13] ⠼ 100% throughput    (complete)   Req:    3.9 req/s,    7.62s Lat,    29.6 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  996.1 gen/s, 4979.5 tot/s, 817.7ms TTFT,   26.7ms ITL,   512 Prompt,      256 Gen                        │
│ [20:12:21] ⠼ 100% constant@0.69 (complete)   Req:    0.6 req/s,    4.54s Lat,     2.9 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  165.1 gen/s,  825.3 tot/s,  71.9ms TTFT,   17.5ms ITL,   512 Prompt,      256 Gen                        │
│ [20:13:09] ⠼ 100% constant@1.15 (complete)   Req:    1.0 req/s,    4.77s Lat,     4.8 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  258.1 gen/s, 1290.0 tot/s,  72.8ms TTFT,   18.4ms ITL,   512 Prompt,      256 Gen                        │
│ [20:13:39] ⠼ 100% constant@1.60 (complete)   Req:    1.3 req/s,    5.02s Lat,     6.7 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  339.2 gen/s, 1695.2 tot/s,  70.8ms TTFT,   19.4ms ITL,   512 Prompt,      256 Gen                        │
│ [20:14:02] ⠼ 100% constant@2.06 (complete)   Req:    1.6 req/s,    5.27s Lat,     8.7 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  421.3 gen/s, 2105.4 tot/s,  74.7ms TTFT,   20.4ms ITL,   512 Prompt,      256 Gen                        │
│ [20:14:21] ⠼ 100% constant@2.52 (complete)   Req:    1.9 req/s,    5.48s Lat,    10.3 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  483.5 gen/s, 2416.8 tot/s,  75.3ms TTFT,   21.2ms ITL,   512 Prompt,      256 Gen                        │
│ [20:14:37] ⠼ 100% constant@2.98 (complete)   Req:    2.1 req/s,    5.72s Lat,    12.0 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  536.3 gen/s, 2680.6 tot/s,  77.4ms TTFT,   22.1ms ITL,   512 Prompt,      256 Gen                        │
│ [20:14:51] ⠼ 100% constant@3.43 (complete)   Req:    2.3 req/s,    6.00s Lat,    13.8 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  590.9 gen/s, 2953.9 tot/s,  82.9ms TTFT,   23.2ms ITL,   512 Prompt,      256 Gen                        │
│ [20:15:05] ⠼ 100% constant@3.89 (complete)   Req:    2.5 req/s,    6.12s Lat,    15.1 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  632.6 gen/s, 3162.2 tot/s,  81.5ms TTFT,   23.7ms ITL,   512 Prompt,      256 Gen                        │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
Generating... ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ (10/10) [ 0:05:14 < 0:00:00 ]
                    
                    
Benchmarks Metadata:
    Run id:bd7700ca-451c-4245-ad95-cd808ef56599
    Duration:314.9 seconds
    Profile:type=sweep, strategies=['synchronous', 'throughput', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant', 'constant',           
    'constant'], max_concurrency=None                                                                                                                          
    Args:max_number=30, max_duration=None, warmup_number=None, warmup_duration=None, cooldown_number=None, cooldown_duration=None
    Worker:type_='generative_requests_worker' backend_type='openai_http' backend_target='http://127.0.0.1:8000'                                                
    backend_model='/root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct' backend_info={'max_output_tokens': 16384, 'timeout': 300, 'http2':     
    True, 'authorization': False, 'organization': None, 'project': None, 'text_completions_path': '/v1/completions', 'chat_completions_path':                  
    '/v1/chat/completions'}                                                                                                                                    
    Request Loader:type_='generative_request_loader' data='prompt_tokens=512,output_tokens=256' data_args=None                                                 
    processor='/root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct' processor_args=None                                                        
    Extras:None
                
                
Benchmarks Info:
======================================================================================================================================================
Metadata                                      |||| Requests Made  ||| Prompt Tok/Req  ||| Output Tok/Req  ||| Prompt Tok Total||| Output Tok Total  ||
    Benchmark| Start Time| End Time| Duration (s)|  Comp|  Inc|  Err|   Comp|  Inc|  Err|   Comp|  Inc|  Err|   Comp|  Inc|  Err|   Comp|   Inc|   Err
-------------|-----------|---------|-------------|------|-----|-----|-------|-----|-----|-------|-----|-----|-------|-----|-----|-------|------|------
  synchronous|   20:10:02| 20:12:13|        130.7|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
   throughput|   20:12:13| 20:12:21|          7.7|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@0.69|   20:12:23| 20:13:09|         46.5|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15368|    0|    0|   7680|     0|     0
constant@1.15|   20:13:09| 20:13:39|         29.8|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15366|    0|    0|   7680|     0|     0
constant@1.60|   20:13:39| 20:14:02|         22.6|    30|    0|    0|  512.1|  0.0|  0.0|  256.0|  0.0|  0.0|  15362|    0|    0|   7680|     0|     0
constant@2.06|   20:14:02| 20:14:21|         18.2|    30|    0|    0|  512.1|  0.0|  0.0|  256.0|  0.0|  0.0|  15364|    0|    0|   7680|     0|     0
constant@2.52|   20:14:21| 20:14:37|         15.9|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@2.98|   20:14:37| 20:14:51|         14.3|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15366|    0|    0|   7680|     0|     0
constant@3.43|   20:14:52| 20:15:05|         13.0|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@3.89|   20:15:05| 20:15:17|         12.1|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15367|    0|    0|   7680|     0|     0
======================================================================================================================================================
                 
                 
Benchmarks Stats:
===================================================================================================================================================
Metadata     | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)||| TTFT (ms)          ||| ITL (ms)        ||| TPOT (ms)       ||
    Benchmark| Per Second| Concurrency|        mean|        mean| mean| median|  p99|  mean| median|    p99| mean| median|  p99| mean| median|  p99
-------------|-----------|------------|------------|------------|-----|-------|-----|------|-------|-------|-----|-------|-----|-----|-------|-----
  synchronous|       0.23|        1.00|        58.7|       293.7| 4.36|   4.27| 4.91|  59.8|   59.1|   63.1| 16.8|   16.5| 19.0| 16.8|   16.5| 18.9
   throughput|       3.89|       29.65|       996.1|      4979.5| 7.62|   7.62| 7.68| 817.7|  784.0| 1387.9| 26.7|   26.8| 29.3| 26.6|   26.7| 29.2
constant@0.69|       0.65|        2.93|       165.1|       825.3| 4.54|   4.57| 4.58|  71.9|   73.5|   80.0| 17.5|   17.6| 17.7| 17.5|   17.5| 17.6
constant@1.15|       1.01|        4.81|       258.1|      1290.0| 4.77|   4.82| 4.83|  72.8|   72.6|   80.7| 18.4|   18.6| 18.6| 18.4|   18.6| 18.6
constant@1.60|       1.33|        6.66|       339.2|      1695.2| 5.02|   5.11| 5.14|  70.8|   71.8|   82.1| 19.4|   19.8| 19.9| 19.3|   19.7| 19.8
constant@2.06|       1.65|        8.67|       421.3|      2105.4| 5.27|   5.34| 5.47|  74.7|   74.3|  117.1| 20.4|   20.7| 21.1| 20.3|   20.6| 21.0
constant@2.52|       1.89|       10.34|       483.5|      2416.8| 5.48|   5.54| 5.79|  75.3|   75.3|  116.7| 21.2|   21.4| 22.4| 21.1|   21.3| 22.3
constant@2.98|       2.10|       11.98|       536.3|      2680.6| 5.72|   5.81| 6.14|  77.4|   77.2|  119.3| 22.1|   22.5| 23.8| 22.0|   22.4| 23.7
constant@3.43|       2.31|       13.84|       590.9|      2953.9| 6.00|   6.06| 6.37|  82.9|   77.9|  163.9| 23.2|   23.5| 24.7| 23.1|   23.4| 24.6
constant@3.89|       2.47|       15.13|       632.6|      3162.2| 6.12|   6.33| 6.47|  81.5|   75.8|  166.9| 23.7|   24.3| 25.1| 23.6|   24.2| 25.0
===================================================================================================================================================
                           
Saving benchmarks report...
Benchmarks report saved to /var/roothome/benchmarks.json
                      
Benchmarking complete.

```

***Evaluate the results:***

Check the "Benchmarks Stats". As in the previous test, note the key metrics - Request Rate (Requests Per Second), Request Latency, Time to First Token (TTFT) for requests made under different test conditions - synchronous, throughput and constant rates.

***Compare results:***

How does the performance compare across the two benchmark tests - with model hosted using single GPU vs. two GPUs?

With two GPUs you should see more number of request per second can be supported with reduced Request latency and TTFT.





