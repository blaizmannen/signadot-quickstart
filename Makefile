# Makefile for managing Kind Kubernetes cluster

KIND_CLUSTER_NAME = signadot-quickstart
KIND_CONFIG_FILE = kind-config.yaml

.PHONY: up down

up:
	# Kind cluster
	kind create cluster --name $(KIND_CLUSTER_NAME) --config $(KIND_CONFIG_FILE) | true
	# Istio
	istioctl operator init
	istioctl install -y
	kubectl label namespace default istio-injection=enabled | true
	# Addons
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/grafana.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/prometheus.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/kiali.yaml
	helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
	helm install -n kube-system metrics-server metrics-server/metrics-server --set args={--kubelet-insecure-tls} | true

signadot:
	# Signadot
	kubectl create ns signadot | true
	kubectl -n signadot delete secret cluster-agent | true
	kubectl -n signadot create secret generic cluster-agent --from-file=token=./token.txt | true
	helm repo add signadot https://charts.signadot.com
	helm install signadot-operator signadot/operator --set istio.enabled=true --wait --timeout 300s | true
	# Hotrod (test app)
	kubectl create ns hotrod | true
	kubectl label namespace hotrod istio-injection=enabled | true
	kubectl -n hotrod apply -k 'https://github.com/signadot/hotrod/k8s/overlays/prod/istio'
	# Sandbox
	signadot sandbox apply -f ./negative-eta-fix.yaml --set cluster=$(KIND_CLUSTER_NAME)

down:
	@kind delete cluster --name $(KIND_CLUSTER_NAME)

down_all:
	@kind get clusters | xargs -I {} kind delete cluster --name {}

ls:
	@kind get clusters

context:
	@kubectl config current-context

