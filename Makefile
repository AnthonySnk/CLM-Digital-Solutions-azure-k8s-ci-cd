# ROOT_DIR = $(shell pwd)
# PUBLIC_IP = $(curl ifconfig.me)

.SILENT: help test-app build-image test-compose-locally down-compose terraform deploy_k8s_aws test-hpa destroy_k8s_aws

default: help

test-app:
	npm install
	npm run test

build-image:
	docker build -t daveti/node-app:latest -f Dockerfile .
	docker push daveti/node-app:latest

test-compose-locally:
	docker-compose up -d &&\
	printf "Dirigirse a las URLs http://localhost:3000 y http://localhost/private para testear los puertos 80 y 3000 \n"

down-compose:
	docker-compose down

terraform:
	cd k8s && cd terraform &&\
	terraform init &&\
	terraform plan &&\
	terraform apply -auto-approve
	cd ..

deploy_k8s_aws:
	cd k8s && kubectl apply -f . -n node-nginx

test-hpa:
	kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://app-node-svc:3000; done"

destroy:
	cd k8s && kubectl delete -f .

help:
	printf "\n==========================================================\n\
	make test-app - Execute test from NodeJS API\n\
	make build-image - Build image NodeJS API\n\
	make test-compose-locally - Execute docker-compose locally\n\
	make down-compose - Delete execution docker-compose\n\
	make terraform - Create a role and namespace from terraform\n\
	make deploy_k8s_aws - Deploy manifests to service, deployment and hpa\n\
	make test-hpa - Test autoscaling\n\
	make destroy_k8s_aws - Destroy all resources built\n\
	make help - shows this message\n\n"