# github-runner
Containerised github runner

* clone repository from github
```
git clone git@github.com:samielovaara/github-runner.git
cd github-runner
```

* build docker image

```
docker build -t githubrunner .
```

* run actions runner in container

````
docker run -d \
  -e REPO=samielovaara/python-weather-app \
  -e ACCESS_TOKEN=$GITHUB_PAT \
  github-runner
````
