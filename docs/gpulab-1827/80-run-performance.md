## Run performance benchmark (with single GPU)


### Performance run 1

First run a test that will use the granite-3.3-8b-instruct model with a single GPU and other parameters as mentioned below.

| **Parameters**  ||
|------------------|----------------------------------------------|
| Server           | gx3-48x240x2l40s                             |
| vCPUs, Memory    | 48, 240 GiB                                  |
| GPUs Available   | 2 x L40S                                     |
| GPUs Used        | **1 (single)**                               |
| Model Name       | ibm-granite/granite-3.3-8b-instruct.         |
| Model Parameters | 8 billion                                    |
| Request Type     | sweep, with 30 requests                      |
| Input Tokens     | 512                                          |
| Output Tokens    | 256                                          |

**Request Type** - sweep: Automatically runs a range of benchmarks to determine the minimum and maximum rates that the server and model can support.

**Input Tokens** - 512: Simulates the input prompt size, e.g., a simple inferencing question may have about 10-15 tokens but a summarization or classification request will vary depending on the content and context.

**Output Tokens**	- 256: Simulates the output size, e.g., a classification request output will have just a few tokens, while a summarization request output will vary depending on the content and context.

Generally, 1 word=approximately 1.3 tokens. In the benchmark, we are simulating data size for summarization requests where input is about one standard page content (Approximately 400 words = 512 tokens), we will also be requesting summarization to half the size (Approximalty 200 words = 256 tokens).  

Steps to run the test:

1. Serve the model (in the model serving terminal session)

If not already serving, start the model serving with 1 GPU and model id in the command below.

``` bash
ilab model serve --model-path /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct  --backend vllm --gpus 1 -- --disable-custom-all-reduce --enforce-eager
```

2. Run guidellm (in the guidellm terminal session)

Run the gudellm test with command below. As the test progresses, check GPU stats as described in next step.

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
│ [19:47:39] ⠦ 100% synchronous   (complete)   Req:    0.2 req/s,    6.48s Lat,     1.0 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:   39.5 gen/s,  197.5 tot/s,  53.0ms TTFT,   25.2ms ITL,   512 Prompt,      256 Gen                        │
│ [19:50:53] ⠦ 100% throughput    (complete)   Req:    2.9 req/s,   10.08s Lat,    29.6 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  752.3 gen/s, 3760.9 tot/s, 868.5ms TTFT,   36.1ms ITL,   512 Prompt,      256 Gen                        │
│ [19:51:04] ⠦ 100% constant@0.50 (complete)   Req:    0.5 req/s,    7.00s Lat,     3.3 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  119.0 gen/s,  594.8 tot/s,  74.2ms TTFT,   27.2ms ITL,   512 Prompt,      256 Gen                        │
│ [19:52:10] ⠦ 100% constant@0.85 (complete)   Req:    0.7 req/s,    7.26s Lat,     5.3 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  187.3 gen/s,  936.1 tot/s,  81.6ms TTFT,   28.2ms ITL,   512 Prompt,      256 Gen                        │
│ [19:52:53] ⠦ 100% constant@1.20 (complete)   Req:    1.0 req/s,    7.42s Lat,     7.1 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  246.0 gen/s, 1229.4 tot/s,  77.4ms TTFT,   28.8ms ITL,   512 Prompt,      256 Gen                        │
│ [19:53:24] ⠦ 100% constant@1.55 (complete)   Req:    1.2 req/s,    7.60s Lat,     8.8 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  296.9 gen/s, 1483.9 tot/s,  76.5ms TTFT,   29.5ms ITL,   512 Prompt,      256 Gen                        │
│ [19:53:51] ⠦ 100% constant@1.89 (complete)   Req:    1.3 req/s,    7.78s Lat,    10.4 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  341.0 gen/s, 1704.4 tot/s,  75.1ms TTFT,   30.2ms ITL,   512 Prompt,      256 Gen                        │
│ [19:54:13] ⠦ 100% constant@2.24 (complete)   Req:    1.5 req/s,    8.12s Lat,    12.3 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  386.3 gen/s, 1930.6 tot/s,  80.3ms TTFT,   31.5ms ITL,   512 Prompt,      256 Gen                        │
│ [19:54:33] ⠦ 100% constant@2.59 (complete)   Req:    1.6 req/s,    8.28s Lat,    13.5 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  418.0 gen/s, 2089.7 tot/s,  77.3ms TTFT,   32.2ms ITL,   512 Prompt,      256 Gen                        │
│ [19:54:52] ⠦ 100% constant@2.94 (complete)   Req:    1.7 req/s,    8.44s Lat,    14.7 Conc,      30 Comp,        0 Inc,        0 Err                        │
│                                              Tok:  445.5 gen/s, 2227.0 tot/s,  77.5ms TTFT,   32.8ms ITL,   512 Prompt,      256 Gen                        │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
Generating... ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ (10/10) [ 0:07:30 < 0:00:00 ]
                    
                    
Benchmarks Metadata:
    Run id:cd2ab424-e885-4b21-b483-9c2c5b876e63
    Duration:451.0 seconds
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
  synchronous|   19:47:39| 19:50:53|        194.4|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
   throughput|   19:50:53| 19:51:04|         10.2|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@0.50|   19:51:06| 19:52:10|         64.5|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15368|    0|    0|   7680|     0|     0
