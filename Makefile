PROJECT ?= corda-bootstrapper
TAG ?= local
DOCKER_REPO ?= sbir3japan

build:
	docker build -t ${DOCKER_REPO}/${PROJECT}:${TAG} .

run:
	docker compose -f docker-compose.yaml up -d

publish: build
	docker push ${DOCKER_REPO}/${PROJECT}:${TAG}
