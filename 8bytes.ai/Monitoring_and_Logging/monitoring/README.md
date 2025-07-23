# Linux and Windows System Monitoring using  node_exporter,windows exporter,Prometheus,Alertmanager and Grafana

<img align="left" src="https://uptimerobot.com/blog/wp-content/uploads/2024/05/opensourcewebsitemonitoring.webp" alt="Monitoring Banner" width="400"/>

<br clear="left"/>

This project demonstrates how to monitor both **Linux** and **Windows** systems using **Prometheus** and **Grafana**. It leverages the **Node Exporter** for Linux systems and the **Windows Exporter** for Windows machines to collect system metrics. These metrics are visualized in **Grafana** through custom dashboards, providing insights into the system's performance and health.

## Project Overview

System monitoring is crucial to ensure the availability and performance of infrastructure. This project sets up a robust monitoring solution to track important metrics such as CPU usage, memory consumption, disk usage, and network statistics for both Linux and Windows systems.

## Tools Used

### 1. **Prometheus**
   - A powerful open-source monitoring  toolkit designed for reliability and scalability.
   - Used to scrape metrics from the Node Exporter (for Linux) and Windows Exporter (for Windows) at regular intervals.

### 2. **Grafana**
   - A data visualization and monitoring platform.
   - Used to create custom dashboards that display metrics from both Linux and Windows systems in a user-friendly interface.

### 3. **Node Exporter (Linux)**
   - An exporter that exposes Linux system metrics such as CPU, memory, and disk usage to Prometheus.

### 4. **Windows Exporter (formerly WMI Exporter)**
   - An exporter that exposes Windows system metrics such as CPU, memory, and disk usage to Prometheus.
### 5. **Database monitoring(mysql_exporter)**
   - An exporter that exposes Mysql metrics  such as uptime,Mysql connections etc

## Monitoring Setup

### 1. **System Monitoring**
#### A. **Linux System Monitoring**
   - Install **Node Exporter** on your Linux servers to expose system-level metrics.
   - Metrics are collected by Prometheus and can be visualized in Grafana.

#### B. **Windows System Monitoring**
   - Install **Windows Exporter** on your Windows servers to collect key system metrics.
   - Prometheus will scrape these metrics and display them in Grafana.

### 2. **Prometheus Configuration**
   - Prometheus is configured to scrape both **Node Exporter** (Linux) and **Windows Exporter** (Windows) metrics.
   - Modify the `prometheus.yml` file to include targets for both Linux and Windows servers.

### 3. **Alertmanager Configuration**
   - Alert-manager is used to trigger an alert with the help of prometheus metrics.
   - Alertmanager can send the alerts via Email,PagerDuty,Slack,Webhook,OpsGenie,VictorOps (Splunk On-Call),Pushover,AWS SNS,Custom Integrations.

### 4. **Grafana Dashboards**
   - Grafana is used to create and manage monitoring dashboards.
   - Pre-built dashboards are available for both Linux and Windows system monitoring, or you can create custom dashboards based on the exposed metrics.

   For specific operations open the files

- After the complete setup of node_exporter,prometheus your exporter should send the system metrics to prometheus.

# **Infrastructure metrics (CPU, memory, disk)**
Prometheus, via Node Exporter, collects infrastructure-level metrics that help you monitor the health and performance of servers or nodes. The key ones include:

- CPU: how busy your processor is.

- Memory: how much RAM is in use or available

- Disk: how much disk space and I/O is used

### **CPU**
```
 ---------------------------------------------------------------------------------------------------------
| **Metric Name**                         | **Meaning**                                                    |
| --------------------------------------- | -------------------------------------------------------------- |
| `node_cpu_seconds_total{mode="user"}`   | Time CPU spent in user mode                                    |
| `node_cpu_seconds_total{mode="system"}` | Time CPU spent in system/kernel mode                           |
| `node_cpu_seconds_total{mode="idle"}`   | Time CPU spent doing nothing                                   |
| `node_cpu_seconds_total{mode="iowait"}` | Time CPU waiting for I/O to complete                           |
| `node_cpu_seconds_total{mode="steal"}`  | Time stolen from this VM by hypervisor (in virtualized setups) |
 ----------------------------------------------------------------------------------------------------------

CPU Usage Calculation:
100 - (avg by (instance)(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### **Memory**
```
  ---------------------------------------------------------------------------------------
| **Metric Name**                  | **Meaning**                                         |
| -------------------------------- | --------------------------------------------------- |
| `node_memory_MemTotal_bytes`     | Total physical memory available on the node         |
| `node_memory_MemFree_bytes`      | Amount of memory completely unused                  |
| `node_memory_MemAvailable_bytes` | Memory available for new processes without swapping |
| `node_memory_Buffers_bytes`      | Cache used for block device I/O                     |
| `node_memory_Cached_bytes`       | Memory used for filesystem cache                    |
| `node_memory_SwapTotal_bytes`    | Total swap space                                    |
| `node_memory_SwapFree_bytes`     | Free swap space                                     |
 ----------------------------------------------------------------------------------------

Memory Usage Calculation:
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)
```

### ** DISK METRICS**
```
 ---------------------------------------------------------------------------
| **Metric Name**               | **Meaning**                                |
| ----------------------------- | ------------------------------------------ |
| `node_filesystem_size_bytes`  | Total size of filesystem                   |
| `node_filesystem_avail_bytes` | Available space on filesystem              |
| `node_filesystem_free_bytes`  | Free space (some may be reserved for root) |
 ----------------------------------------------------------------------------

 Disk Usage % Calculation:
 100 * (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes))
