## Create Taxonomy


InstructLab uses a synthetic data-based alignment tuning method for Large Language Models which is driven by taxonomies. Taxonomies are manually created and contain the data that is used for alignment tuning of the model.


See https://github.com/instructlab/taxonomy for more information on taxonomies.


During initialization, taxonomy from https://github.com/instructlab/taxonomy.git will be cloned into `/root/.local/share/instructlab/taxonomy/` directory.


### Look into the structure of the taxonomy directory 

``` shell
# pwd
/root/.local/share/instructlab
```
``` shell
# ls -al taxonomy/
total 108
...
drwxr-xr-x. 13 root root  4096 Oct 10 13:17 compositional_skills
drwxr-xr-x.  4 root root  4096 Oct 10 13:17 docs
drwxr-xr-x.  3 root root    23 Oct 10 13:17 foundational_skills
drwxr-xr-x. 13 root root  4096 Oct 10 13:17 knowledge
...
```

### List the files that are new / changed from the taxonomy-base

``` shell
# ilab taxonomy diff
compositional_skills/grounded/linguistics/inclusion/qna.yaml
compositional_skills/grounded/linguistics/writing/rewriting/qna.yaml
compositional_skills/linguistics/synonyms/qna.yaml
knowledge/science/animals/birds/black_capped_chickadee/qna.yaml
```