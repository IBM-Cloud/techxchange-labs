## Initialize ilab

Initialize ilab using the **`ilab config init`** command


``` shell
# ls -asl
total 8
4 drwxr-xr-x. 2 root root 4096 Sep 19 20:05 .
4 drwxr-xr-x. 8 root root 4096 Sep 19 20:04 ..
```

``` shell
# ilab config init
```

``` shell
Welcome to InstructLab CLI. This guide will help you to setup your environment.
Please provide the following values to initiate the environment [press Enter for defaults]:
Cloning https://github.com/instructlab/taxonomy.git...
Generating `/mnt/djblock/demo/.config/instructlab/config.yaml`...
Please choose a train profile to use:
[0] No profile (CPU-only)
[1] A100_H100_x2.yaml
[2] A100_H100_x4.yaml
[3] A100_H100_x8.yaml
[4] L40_x4.yaml
[5] L40_x8.yaml
[6] L4_x8.yaml
Enter the number of your choice [hit enter for the default CPU-only profile] [0]: 0
Using default CPU-only train profile.
Initialization completed successfully, you're ready to start using `ilab`. Enjoy!
```

After the init, you should be able to see the following directories (.cache, .config, .local)

``` shell
# ls -asl
total 20
4 drwxr-xr-x. 5 root root 4096 Sep 19 20:24 .
4 drwxr-xr-x. 8 root root 4096 Sep 19 20:04 ..
4 drwxr-xr-x. 3 root root 4096 Sep 19 20:24 .cache
4 drwxr-xr-x. 3 root root 4096 Sep 19 20:24 .config
4 drwxr-xr-x. 3 root root 4096 Sep 19 20:24 .local
```

Go into those directories and see the contents.