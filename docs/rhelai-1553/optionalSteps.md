## Optional steps

You can see the taxonomy, the created synthetic data and the model created fromt he data.


### Attach the nfs file storage to the deployed VM

```
cd /mnt
mkdir fsys
```

``` shell
mount  -t nfs4 -o ro,sec=sys,nfsvers=4.1 fsf-tor0451a-byok-fz.adn.networklayer.com:/70ed587a_b2dc_4e82_8528_b9bc18f5d751 /mnt/fsys
```

### Look into the taxonomy

``` shell
cd /mnt/fsys/taxonomy
```

The `taxonomy` directory will have the user's taxonomy.
The `generated_data` will have the synthetic data that was generated for the above taxonomy.


### Look into the created model 

``` shell
cd /mnt/fsys/models/fsmodel
```

You will be ale to see the model created. You can download this model and use the previous steps to serve and chat with the model
