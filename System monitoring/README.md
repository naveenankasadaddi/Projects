# Linux and Windows System Monitoring using  Prometheus,Alertmanager,node_exporter,windows exporter and Grafana

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

## Monitoring Setup

### 1. **Prometheus Configuration**
   - Prometheus is configured to scrape both **Node Exporter** (Linux) and **Windows Exporter** (Windows) metrics.
   - Modify the `prometheus.yml` file to include targets for both Linux and Windows servers.

### 2. **Linux System Monitoring**
   - Install **Node Exporter** on your Linux servers to expose system-level metrics.
   - Metrics are collected by Prometheus and can be visualized in Grafana.

### 3. **Windows System Monitoring**
   - Install **Windows Exporter** on your Windows servers to collect key system metrics.
   - Prometheus will scrape these metrics and display them in Grafana.

### 4. **Grafana Dashboards**
   - Grafana is used to create and manage monitoring dashboards.
   - Pre-built dashboards are available for both Linux and Windows system monitoring, or you can create custom dashboards based on the exposed metrics.

