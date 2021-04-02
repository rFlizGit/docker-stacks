This next section is an example of a first-time deployment of a customized Jupyter Lab Image. This example extends AWS' "datascience-notebook" by adding the "Templates" Jupyter Extension.

First we clone the **docker-stacks** repo from driftbio Github.

	git clone https://github.com/driftbio/docker-stacks.git

In order to create a new, customized Jupyter-lab image we switch to a separate repo branch called *add_features_to_notebook* by running:

	git checkout -b add_features_to_notebook origin/add_features_to_notebook
	
doing this will ensure that images are tagged with the correct branch name for easy tracking of their purpose and origin.

Next step is to create a directory and name it whatever we want our customized Jupyter-lab image to be named. In this case we'll be creating a Jupyter-lab image named "unicorn". 

Right after, we create a Dockerfile inside this new directory.

	mkdir unicorn 
	cd unicorn 
	touch Dockerfile 

In this case, we'll be inheriting settings from the AWS' "datascience-notebook" base image. This is how our dockerfile looks like.

	ARG BASE_CONTAINER=925388419436.dkr.ecr.us-west-1.amazonaws.com/datascience-notebook

	FROM $BASE_CONTAINER

	USER $NB_UID

	RUN pip install jupyterlab_templates && \

	jupyter labextension install jupyterlab_templates && \

	jupyter serverextension enable --py jupyterlab_templates

	WORKDIR $HOME


We specify our template notebook by setting setting a **BASE_CONTAINER** variable and assigning amazon aws's "datascience-notebook" URL to it. We then reference that variable as an argument to docker's **FROM** command.

For this example we added the jupyter-lab "Templates" extension by running a sequence of shell commands that install the extension.

<br>

Once this is done we can deploy a container to test the docker image locally by running:

	make build TARGET=unicorn

Once we're happy and ready to push to Drift's ECR we run: 

	make push TARGET=unicorn
	
We should now be able to make our way to Drift's ECR and fetch the docker image URL.  It will look something like this:

	"925388419436.dkr.ecr.us-west-1.amazonaws.com/unicorn:add_features_to_notebook-6381460"

Next, we clone  the repo named **EKS-config** from driftbio's Github 
Once we have it, we navigate to *eks-config/releases/jhub-dev.yaml*

For Jupyter Image configuration purposes we are only concerned with the section under the **profileList** key. 
Here we can add our new modified image by entering:


	display_name: "Unicorn Notebook"
        	description: "by popular demand"
        	kubespawner_override:
            	image: 925388419436.dkr.ecr.us-west-1.amazonaws.com/unicorn:add_features_to_notebook-6381460

				volumes:
              		- name: efs-shared
                		persistentVolumeClaim: 
                  			claimName: efs-storage-claim
            	volume_mounts:
              		- name: efs-shared
                		mountPath: /home/jovyan/efs-shared


the URL specified in the **image** key is the url we got earlier from pushing our dockerfile to drift's ECR.

It is **Important** to know that eks-config refreshes every 2 minutes.  Make sure  that this procedure is done correctly, otherwise, stuff will start to break.