constant@0.85|   19:52:12| 19:52:53|         41.0|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15366|    0|    0|   7680|     0|     0
constant@1.20|   19:52:53| 19:53:24|         31.2|    30|    0|    0|  512.1|  0.0|  0.0|  256.0|  0.0|  0.0|  15362|    0|    0|   7680|     0|     0
constant@1.55|   19:53:25| 19:53:50|         25.9|    30|    0|    0|  512.1|  0.0|  0.0|  256.0|  0.0|  0.0|  15364|    0|    0|   7680|     0|     0
constant@1.89|   19:53:51| 19:54:13|         22.5|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@2.24|   19:54:14| 19:54:33|         19.9|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15366|    0|    0|   7680|     0|     0
constant@2.59|   19:54:34| 19:54:52|         18.4|    30|    0|    0|  512.3|  0.0|  0.0|  256.0|  0.0|  0.0|  15369|    0|    0|   7680|     0|     0
constant@2.94|   19:54:52| 19:55:10|         17.2|    30|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|  15367|    0|    0|   7680|     0|     0
======================================================================================================================================================
                 
                 
Benchmarks Stats:
=====================================================================================================================================================
Metadata     | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)  ||| TTFT (ms)          ||| ITL (ms)        ||| TPOT (ms)       ||
    Benchmark| Per Second| Concurrency|        mean|        mean|  mean| median|   p99|  mean| median|    p99| mean| median|  p99| mean| median|  p99
-------------|-----------|------------|------------|------------|------|-------|------|------|-------|-------|-----|-------|-----|-----|-------|-----
  synchronous|       0.15|        1.00|        39.5|       197.5|  6.48|   6.48|  6.49|  53.0|   51.5|   61.8| 25.2|   25.2| 25.2| 25.1|   25.1| 25.1
   throughput|       2.94|       29.63|       752.3|      3760.9| 10.08|  10.09| 10.18| 868.5|  830.4| 1481.4| 36.1|   36.3| 38.8| 36.0|   36.2| 38.6
constant@0.50|       0.46|        3.26|       119.0|       594.8|  7.00|   7.02|  7.03|  74.2|   73.6|   87.3| 27.2|   27.2| 27.2| 27.1|   27.1| 27.1
constant@0.85|       0.73|        5.31|       187.3|       936.1|  7.26|   7.27|  7.50|  81.6|   74.1|  314.2| 28.2|   28.2| 29.1| 28.1|   28.1| 29.0
constant@1.20|       0.96|        7.13|       246.0|      1229.4|  7.42|   7.49|  7.53|  77.4|   80.0|   88.5| 28.8|   29.1| 29.2| 28.7|   29.0| 29.1
constant@1.55|       1.16|        8.82|       296.9|      1483.9|  7.60|   7.69|  7.79|  76.5|   75.9|   94.6| 29.5|   29.8| 30.2| 29.4|   29.7| 30.1
constant@1.89|       1.33|       10.36|       341.0|      1704.4|  7.78|   7.83|  8.05|  75.1|   76.6|   89.9| 30.2|   30.4| 31.3| 30.1|   30.3| 31.2
constant@2.24|       1.51|       12.26|       386.3|      1930.6|  8.12|   8.17|  8.52|  80.3|   79.7|  122.5| 31.5|   31.8| 33.1| 31.4|   31.6| 33.0
constant@2.59|       1.63|       13.52|       418.0|      2089.7|  8.28|   8.37|  8.64|  77.3|   72.4|  115.8| 32.2|   32.5| 33.5| 32.0|   32.4| 33.4
constant@2.94|       1.74|       14.69|       445.5|      2227.0|  8.44|   8.54|  8.75|  77.5|   74.9|  120.2| 32.8|   33.2| 34.0| 32.7|   33.1| 33.9
=====================================================================================================================================================
                           
Saving benchmarks report...
Benchmarks report saved to /var/roothome/benchmarks.json
                      
Benchmarking complete.


```

***Evaluate the results:***


Note the key metrics Request Rate (Requests Per Second), Request Latency, Time to First Token (TTFT) for requests made under different test conditions - synchronous, throughput and constant rates.

- The stats for "_synchronous_" show the results of synchronous back-to-back calls. Requests per second will be low because a next request is made only after the previous one finishes.
- The stats for "_throughput_" show the results of when all 10 requests are made concurrently as a burst, at the same time. It will show the throughput (request per second) and the associated concurrency.
- The stats for "_constant@ 0.XX_" show the results for varying the request per second rates and the associated concurrency.



3. Check GPU stats as the test progress (in the nvidia terminal session)

If not already running, run the nvidia-smi with watch utility so it refreshes every 3 seconds. (refer to performance tools section)

In the output, "Processes" shows only one GPU with id "0" is in use. This is because we are using ilab model-serving with 1 GPU.

Observe the metrics for GPUs "0" and "1" - "Processes", "GPU-Util", "Temp", "Pwr:Usage" as the change during the tests.
