# Introduction to Fluentd on Kubernetes

## We need a Kubernetes cluster

Lets create a Kubernetes cluster to play with using [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

```
cd fluentd\kubernetes\

kind create cluster --name fluentd --image kindest/node:v1.23.6 --config kind.yaml
```

## Fluentd Manifests

I would highly recommend to use manifests from the official fluentd [github repo](https://github.com/fluent/fluentd-kubernetes-daemonset) for production usage <br/>

The manifests in this repo are broken down and simplified for educational purpose. </br>
<br/>

## Fluentd Docker

I would recommend to start with the official [fluentd](https://hub.docker.com/r/fluent/fluentd-kubernetes-daemonset)
docker image. Specifically image tag `fluent/fluentd-kubernetes-daemonset:v1.16-debian-elasticsearch8-1`<br/>

You may want to build your own image if you want to install plugins.

In this demo I will be using the `fluentd` elasticsearch plugin <br/>
It's pretty simple to adjust `fluentd` to send logs to any other destination in case you are not an `elasticsearch` user. <br/>

<br/>

## Fluentd Namespace

Let's create a `fluentd` namespace: <br/>

```
kubectl create ns fluentd

```

## Fluentd Configmap

We have 5 files in our `fluentd-configmap.yaml` :

- fluent.conf: Our main config which includes all other configurations
- pods-kind-fluent.conf: `tail` config that sources all pod logs on the `kind` cluster.
  Note: `kind` cluster writes its log in a different format
- pods-fluent.conf: `tail` config that sources all pod logs on the `kubernetes` host in the cloud. <br/>
  Note: When running K8s in the cloud, logs may go into JSON format.
- file-fluent.conf: `match` config to capture all logs and write it to file for testing log collection </br>
  Note: This is great to test if collection of logs works
- elastic-fluent.conf: `match` config that captures all logs and sends it to `elasticseach`

Let's deploy our `configmap`:

```
kubectl apply -f .\fluentd\kubernetes\fluentd-configmap.yaml

```

## Fluentd Daemonset

Let's deploy our `daemonset`:

```
kubectl apply -f .\fluentd\kubernetes\fluentd-rbac.yaml
kubectl apply -f .\fluentd\kubernetes\fluentd.yaml
kubectl -n fluentd get pods

```

Let's deploy our example app that writes logs to `stdout`

```
kubectl apply -f .\fluentd\kubernetes\counter.yaml
kubectl apply -f .\fluentd\kubernetes\counter-err.yaml
kubectl get pods
```

To view container logs in `/var/log/containers/`:

```
kubectl -n fluentd exec -it <fluentd-container-id> bash
```

## Demo ElasticSearch and Kibana

```
kubectl create ns elastic-kibana

# deploy elastic search
kubectl -n elastic-kibana apply -f .\fluentd\kubernetes\elastic\elastic-demo.yaml
kubectl -n elastic-kibana get pods

# deploy kibana
kubectl -n elastic-kibana apply -f .\fluentd\kubernetes\elastic\kibana-demo.yaml
kubectl -n elastic-kibana get pods
```

## Kibana

```
kubectl -n elastic-kibana port-forward svc/kibana 5601
```

# Clean up

```
kind delete cluster --name fluentd
```
