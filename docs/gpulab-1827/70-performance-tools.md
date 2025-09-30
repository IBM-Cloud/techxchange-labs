
## Use performance tools with the deployed LLM

### 1. Get into the virtual environment that has the performance tools installed

``` bash
perfenv
```

**Output:**

``` bash
[root@txc-gpulab-group1-vsi ~]# perfenv
(guide-llm) [root@txc-gpulab-group1-vsi ~]#
```
<p>&nbsp;</p>

### 2. Test to make sure you are within the virtual environment

``` bash
echo $VIRTUAL_ENV
```
**Output:**

``` bash
/var/roothome/guide-llm
```
<p>&nbsp;</p>

### 3. Test if you can access `guidellm`

[GuideLLM](https://github.com/vllm-project/guidellm) is a platform specifically designed for benchmarking and evaluating large language model (LLM) deployments. We will be using `guidellm` in this lab.

Check if you can run the `guidellm` tool.


``` bash
guidellm --help
```
**Output:**

``` bash
Usage: guidellm [OPTIONS] COMMAND [ARGS]...

Options:
  --help  Show this message and exit.

Commands:
  benchmark  Run a benchmark against a generative model using the...
  config     Print out the available configuration settings that can be...
(guide-llm) [root@txc-gpulab-group1-vsi ~]#
```
<p>&nbsp;</p>


Run a quick benckmark test against the served model to get familiarize with the tool's input and output.

```
guidellm benchmark --target "http://127.0.0.1:8000" --rate-type synchronous --max-requests 5  --data "prompt_tokens=512,output_tokens=256"
```

A complete description of the configurations for running benchmaks can be found [here](https://github.com/vllm-project/guidellm/blob/59c1be87a82c44bc3c53263ea658b96e29f4e668/README.md#configurations).

**Output:**

```
Benchmarks Stats:
==============================================================================================================================================
Metadata   | Request Stats         || Out Tok/sec| Tot Tok/sec| Req Latency (ms)||| TTFT (ms)       ||| ITL (ms)        ||| TPOT (ms)       ||
  Benchmark| Per Second| Concurrency|        mean|        mean| mean| median|  p99| mean| median|  p99| mean| median|  p99| mean| median|  p99
-----------|-----------|------------|------------|------------|-----|-------|-----|-----|-------|-----|-----|-------|-----|-----|-------|-----
synchronous|       0.15|        1.00|        39.5|       197.4| 6.48|   6.48| 6.49| 53.5|   51.0| 58.3| 25.2|   25.2| 25.2| 25.1|   25.1| 25.1
==============================================================================================================================================
 ```

To evaluate the results, some of the key metrics to look at are throughput and latency.

A complete list of metrics can be found [here](https://github.com/vllm-project/guidellm/blob/main/docs/metrics.md).

***Request Rate (Requests Per Second)***
- Definition: The number of requests processed per second.
- Indicates the throughput of the system and its ability to handle concurrent workloads.

***Request Latency***
- Definition: The time taken to process a single request, from start to finish.
- A critical metric for evaluating the responsiveness of the system.

***Time to First Token (TTFT)***
- Definition: The time taken to generate the first token of the output.
- Indicates the initial response time of the model, which is crucial for user-facing applications.


When evaluating and comparing performance benckmarks, it is important to know the parameters (underlying GPU resources, model, type of requests etc). For example the above benchmark was run with these parameters:

| **Parameters**      ||
|------------------|--------------------------------------------------|
| Server           | gx3-48x240x2l40s                                 |
| vCPUs, Memory    | 48, 240 GiB                                      |
| GPUs Available   | 2 x L40S                                       |
| GPUs Used        | 1                                                |
| Model Name       | ibm-granite/granite-3.3-8b-instruct              |
| Model Parameters | 8 billion                                        |
| Request Type     | 5 synchronous requests                           |
| Input Tokens     | 512                                              |
| Output Tokens    | 256                                              |

In subsequent steps we will run performance benchmarks with different parameters, and then evaluate and compare results.



### 4. Test if you can access `nvidia-smi`

The NVIDIA System Management Interface (**nvidia-smi**) tool is used to monitor and manage NVIDIA GPUs. In our benchmark tests it will provide real-time data on metrics like GPU utilization, memory usage, and temperature.


* Open another terminal window and run nvidia-smi command

``` bash
nvidia-smi
```

**Output:**

``` bash
Wed Aug 27 17:23:22 2025
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.163.01             Driver Version: 550.163.01     CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA L40S                    On  |   00000000:04:01.0 Off |                    0 |
| N/A   43C    P0             83W /  350W |   41113MiB /  46068MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
|   1  NVIDIA L40S                    On  |   00000000:04:02.0 Off |                    0 |
| N/A   41C    P0             82W /  350W |   41111MiB /  46068MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A     21376      C   /opt/app-root/bin/python3.11                41090MiB |
+-----------------------------------------------------------------------------------------+
```


The above output confirms we have a server with two GPUs with id "0" and "1".

"Processes" shows only one GPU with id "0" is in use. This is because we started `ilab` model-serving with 1 GPU.

Observe the metrics for GPUs "0" and "1" - "Processes", "GPU-Util", "Temp", "Pwr:Usage".

The metrics will change during the tests. Run the nvidia-smi tool with watch utility so that its stays on and the output automatically refreshes every 3 seconds.

```
watch -n 3 nvidia-smi

```

### 5. Prepare for running benchmark tests

At this point you should have 3 terminal sessions open that will be used for the benchmark tests.

- ***Terminal session 1***: For model-serving, using ilab.
- ***Terminal session 2***: For performance benchmarks tests, using guidellm and evaluating results.
- ***Terminal session 3***: For observing GPU stats during tests, using nvidia-smi.


