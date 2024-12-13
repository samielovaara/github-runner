### Self hosted github runner project

## Creating runner with bash

```
git clone git@github.com:tuomascode/GithubRunner.git
cd GithubRunner
docker build -t githubrunner .
```

* Log into your github, navigate to your repository and get runner-token from settings

set 

developement command:
```
docker run -v $(pwd):/temp --workdir /temp --entrypoint bash -it --rm  \
  -e GITHUB_PAT=$GITHUB_PAT \
  -e GITHUB_PROJECT=$GITHUB_PROJECT \
  -e GITHUB_PROJECT_OWNER=$GITHUB_PROJECT_OWNER \
  githubrunner
```

runtime command 
```
docker run -d \
  -e GITHUB_PAT=$GITHUB_PAT \
  -e GITHUB_PROJECT=$GITHUB_PROJECT \
  -e GITHUB_PROJECT_OWNER=$GITHUB_PROJECT_OWNER \
  githubrunner
```

```
bash runner.sh build \
  -n $GITHUB_PROJECT \
  -o $GITHUB_PROJECT_OWNER \
  -g $GITHUB_PAT
```

```
bash runner.sh start -n $GITHUB_PROJECT
```

```
bash runner.sh stop -n $GITHUB_PROJECT
```

```
docker build \
  --build-arg GITHUB_RUNNER_TOKEN="your_github_token" \
  --build-arg REPO_URL="https://github.com/your/repository" \
  -t github-runner:latest .
```