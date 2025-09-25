
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

### 4. Test if you can access `nvidia-smi`

``` bash
nvidia-smi
```

**Output:**

``` bash
(guide-llm) [root@txc-gpulab-group1-vsi ~]# nvidia-smi
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
|    1   N/A  N/A     21398      C   /opt/app-root/bin/python3.11                41088MiB |
+-----------------------------------------------------------------------------------------+
(guide-llm) [root@txc-gpulab-group1-vsi ~]#
```