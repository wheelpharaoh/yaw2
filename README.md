# yaw
yet another webserver

## patterns
- [X] Hello World app
- [X] Releasable artifact
- [-] Hosting Infrastructure
- [X] release process codified
- [X] Automated Release process
- [/] Multi-zone/region

## Installation

### prereq
docker, python 3.11, pip, terragrunt, terraform, nektos/act (optional)
github token

## Build
```sh
cd hello-app
pip install -r requirements
python -m build
```

## Deploy
```sh
# cd infra/live/cloud/aws/yaw-eng-act/us-west-1/dev/yaw-svc && terragrunt apply
cd hello-app
pip install .
yaw start &
```

## Usage

```sh
curl localhost:8000
# Hello World
```

## CICD

### github actions
```sh
act -s GITHUB_TOKEN=$GITHUB_TOKEN \
-P self-hosted=catthehacker/ubuntu:act-22.04 \
--container-architecture linux/amd64 \
pull_request
```
