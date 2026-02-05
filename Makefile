# ----------------------------
# From Image to Cluster - Makefile
# ----------------------------
 
CLUSTER      := lab
IMAGE        := nginx-custom:1.0
PORT_LOCAL   := 8081
SERVICE_NAME := nginx-custom
 
.PHONY: help check setup cluster build import deploy run status clean stop
 
help:
	@echo "Targets:"
	@echo "  make setup     - Install tools (ansible, unzip, packer, k3d) (optional)"
	@echo "  make cluster   - Create k3d cluster ($(CLUSTER)) if needed"
	@echo "  make build     - Build Docker image with Packer ($(IMAGE))"
	@echo "  make import    - Import image into k3d cluster"
	@echo "  make deploy    - Deploy to Kubernetes via Ansible"
	@echo "  make run       - Port-forward service to localhost:$(PORT_LOCAL)"
	@echo "  make status    - Show pods and services"
	@echo "  make clean     - Delete k8s resources (nginx-custom only)"
	@echo "  make stop      - Stop port-forward on $(PORT_LOCAL)"
	@echo "  make all       - cluster + build + import + deploy + run"
 
check:
	@command -v docker >/dev/null || (echo "docker not found" && exit 1)
	@command -v kubectl >/dev/null || (echo "kubectl not found" && exit 1)
	@command -v k3d >/dev/null || (echo "k3d not found (run: make setup)" && exit 1)
	@command -v packer >/dev/null || (echo "packer not found (run: make setup)" && exit 1)
	@command -v ansible-playbook >/dev/null || (echo "ansible not found (run: make setup)" && exit 1)
	@test -f index.html || (echo "index.html not found at repo root" && exit 1)
	@echo "OK: prerequisites found"
 
setup:
	sudo apt-get update || true
	sudo apt-get install -y ansible unzip
    # k3d
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    # packer
	PACKER_VERSION="1.11.2"; \
	curl -fsSL "https://releases.hashicorp.com/packer/$${PACKER_VERSION}/packer_$${PACKER_VERSION}_linux_amd64.zip" -o /tmp/packer.zip && \
	sudo unzip -o /tmp/packer.zip -d /usr/local/bin
	@echo "Setup done"
 
cluster:
	@k3d cluster list | grep -q "^$(CLUSTER)\b" && echo "Cluster '$(CLUSTER)' already exists" || \
    k3d cluster create $(CLUSTER) --servers 1 --agents 2
 
build: check
	cd packer && packer init . && packer build .
 
import: check
	k3d image import $(IMAGE) -c $(CLUSTER)
 
deploy: check
	ansible-playbook ansible/deploy.yml
 
run:
	kubectl port-forward svc/$(SERVICE_NAME) $(PORT_LOCAL):80 >/tmp/$(SERVICE_NAME).log 2>&1 & \
	echo "Port-forward started on http://localhost:$(PORT_LOCAL)"
 
status:
	kubectl get pods,svc -o wide
 
clean:
	kubectl delete -f k8s/ --ignore-not-found=true

stop:
	@pkill -f "kubectl port-forward svc/$(SERVICE_NAME) $(PORT_LOCAL):80" && echo "Port-forward stopped" || echo "No port-forward found"
 
all: cluster build import deploy run
 
 