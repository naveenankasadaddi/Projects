# Grafana Dashboards for Infrastructure & Application Metrics

This README provides a guide to setting up meaningful Grafana dashboards for monitoring key Infrastructure and Application metrics. These dashboards are designed to offer quick insights into system health and application performance, enabling proactive issue detection and informed decision-making.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Grafana Setup](#grafana-setup)
  - [Accessing Grafana](#accessing-grafana)
  - [Adding a Data Source (e.g., Prometheus)](#adding-a-data-source-e.g.-prometheus)
- [Dashboard 1: Infrastructure Metrics Overview](#dashboard-1-infrastructure-metrics-overview)
  - [CPU Utilization](#cpu-utilization)
  - [Memory Usage](#memory-usage)
  - [Disk I/O](#disk-io)
  - [Network Throughput](#network-throughput)
  - [System Load Average](#system-load-average)
- [Dashboard 2: Application Performance Monitoring (APM)](#dashboard-2-application-performance-monitoring-apm)
  - [Request Rate](#request-rate)
  - [Error Rate](#error-rate)
  - [Latency (Response Time)](#latency-response-time)
  - [Active Users / Sessions (Example)](#active-users--sessions-example)
- [Dashboard Design Best Practices](#dashboard-design-best-practices)
- [Troubleshooting Grafana Dashboards](#troubleshooting-grafana-dashboards)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Grafana is a powerful open-source platform for data visualization and monitoring. This guide focuses on creating two essential dashboards within Grafana: one for comprehensive infrastructure health and another for critical application performance metrics. By visualizing these metrics, we aim to gain deep insights into our systems' operational status and the efficiency of our services.

## Prerequisites

Before proceeding, ensure you have:

* **Grafana Instance:** A running Grafana server.
* **Metrics Collection System:** A system like Prometheus (recommended) configured to collect:
    * **Infrastructure Metrics:** From servers (e.g., via Node Exporter).
    * **Application Metrics:** From your applications (e.g., via Prometheus client libraries exposing a `/metrics` endpoint).
* **Network Connectivity:** Grafana must be able to reach your metrics collection system.

## Grafana Setup

### Accessing Grafana

1.  Open your web browser and navigate to `http://your_grafana_ip:3000`.
2.  Log in using your credentials (default `admin/admin` for first-time access, you'll be prompted to change it).

### Adding a Data Source (e.g., Prometheus)

Grafana needs to know where to fetch the metrics from. We'll use Prometheus as an example data source.

1.  Click the **gear icon** (Configuration) on the left sidebar, then select **"Data sources"**.
2.  Click **"Add data source"**.
3.  Search for and select **"Prometheus"**.
4.  **HTTP:**
    * **URL:** Enter the URL of your Prometheus server (e.g., `http://your_prometheus_ip:9090`).
    * **Access:** Select `Server` (recommended for security).
5.  Click **"Save & Test"**. You should see a "Data source is working" message.

## Dashboard 1: Infrastructure Metrics Overview

**Purpose:** This dashboard provides a consolidated, high-level view of the health and resource utilization across our server infrastructure. It helps identify potential bottlenecks, resource contention, and anomalous behavior that could impact any running services, including workloads.

**How to Create:**
1.  Click the **"+" icon** on the left sidebar, then select **"Dashboard"**.
2.  Click **"Add a new panel"**.
3.  Select your Prometheus data source.
4.  For each panel, configure the **Query** (PromQL) and **Visualization** type as described below.

### CPU Utilization

* **Panel Type:** Graph
* **Description:** Shows the percentage of CPU time spent in various states (user, system, I/O wait) across all monitored servers.
* **PromQL Query (Total CPU Usage):**
    ```promql
    avg by (instance) (100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100))
    ```
    *This query calculates the average CPU utilization percentage per instance, excluding idle time.*
* **PromQL Query (Breakdown by Mode):**
    ```promql
    avg by (mode) (rate(node_cpu_seconds_total{mode!="idle", mode!="iowait", mode!="steal", mode!="softirq", mode!="irq", mode!="nice"}[5m])) * 100
    ```
    *This query shows the breakdown of CPU usage by user, system, etc. You can adjust `mode` labels as needed.*

### Memory Usage

* **Panel Type:** Graph
* **Description:** Visualizes total, used, free, buffered, and cached memory, along with swap space utilization.
* **PromQL Query (Used Memory Percentage):**
    ```promql
    (node_memory_MemTotal_bytes - node_memory_MemFree_bytes - node_memory_Buffers_bytes - node_memory_Cached_bytes) / node_memory_MemTotal_bytes * 100
    ```
    *This calculates the percentage of actively used memory, excluding buffers and cache which can be reclaimed.*
* **PromQL Query (Swap Used Percentage):**
    ```promql
    node_memory_SwapUsed_bytes / node_memory_SwapTotal_bytes * 100
    ```

### Disk I/O

* **Panel Type:** Graph
* **Description:** Monitors disk read and write operations (bytes per second) and I/O operations per second (IOPS).
* **PromQL Query (Read Bytes/sec):**
    ```promql
    rate(node_disk_read_bytes_total[5m])
    ```
* **PromQL Query (Write Bytes/sec):**
    ```promql
    rate(node_disk_written_bytes_total[5m])
    ```
* **PromQL Query (IOPS):**
    ```promql
    rate(node_disk_reads_completed_total[5m]) + rate(node_disk_writes_completed_total[5m])
    ```

### Network Throughput

* **Panel Type:** Graph
* **Description:** Shows incoming and outgoing network traffic in bytes per second for key network interfaces.
* **PromQL Query (Received Bytes/sec):**
    ```promql
    rate(node_network_receive_bytes_total[5m])
    ```
* **PromQL Query (Transmitted Bytes/sec):**
    ```promql
    rate(node_network_transmit_bytes_total[5m])
    ```

### System Load Average

* **Panel Type:** Graph or Single Stat
* **Description:** Displays the 1, 5, and 15-minute load averages, indicating the average number of processes waiting for CPU.
* **PromQL Query (1-minute Load):**
    ```promql
    node_load1
    ```
* **PromQL Query (5-minute Load):**
    ```promql
    node_load5
    ```
* **PromQL Query (15-minute Load):**
    ```promql
    node_load15
    ```

## Dashboard 2: Application Performance Monitoring (APM)

**Purpose:** This dashboard provides critical insights into the performance and health of core applications. It focuses on user-facing metrics that directly impact the customer experience and the efficiency of the services.

**How to Create:**
1.  In Grafana, create a new dashboard or add panels to an existing one.
2.  Select your Prometheus data source.
3.  Ensure your applications are instrumented to expose these metrics (e.g., using Prometheus client libraries).

### Request Rate

* **Panel Type:** Graph
* **Description:** Shows the total number of requests per second handled by your application.
* **PromQL Query:**
    ```promql
    sum by (instance, job) (rate(http_requests_total[5m]))
    ```
    *Assumes your application exposes a counter `http_requests_total`.*

### Error Rate

* **Panel Type:** Graph or Single Stat (Gauge)
* **Description:** Displays the percentage or count of failed requests (e.g., HTTP 5xx errors) per second.
* **PromQL Query (Error Count/sec):**
    ```promql
    sum by (instance, job) (rate(http_requests_total{code=~"5xx|4xx"}[5m]))
    ```
    *Adjust `code` regex to match your application's error codes.*
* **PromQL Query (Error Percentage):**
    ```promql
    (sum by (instance, job) (rate(http_requests_total{code=~"5xx|4xx"}[5m])) / sum by (instance, job) (rate(http_requests_total[5m]))) * 100
    ```

### Latency (Response Time)

* **Panel Type:** Graph (using Histogram or Summary metrics)
* **Description:** Visualizes the distribution of response times (e.g., P99, P95, Average latency), crucial for understanding user experience.
* **PromQL Query (P99 Latency - for Histogram metrics):**
    ```promql
    histogram_quantile(0.99, sum by (le, instance, job) (rate(http_request_duration_seconds_bucket[5m])))
    ```
    *Assumes your application exposes a histogram `http_request_duration_seconds_bucket`.*
* **PromQL Query (Average Latency - for Summary or Histogram metrics):**
    ```promql
    rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])
    ```

### Active Users / Sessions (Example)

* **Panel Type:** Graph or Single Stat
* **Description:** Tracks the number of currently active users or sessions within the application.
* **PromQL Query:**
    ```promql
    your_app_active_users_total # Or similar metric exposed by your application
    ```
    *This requires your application to expose a gauge metric like `your_app_active_users_total`.*

## Dashboard Design Best Practices

* **Meaningful Titles:** Use clear and concise titles for dashboards and panels.
* **Logical Grouping:** Group related metrics together (e.g., all CPU metrics in one row).
* **Time Range:** Utilize Grafana's time range selector effectively (e.g., last 1 hour, last 6 hours, custom).
* **Templating Variables:** Use template variables (e.g., for `instance`, `job`, `environment`) to make dashboards dynamic and reusable across different servers or applications.
    * **Example Variable:** `label_values(node_cpu_seconds_total, instance)` to select instances.
* **Thresholds & Alerts:** Set up visual thresholds on panels (e.g., red for critical CPU usage) and configure Grafana alerts for proactive notifications.
* **Annotations:** Use annotations to mark significant events (e.g., deployments, outages) on your graphs.
* **Drill-down:** Consider adding data links to panels to allow users to click through to more detailed dashboards or logs (e.g., linking from an error rate spike to relevant application error logs in Loki/Elasticsearch).

## Troubleshooting Grafana Dashboards

* **Data Source Connectivity:** Ensure your Prometheus data source is "working" (Configuration -> Data sources).
* **PromQL Query Syntax:** Double-check your PromQL queries. Use Grafana's "Explore" feature to test queries before adding them to a dashboard.
* **Time Range:** Verify the selected time range covers the period when data was expected.
* **Metric Availability:** Confirm that the metrics you are querying are actually being collected by Prometheus and are available. Check Prometheus UI (`http://your_prometheus_ip:9090/graph`) to search for metrics.
* **Panel Inspector:** Use the "Panel Inspector" (available in panel edit mode, "Inspect" button) to view the raw query, data, and statistics, which can help diagnose issues.

## Security Considerations

* **Grafana Access:** Secure your Grafana instance with strong passwords, and consider integrating with an authentication provider (LDAP, OAuth). Implement RBAC.
* **Data Source Permissions:** If your Prometheus instance has authentication, configure it in Grafana's data source settings.
* **Network Access:** Restrict network access to your Grafana instance and Prometheus server to authorized personnel only.
* **TLS/SSL:** Use HTTPS for Grafana and Prometheus to encrypt communication.
* **Regular Updates:** Keep Grafana and all its plugins updated to the latest stable versions.

## Contributing

Feel free to contribute to this README by suggesting improvements, adding more dashboard examples, or sharing best practices for Grafana visualization.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

# **Summary**
This README.md provides a comprehensive guide to setting up impactful Grafana dashboards for monitoring critical infrastructure and application metrics. It details the process of connecting Grafana to a metrics data source like Prometheus, then outlines specific panel configurations and PromQL queries for key indicators such as CPU, memory, disk I/O, network throughput, request rates, error rates, and latency. The guide aims to equip teams with the necessary tools to visualize system health and application performance, enabling proactive issue detection and data-driven decision-making.