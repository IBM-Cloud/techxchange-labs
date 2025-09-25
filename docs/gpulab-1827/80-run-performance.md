## Run performance benchmarks 

For the benchmarks, let us use [GuideLLM](https://github.com/vllm-project/guidellm) which is a tool specifically designed for benchmarking and evaluating large language model (LLM) deployments.

Some of the key metrics that we should look at are throughput, latency, and resource utilization.

For the performance benchmarks, some of the parameters that will be interesting to consider:

* Number of GPUs used to host the model
* The sizeof the model (number of parameters of the model)
* The number of input output tokens

### Performance run 1

* Use the `ibm-granite/granite-3.3-8b-instruct` model
* Input tokens = 512, Output tokens=256
* Use 2 GPUs

1. Serve the model 

``` bash
ilab model serve --model-path /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct  --backend vllm --gpus 2 -- --disable-custom-all-reduce --enforce-eager
```

2. Run guidellm


``` bash
guidellm benchmark --target "http://127.0.0.1:8000" --rate-type synchronous --max-requests 10  --data "prompt_tokens=512,output_tokens=256"
```

**Output:**


``` bash
(guide-llm) [root@txc-gpulab-group1-vsi ~]#  guidellm benchmark --target "http://127.0.0.1:8000" --rate-type synchronous --max-requests 10  --data "prompt_tokens=512,output_tokens=256"
Creating backend...
Backend openai_http connected to http://127.0.0.1:8000 for model /root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct.
Creating request loader...
Created loader with 1000 unique requests from prompt_tokens=512,output_tokens=256.


╭─ Benchmarks ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ [17:39:49] ⠋ 100% synchronous (complete)   Req:    0.2 req/s,    4.09s Lat,     1.0 Conc,      10 Comp,        0 Inc,        0 Err                   │
│                                            Tok:   62.6 gen/s,  312.8 tot/s,  58.7ms TTFT,   15.8ms ITL,   512 Prompt,      256 Gen                   │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
Generating... ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ (1/1) [ 0:00:41 < 0:00:00 ]


Benchmarks Metadata:
    Run id:fac6fb88-7fd6-4448-811a-1cd7e0bdbc99
    Duration:41.0 seconds
    Profile:type=synchronous, strategies=['synchronous']
    Args:max_number=10, max_duration=None, warmup_number=None, warmup_duration=None, cooldown_number=None, cooldown_duration=None
    Worker:type_='generative_requests_worker' backend_type='openai_http' backend_target='http://127.0.0.1:8000'
    backend_model='/root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct' backend_info={'max_output_tokens': 16384, 'timeout': 300,
    'http2': True, 'authorization': False, 'organization': None, 'project': None, 'text_completions_path': '/v1/completions', 'chat_completions_path':
    '/v1/chat/completions'}
    Request Loader:type_='generative_request_loader' data='prompt_tokens=512,output_tokens=256' data_args=None
    processor='/root/.cache/instructlab/models/ibm-granite/granite-3.3-8b-instruct' processor_args=None
    Extras:None


Benchmarks Info:
======================================================================================================================================================
Metadata                                    |||| Requests Made  ||| Prompt Tok/Req  ||| Output Tok/Req  ||| Prompt Tok Total  ||| Output Tok Total  ||
  Benchmark| Start Time| End Time| Duration (s)|  Comp|  Inc|  Err|   Comp|  Inc|  Err|   Comp|  Inc|  Err|   Comp|   Inc|   Err|   Comp|   Inc|   Err
-----------|-----------|---------|-------------|------|-----|-----|-------|-----|-----|-------|-----|-----|-------|------|------|-------|------|------
synchronous|   17:39:49| 17:40:30|         40.9|    10|    0|    0|  512.2|  0.0|  0.0|  256.0|  0.0|  0.0|   5122|     0|     0|   2560|     0|     0
======================================================================================================================================================


Benchmarks Stats:
==============================================================================================================================================
Metadata   | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)||| TTFT (ms)       ||| ITL (ms)        ||| TPOT (ms)       ||
  Benchmark| Per Second| Concurrency|        mean|        mean| mean| median|  p99| mean| median|  p99| mean| median|  p99| mean| median|  p99
-----------|-----------|------------|------------|------------|-----|-------|-----|-----|-------|-----|-----|-------|-----|-----|-------|-----
synchronous|       0.24|        1.00|        62.6|       312.8| 4.09|   4.09| 4.10| 58.7|   57.8| 61.8| 15.8|   15.8| 15.8| 15.7|   15.7| 15.8
==============================================================================================================================================

Saving benchmarks report...
Benchmarks report saved to /var/roothome/benchmarks.json
```