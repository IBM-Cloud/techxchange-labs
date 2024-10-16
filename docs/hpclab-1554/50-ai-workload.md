# Run AI workload on GPUs

This section will demonstrate the submission of a job that requires a GPU. GPUs offer a significant outperformance for specific computational tasks, e.g. to fine tune an AI model or to inference a large amount of data using an AI model or other non-AI related tasks.

IBM Cloud offers a range of [GPU profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui#gpu). IBM Cloud HPC with Spectrum LSF scheduling technology supports automatic detection of GPUs on compute nodes and allows the user to specify the GPU resource requirement during job submission, see [Enabling GPU features](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=resources-enabling-gpu-features).

In this tutorial the Spectrum LSF scheduler has been configured to use a `gx2-8x64x1v100` profile which has 8 regular CPUs, 64 GB memory and contains one NVIDIA v100 Tesla GPU. 

The example workload performs a matrix multiplication using [PyTorch](https://pytorch.org/), a very popular machine learning library for python. The program runs on both, CPU and GPU. When the program detects that a GPU is configured it uses the NVIDIA Cuda library to accelerate the processing. The example is multiplying a 4.000 x 4.000 matrix for 10.000 times.


```python
### with GPU
if torch.cuda.is_available():
  print("GPU enabled.")
  matrix = torch.ones(4000,4000).cuda()
else: ### with CPU
  print('No GPU enabled.')
  matrix = torch.ones(4000,4000)

for _ in range(10000):
  matrix *= matrix
```

Note: In order to safe time for the lab, the GPU machine has been provisioned by the administrator with a `bsub sleep <some hours>` prior to the lab. In real world setups, the GPU machines would be dynamically provisioned like any other machine profile.

### Steps

1. Checkout the Nvidia Tesla v100 GPU in the IBM Cloud UI under [Virtual server instances for VPC](https://cloud.ibm.com/infrastructure/compute/vs). 
   ![](./images/50-gpu-profile.png ':size=600')
2. Make sure your Cloud Shell session is active, if not, follow the [steps](20-explore?id=login-to-the-hpc-environment) 
3. Like before, we placed the script and program on the binaries directory.
   ```
   cat /mnt/binaries/gpu_or_cpu.sh
   ```
4. Review the python program itself
   ```
   cat /mnt/binaries/matrix_multiplication.py
   ```
5. List the available GPU hosts in the cluster and their details. LSF has automatically detected the GPU and collects metrics like capacity, utilization, temperature,...
   ```
   bhosts -gpu -l
   ```
   ![](./images/50-bhosts-gpu.png ':size=600')
6. Let's first submit the job **without** GPU resource requirement
   ```
   bsub -Is /mnt/binaries/gpu_or_cpu.sh
   ```
   ![](./images/50-cpu-run.png ':size=600')
7. Now, submit the job and **enable the GPU** (`-gpu`). We can also specify the number of GPUs needed (`num=1`).
   ```
   bsub -Is -gpu num=1 /mnt/binaries/gpu_or_cpu.sh
   ```
   ![](./images/50-gpu-run.png ':size=600')
8. Notice, that the execution was much faster since it detected and enabled the GPU for this job.
9. Remember the job ID of the previous run and checkout the details of the job using the `-gpu` flag
   ```
   bjobs -l -gpu 1986
   ```
   ![](./images/50-bjobs-gpu.png ':size=600')
10. In addition, the `lsload` command also supports special reporting on GPU resources:
   ```
   lsload -gpu -w
   ```
   ![](./images/50-lsload-gpu.png ':size=600')



?> **Congratulations!** You have submitted a job that run on a GPU. Spectrum LSF automatically detected and selected the proper machine profile for the task based on the users resource requirements. All the advanced scheduling configurations like quota, queues, multiple users, and various machine profiles can be applied to GPUs as well.