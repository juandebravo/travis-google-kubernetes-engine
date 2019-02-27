KEY_FILE:=gcloud-service-account-secret.json
PROJECT_ID:=singular-hash-228518
K8s_CLUSTER:=standard-cluster-1
ZONE:=us-west1-a

IMAGE_NAME:=travis-k8s-demo
IMAGE_VERSION:=v1

gauth:
	@gcloud auth activate-service-account --key-file ${KEY_FILE}

gconfig:
	@gcloud config set project $(PROJECT_ID)
	@gcloud container clusters \
		get-credentials $(K8s_CLUSTER) \
		--zone $(ZONE) \
		--project $(PROJECT_ID)
	@gcloud auth configure-docker

build:
	@docker build -t gcr.io/$(PROJECT_ID)/$(IMAGE_NAME):$(IMAGE_VERSION) .

run:
	@docker run -p 8000:8000 gcr.io/$(PROJECT_ID)/$(IMAGE_NAME):$(IMAGE_VERSION)

push:
	@docker push gcr.io/$(PROJECT_ID)/$(IMAGE_NAME):$(IMAGE_VERSION)

deploy: gconfig
	@kubectl apply -f k8s.yaml
# https://github.com/kubernetes/kubernetes/issues/27081#issuecomment-238078103
	@kubectl patch deployment $(IMAGE_NAME) -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
