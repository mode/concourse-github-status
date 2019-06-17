# Mode's concourse-github-status

The upstream's Dockerfile and gemspec rely on pushing the gem to Rubygems. In order to get around this, we use our own Dockerfile and gemspec.

## Development

### Build the Docker Image

```bash
# be at the root of the repo
cd concourse-github-status/

# build the docker image
docker build . -f mode_build/Dockerfile -t concourse-github-status-resource:${concourse_version}-mode${resource_version}
```

Example tags:
 - `concourse-github-status-resource:4.0.0-mode-jasondev`
 - `concourse-github-status-resource:4.0.0-mode1`

### Push the Docker Image

The docker image is hosted at: `modeanalytics/concourse-github-status-resource` (dockerhub)

```bash
docker tag concourse-github-status-resource:4.0.0-mode1 modeanalytics/concourse-github-status-resource:4.0.0-mode1

docker push modeanalytics/concourse-github-status-resource:4.0.0-mode1
```
