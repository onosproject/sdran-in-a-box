<!--
SPDX-FileCopyrightText: 2019-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

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

Associated with the monitoring of sdran components is the [onos-exporter](https://github.com/onosproject/onos-exporter), the exporter for ONOS SD-RAN (µONOS Architecture) to scrape, format, and export onos KPIs to TSDB databases (e.g., Prometheus). Currently the implementation supports Prometheus.
In order to enable onos-exporter, as shown below, make sure the prometheus-stack is enabled too.

```yaml
  prometheus-stack:
    enabled: true
  onos-exporter:
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

# About the onos-exporter metrics

The onos-exporter scrapes the following KPIs from the onos components:

- onos-e2t:
  - onos_e2t_connections
    + Description: The number of e2t connections.
    + Value: float64.
    + Dimensions/Labels: connection_type, id, plmnid, remote_ip, remote_port.
    + Example: onos_e2t_connections{connection_type="G_NB",id="00000000003020f9:0",plmnid="1279014",remote_ip="192.168.84.46",remote_port="35823",sdran="e2t"} 1
- onos-e2sub:
  - onos_e2sub_subscriptions
    + Description: The number of e2sub subscriptions.
    + Value: float64.
    + Dimensions/Labels: appid, e2nodeid, id, lifecycle_status, revision, service_model_name, service_model_version.
    + Example: onos_e2sub_subscriptions{appid="onos-kpimon-v2",e2nodeid="00000000003020f9:0",id="2a0e7586-b8ac-11eb-b363-6f6e6f732d6b",lifecycle_status="ACTIVE",revision="17",sdran="e2sub",service_model_name="oran-e2sm-kpm",service_model_version="v2"} 1
- onos-kpimon-v2:
  - onos_xappkpimon_rrc_conn_avg
    + Description: RRCConnAvg the mean number of users in RRC connected mode during each granularity period.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_conn_avg{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_conn_max
    + Description: RRCConnMax the max number of users in RRC connected mode during each granularity period.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_conn_max{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connestabatt_tot
    + Description: RRCConnEstabAttTot total number of RRC connection establishment attempts.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connestabatt_tot{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connestabsucc_tot
    + Description: RRCConnEstabSuccTot total number of successful RRC Connection establishments.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connestabsucc_tot{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connreestabatt_hofail
    + Description: RRCConnReEstabAttHOFail total number of RRC connection re-establishment attempts due to Handover failure.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connreestabatt_hofail{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connreestabatt_other
    + Description: RRCConnReEstabAttOther total number of RRC connection re-establishment attempts due to Other reasons.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connreestabatt_other{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connreestabatt_reconfigfail
    + Description: RRCConnReEstabAttreconfigFail total number of RRC connection re-establishment attempts due to reconfiguration failure.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connreestabatt_reconfigfail{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
  - onos_xappkpimon_rrc_connreestabatt_tot
    + Description: RRCConnReEstabAttTot total number of RRC connection re-establishment attempts.
    + Value: float64.
    + Dimensions/Labels: cellid, egnbid, plmnid.
    + Example: onos_xappkpimon_rrc_connreestabatt_tot{cellid="343332707639553",egnbid="5153",plmnid="1279014",sdran="xappkpimon"} 5
- onos-pci:
  - onos_xapppci_conflicts
    + Description: The number of pci conflicts.
    + Value: float64.
    + Dimensions/Labels: cellid.
    + Example: onos_xapppci_conflicts{cellid="343332707639809",sdran="xapppci"} 9


## Accessing the onos-exporter metrics

To look at the onos-exporter metrics, it's possible to access the onos-exporter directly or visualize the metrics in grafana.

To access the metrics directly have a port-forward kubectl command for onos-exporter service:
```bash
kubectl -n riab port-forward svc/onos-exporter 9861
```

Then access the address `localhost:9861/metrics` in the browser. The exporter shows golang related metrics too.

To access the metrics using grafana, proceed with the access to [grafana](#access-the-grafana-dashboards). After accessing grafana go to the `Explore` item on the left menu, on the openned window select the Prometheus data source, and type the name of the metrics to see its visualization and click on the `Run query` button.


# Enabling custom sdran logging parser

In fluentbit there is the possibility to declare custom parsers for particular kubernetes pods, [check this to learn more](https://docs.fluentbit.io/manual/pipeline/parsers). It can be configured via annotations to a deployment pod.
The sdran components have a particular log format, as they use the logging package of onos-lib-go.
In the sdran logs presented by grafana, there is no strict parsing, i.e., the logs are presented in a raw format.

A fluentbit logging parser for the sdran components is defined in the sdran chart, check its structure definition as shown below:
```text
    customParsers: |
      [PARSER]
        Name sdran
        Format regex
        Regex ^(?<timestamp>\d{4}-\d{2}-\d{2}.\d{2}:\d{2}:\d{2}.\d{3}).\s+(?<logLevel>\S+)\s+(?<process>\S+)\s+(?<file>\S+):(?<lineNo>\d+)\s+(?<log>.*)$
        Time_Key timestamp
        Time_Format %Y-%m-%dT%H:%M:%S.%L
```

In order to enable this logging parser, there is the need to define annotations in the template deployments of the helm charts for those components.
This annotation is defined as the value below:

```yaml
spec:
  template:
    metadata: 
      annotations:
        fluentbit.io/parser: sdran
```

Given the application of the fluentbit logging parser to a Kubernetes pod deployment via the annotations above, the sdran log format in grafana for such component will be parsed, as the Regex patter of the custom sdran parser, with the fields: timestamp, logLevel, process, file, lineNo, log. The field log will be the last one presenting the message in the logs shown in the grafana SDRAN logging dashboard.

## Cleaning
As logging and monitoring are enabled via the same sdran umbrella helm chart, when running the commands to reset the test and clean the environment, logging and monitoring k8s components will also be removed in RiaB.
