#docker build -t flask-local-build --build-arg GIT_COMMIT=$(git log -1 --format=%h) .
docker build -t strausmann/minecraft-bedrock-connect . --build-arg BRC_VERSION=1.16 --label "org.opencontainers.image.revision=$(git rev-parse --short HEAD)" --label "org.opencontainers.image.created=$(date -I)"