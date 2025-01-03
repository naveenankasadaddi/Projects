## *Exporter*
  - Exporters in monitoring are tools that collect metrics from various systems, applications, or services and expose them in a format compatible with Prometheus. 
  - They bridge the gap between Prometheus and systems that don’t natively support Prometheus metrics.Exporters run as standalone services or agents and scrape or pull metrics from their respective sources.
  - Common examples include Node Exporter (for system metrics) and Blackbox Exporter (for endpoint probing). Exporters simplify monitoring by making diverse systems observable within the Prometheus ecosystem.

# **Node_exporter**
  - The Node Exporter is a Prometheus exporter designed to expose hardware and operating system metrics for Linux/Unix systems.
  - It provides detailed information on CPU, memory, disk, and network utilization, as well as other system-level statistics.
  - Node Exporter runs as a standalone service and collects metrics using standard system interfaces like /proc and /sys.
  - It is lightweight, widely used for infrastructure monitoring, and supports a variety of optional collectors for additional metrics, enabling detailed insights into system performance.

<img align="left" src="https://miro.medium.com/v2/resize:fit:1200/1*3fz7PoCp6KzAlMPwqhtZVg.png" alt="Monitoring Banner" width="400"/>

<br clear="left"/>

  - You can download Node Exporter from its official GitHub releases page:

    [Node Exporter GitHub Releases](https://github.com/prometheus/node_exporter/releases)

# **Windows_exporter**
  - The Windows Exporter (formerly known as the WMI Exporter) is a Prometheus exporter designed for collecting Windows system metrics.
  - It uses Windows Management Instrumentation (WMI) to gather and expose metrics in Prometheus-compatible format.
  - Key Features:
      1. System Metrics: Collects CPU, memory, disk, and network statistics.
      2. Service Monitoring: Monitors running services and their status.
      3. Custom Collectors: Includes modules for IIS, Active Directory, and other Windows-specific features.
      4. Lightweight and Flexible: Can be configured to enable or disable specific collectors.
      5. Widely Used: Ideal for integrating Windows servers into a Prometheus-based monitoring setup.

  - You can download the latest release of the Windows Exporter from the official GitHub releases page:

    [Windows Exporter GitHub Releases](https://github.com/prometheus-community/windows_exporter/releases)
