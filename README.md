# github-self-hosted-runner
## Github Self Hosted Runner Deployment with Dockerfile and Helm Chart for Kubernetes

### Create Image

To create the image with tag 1

Edit Dockerfile and buid.sh file

In Dockerfile, these variables are important. 
The other variables are comming from Kubernetes environment variables.


> ENV RUNNER_VERSION=2.321.0
> ENV DOCKER_GROUP_ID=999

```
bash build.sh 1

```

### Deploy

Edit chart/values.yaml , values-runner-1.yaml and run.sh files

"values-runner-1.yaml" is override "chart/values.yaml"

If you want to create second runner, copy "values-runner-1.yaml" to "values-runner-2.yaml" and edit "values-runner-2.yaml"
Then add "helm  upgrade --install -n github-runner -f values-runner-2.yaml  runner-2 ./chart" to "run.sh"

```
bash run.sh

```





