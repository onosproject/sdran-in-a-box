# RiaB Logging and Monitoring

This tutorial explains how to run RiaB with logging and monitoring enabled.

For logging, RiaB enables the collection of logs using fluent-bit, storage in elasticsearch DB, and presentation of metrics in grafana (kibana can also be used). Logs are collected from all pods in the RiaB k8s cluster.
For monitoring, RiaB enables a colletions of pods and node metrics using prometheus exporters and grafana.

## Enabling logging/monitoring in the sdran-in-a-box-values yaml file

To enable logging/monitoring in RiaB, in the sdran-in-a-box-values.yaml (**available for the latest version**) file remove the comments of the lines below:

```yaml
# Monitoring/Logging
  fluent-bit:
    enabled: true
  opendistro-es:
    enabled: true
  prometheus-stack:
    enabled: true
```

## Accessing grafana and looking for logs and metrics

After modified the values file, then run the make command to instantiate RiaB.
After deployed, the services and pods related to logging and monitoring will be shown as:

```bash
$ kubectl -n riab get svc
... 
alertmanager-operated                     ClusterIP   None              <none>        9093/TCP,9094/TCP,9094/UDP            90s
prometheus-operated                       ClusterIP   None              <none>        9090/TCP                              90s
sd-ran-fluent-bit                         ClusterIP   192.168.205.134   <none>        2020/TCP                              90s
sd-ran-grafana                            ClusterIP   192.168.209.213   <none>        80/TCP                                90s
sd-ran-kube-prometheus-sta-alertmanager   ClusterIP   192.168.166.174   <none>        9093/TCP                              90s
sd-ran-kube-prometheus-sta-operator       ClusterIP   192.168.152.79    <none>        443/TCP                               90s
sd-ran-kube-prometheus-sta-prometheus     ClusterIP   192.168.199.115   <none>        9090/TCP                              90s
sd-ran-kube-state-metrics                 ClusterIP   192.168.155.231   <none>        8080/TCP                              90s
sd-ran-opendistro-es-client-service       ClusterIP   192.168.183.47    <none>        9200/TCP,9300/TCP,9600/TCP,9650/TCP   90s
sd-ran-opendistro-es-data-svc             ClusterIP   None              <none>        9300/TCP,9200/TCP,9600/TCP,9650/TCP   90s
sd-ran-opendistro-es-discovery            ClusterIP   None              <none>        9300/TCP                              90s
sd-ran-opendistro-es-kibana-svc           ClusterIP   192.168.129.238   <none>        5601/TCP                              90s
sd-ran-prometheus-node-exporter           ClusterIP   192.168.137.224   <none>        9100/TCP                              90s
```

```bash
$ kubectl -n riab get pods
... 
alertmanager-sd-ran-kube-prometheus-sta-alertmanager-0   2/2     Running   0          43s
sd-ran-fluent-bit-x75mt                                  1/1     Running   0          43s
sd-ran-grafana-584fbb69cf-cvzcn                          2/2     Running   0          43s
sd-ran-kube-prometheus-sta-operator-5f47f669dd-xkm7k     1/1     Running   0          43s
sd-ran-kube-state-metrics-6f675bf9cf-kzkdc               1/1     Running   0          43s
sd-ran-opendistro-es-client-78649698c8-tfh47             1/1     Running   0          42s
sd-ran-opendistro-es-data-0                              1/1     Running   0          43s
sd-ran-opendistro-es-kibana-7cff67c748-vp4g8             1/1     Running   0          43s
sd-ran-opendistro-es-master-0                            1/1     Running   0          43s
sd-ran-prometheus-node-exporter-grt5k                    1/1     Running   0          43s
```

### Port forward grafana service

Make a port-forward rule to the grafana service on port 3000.

```bash
kubectl -n riab port-forward svc/sd-ran-grafana 3000:80
```

### Access the grafana dashboards

Open a browser and access `localhost:3000`. The credentials to access grafana are: `username: admin` and `password: prom-operator`.

To look at the grafana dashboard for the sdran component logs, check in the left menu of grafana the option dashboards and selec the submenu Manage (or just access in the browser the address `http://localhost:3000/dashboards`).

In the menu that shows, look for the dashboard named `Kubernetes / Logs / Pod`. It is possible to access this dashboard directly via the address `http://localhost:3000/d/e2QUYvPMk/kubernetes-logs-pod?orgId=1&refresh=10s`.

In the top menu, the dropdown menus allow the selection of the Namespace `riab` and one of its Pods. It is also possible to type a string to be found in the logs of a particular pod using the field String. 


Similarly, other dashboards can be found in the left menu of grafana, showing for instance each pod workload in the dashboad `Kubernetes / Compute Resources / Workload`.

## Accessing kibana and looking for logs

The helm chart repository used by sdran for the kibana and elasticsearch instantiation had its settings modified to disable security modules.
However to disable kibana security modules a different approach must be followed so it can be accessible via browser (see https://opendistro.github.io/for-elasticsearch-docs/docs/security/configuration/disable/).

The simples way to do that, is creating a new docker image for kibana. Thus, create a file named `Dockerfile` with the following content.

```dockerfile
FROM amazon/opendistro-for-elasticsearch-kibana:1.13.0
RUN /usr/share/kibana/bin/kibana-plugin remove opendistroSecurityKibana
```

Then in the folder where the Dockerfile is located run the following command.

```bash
docker build --tag=amazon/opendistro-for-elasticsearch-kibana-no-security:1.13.0 .
```


Add the following lines to the end of the file sdran-in-a-box-values.yaml.

```yaml
opendistro-es:
  kibana:
    image: amazon/opendistro-for-elasticsearch-kibana-no-security
    imagePullPolicy: IfNotPresent
```

Then execute RiaB make command and after finished, run the port-forward to the kibana service (as stated below) and access in the browser the address `localhost:5601`. The kibana portal will be accessible without login to browse the logs of the RiaB components.

```bash
kubectl -n riab port-forward svc/sd-ran-opendistro-es-kibana-svc 5601
```

## Cleaning
As logging and monitoring are enabled via the same sdran umbrella helm chart, when running the commands to reset the test and clean the environment, logging and monitoring k8s components will also be removed in RiaB.
