# aws-eks-production-ready-observability

## Description
This lab is designed to help users create a production-ready observability environment for their Kubernetes cluster. It includes steps to set up an EKS cluster using Terraform and Fargate, deploy a microservices application, collect and store data using Prometheus, visualize data using Grafana, and send logs to an Elasticsearch cluster using Fluentd or Logstash. The lab also covers configuring alerts and notifications using Prometheus Alertmanager or ELK Watcher, and adding additional monitoring tools such as Jaeger for tracing.

### Sample application
`simple-service` is an 'as easy as possible' golang HTTP api used at Onefootball on examples and tests.

It has only a /live endpoint answering text/plain; charset=utf-8. The following responses are possibly:

- Well done :): if the application was able to connect with a Postgres database
- Running: if some error occurred during the connection with the database

Check the `config` package for more details on how to configure the database connection.
## Todo list
- [ ] Set up an EKS cluster using Terraform and Fargate.
- [ ] Deploy the sample microservices application (e.g., Bookinfo from Istio) on the EKS cluster.
- [ ] Use Prometheus to collect data from the microservices and store it in a time-series database.
- [ ] Use Grafana to visualize the data collected by Prometheus.
- [ ] Configure the cluster to send logs to an Elasticsearch cluster using Fluentd or Logstash.
- [ ] Use Kibana to search, filter, and analyze the logs from the Kubernetes environment.
- [ ] Add additional monitoring tools such as Jaeger for tracing.
- [ ] Configure alerts and notifications for critical issues using tools such as Prometheus Alertmanager or ELK Watcher.