```

# **Application metrics (request rate, error rate, latency)**
To collect application metrics like request rate, error rate, and latency in Prometheus, you need to instrument your application with an appropriate Prometheus client library and expose a /metrics endpoint. Here's how you can implement and monitor these key metrics:

### **Step 1: Instrument Your Application**
Use a Prometheus client library (based on your app's language):

- Go: prometheus/client_golang

- Python: prometheus_client

- Java: simpleclient

- Node.js: prom-client
```
from prometheus_client import Counter, Histogram, start_http_server
import time
import random

# Metrics definitions
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP Requests', ['method', 'endpoint'])
REQUEST_ERRORS = Counter('http_request_errors_total', 'Total HTTP Errors', ['method', 'endpoint', 'http_status'])
REQUEST_LATENCY = Histogram('http_request_latency_seconds', 'Latency in seconds', ['method', 'endpoint'])

def handle_request(method, endpoint):
    REQUEST_COUNT.labels(method=method, endpoint=endpoint).inc()
    start = time.time()
    
    try:
        # simulate work
        if random.random() < 0.2:
            raise Exception("Error")
        time.sleep(random.uniform(0.1, 0.3))
    except Exception:
        REQUEST_ERRORS.labels(method=method, endpoint=endpoint, http_status="500").inc()
    finally:
        duration = time.time() - start
        REQUEST_LATENCY.labels(method=method, endpoint=endpoint).observe(duration)

if __name__ == '__main__':
    start_http_server(8000)
    while True:
        handle_request("GET", "/api/data")

```


### **Step 2: Prometheus Configuration**
In your prometheus.yml, add your app's metrics endpoint:
```
scrape_configs:
  - job_name: 'my_app'
    static_configs:
      - targets: ['localhost:8000']
```

### **Step 3: PromQL Queries for Metrics**
Once metrics are scraped, use the following PromQL queries:

```
1. Request Rate (requests per second)

rate(http_requests_total[1m])

rate(http_requests_total[1m]) by (method, endpoint)

2. Error Rate (errors per second)

rate(http_request_errors_total[1m])

100 * rate(http_request_errors_total[1m]) / rate(http_requests_total[1m])

3. Request Latency (Histogram or Summary)
histogram_quantile(0.95, rate(http_request_latency_seconds_bucket[5m]))

```

# **Database metrics**
To monitor database metrics using Prometheus, you can use database-specific exporters that expose metrics from popular databases like MySQL, PostgreSQL, MongoDB, etc., in Prometheus-compatible format.


### *What Are Database Metrics?*
These metrics give visibility into query performance, connection usage, cache hit ratio, table locks, slow queries, replication lag, etc.
 ----------------------------------------------------------
| Category         | Examples                               |
| ---------------- | -------------------------------------- |
| **Connections**  | Active connections, max connections    |
| **Queries**      | Query rate, slow queries, query errors |
| **Cache**        | Buffer pool size, cache hit ratio      |
| **Replication**  | Lag, status, delays                    |
| **Transactions** | Commits, rollbacks                     |
| **Locks**        | Table/row locks, lock timeouts         |
  ---------------------------------------------------------

###  **Exporters for Common Databases**
| **Database**   | **Exporter Name**   | **Port** | **GitHub Link**                                                                                                            |
| -------------- | ------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------- |
| **MySQL**      | `mysqld_exporter`   | `9104`   | 👉 [https://github.com/prometheus/mysqld\_exporter](https://github.com/prometheus/mysqld_exporter)                         |
| **PostgreSQL** | `postgres_exporter` | `9187`   | 👉 [https://github.com/prometheus-community/postgres\_exporter](https://github.com/prometheus-community/postgres_exporter) |
| **MongoDB**    | `mongodb_exporter`  | `9216`   | 👉 [https://github.com/percona/mongodb\_exporter](https://github.com/percona/mongodb_exporter)                             |
| **Redis**      | `redis_exporter`    | `9121`   | 👉 [https://github.com/oliver006/redis\_exporter](https://github.com/oliver006/redis_exporter)                             |



## **Example: MySQL Metrics via mysqld_exporter**
  please use the documentation in the Database section for installation

## **Example MySQL Metrics (Prometheus Format)** 
 ------------------------------------------------------------------------------------
| Metric Name                                            | Description                |
| ------------------------------------------------------ | -------------------------- |
| `mysql_global_status_threads_connected`                | Active connections         |
| `mysql_global_status_questions`                        | Number of queries executed |
| `mysql_global_status_slow_queries`                     | Number of slow queries     |
| `mysql_global_status_innodb_buffer_pool_read_requests` | Buffer pool read attempts  |
| `mysql_global_status_innodb_buffer_pool_reads`         | Actual disk reads          |
| `mysql_slave_status_seconds_behind_master`             | Replication lag            |
| `mysql_global_status_queries`                          | Total executed statements  |
  ------------------------------------------------------------------------------------

## **PromQL Examples for Dashboards**
```
🔹  Active MySQL Connections
mysql_global_status_threads_connected

🔹 MySQL Queries per Second
rate(mysql_global_status_questions[1m])

🔹 MySQL Slow Queries
rate(mysql_global_status_slow_queries[5m])

🔹 Buffer Pool Hit Ratio
1 - (rate(mysql_global_status_innodb_buffer_pool_reads[5m]) / rate(mysql_global_status_innodb_buffer_pool_read_requests[5m]))

🔹 Replication Lag
mysql_slave_status_seconds_behind_master

```