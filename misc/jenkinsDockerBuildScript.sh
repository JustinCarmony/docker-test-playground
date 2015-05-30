export DOCKER_HOST="tcp://127.0.0.1:4243"

# Building the Dockerfile Image
BRANCH_SHORT_NAME=${GIT_BRANCH#*/}
docker build -t docker-test-app:$BRANCH_SHORT_NAME .

# Creating tag for remote registry
docker tag -f docker-test-app:$BRANCH_SHORT_NAME master:5000/docker-test-app:$BRANCH_SHORT_NAME

docker push master:5000/docker-test-app:$BRANCH_SHORT_NAME

sudo /usr/local/bin/saltevent 'docker-test/new-docker-image' '{overstate: refresh}'