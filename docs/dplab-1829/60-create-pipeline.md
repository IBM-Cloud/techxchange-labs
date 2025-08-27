## Step 6: Create the pipeline
The workbench you see will be used to construct an AI pipeline with existing assets in a git repo configured to run deepeval test cases against the model deployed in the local Red Hat OpenShift AI cluster.
1. From the left menu, find the **git (A)** icon and **Clone a Repository (B)**, specifically the `pipeline-deepeval` repo which has the Jupyter and python resources to build the pipeline.
    * **Git repo**: `https://github.com/acmthinks/pipeline-deepeval`

    ![image](images/dp-workbench-git.png)

2. From the **Launcher** window, click **Pipeline Editor** under the Elyra section. This will launch another tab with a blank pipeline canvas.

3. Rename your pipeline from `untitled.pipeline` to `deepeval-evaluation.pipeline`

4. From the **Pipeline Component** menu, drag and drop a **Notebook (A)** node on to the pipeline canvas.

    ![image](images/dp-pipeline-notebook-node.png)

5. Select the new node on the canvas, and open the node properties **Panel (A)**

    ![image](images/dp-pipeline-node-properties.png)

6. Toggle to the **Node Properties (A)** tab.

    ![image](images/dp-pipeline-notebook-properties-tab.png)

7. click the **Browse (B)** button from the **Input** section to select the Jupyter notebook `deepeval-correctness-evaluations.ipynb` **(C)** cloned from the git repo. In the **Runtime Image** field, select `Python 3.11 (UBI9)`.
In the **File Dependencies** field, click the **Browse** button and select the corresponding python (`.py`) file. The Node Properties should reflect 4 changes:
    * **Label (A):** `"Correctness" evaluations`
    * **Filename (B):** `pipeline-deepeval/deepeval-correctness-evaluations.ipynb`
    * **Runtime Image (C):** `Python 3.11 (UBI9)`
    * **File Dependencies (D):** `test_correctness.py`

    ![image](images/dp-pipeline-node-properties-final.png)
  > Leave all other properties at their default

8. Close the properties Panel. (Node Properties save, automatically)

9. In the pipeline canvas, **Add Comment (A)** to describe the notebook node.

    * **Comment (A)**: `Setup deepeval packages and run "Correction" tests against model`

    ![image](images/dp-pipeline-notebook-node-comment.png)

10. On the pipeline canvas, draw a line to connect the comment to the `"Correctness" evaluations` notebook node.

11. Repeat tasks 4 through 9 to create another notebook node `"Hallucination" evaluations` with a comment on the canvas.

12. Connect the 2 nodes together on the pipeline canvas. The pipeline should look similar to the picture below.

    ![image](images/dp-pipeline-final.png)

13. Click the **Save Pipeline** icon (diskette) on the pipeline editor toolbar.
