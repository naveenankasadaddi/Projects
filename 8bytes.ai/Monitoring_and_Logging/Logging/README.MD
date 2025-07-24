# Centralized Logging with Elastic Stack (Elasticsearch, Logstash, Beats)

This repository provides guidance and configuration examples for setting up a centralized logging solution using the Elastic Stack (formerly ELK Stack). This setup allows you to collect, process, store, and visualize application, system, and access logs from various sources in a unified manner.

## Table of Contents

- [Introduction](#introduction)
- [Architecture](#architecture)
- [Components](#components)
  - [Beats](#beats)
  - [Logstash](#logstash)
  - [Elasticsearch](#elasticsearch)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation and Configuration](#installation-and-configuration)
    - [Elasticsearch Setup](#elasticsearch-setup)
    - [Logstash Setup](#logstash-setup)
    - [Beats Setup](#beats-setup)
      - [Filebeat (Application & System Logs)](#filebeat-application--system-logs)
      - [Auditbeat (System Audit Logs)](#auditbeat-system-audit-logs)
      - [Metricbeat (System Metrics)](#metricbeat-system-metrics)
      - [Packetbeat (Network Traffic)](#packetbeat-network-traffic)
      - [Winlogbeat (Windows Event Logs)](#winlogbeat-windows-event-logs)
- [Log Types and Configuration Examples](#log-types-and-configuration-examples)
  - [Application Logs](#application-logs)
  - [System Logs](#system-logs)
  - [Access Logs](#access-logs)
- [Kibana Dashboards and Visualization](#kibana-dashboards-and-visualization)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Introduction

In modern distributed systems, managing logs across numerous servers and applications can be a significant challenge. Centralized logging addresses this by providing a single platform to collect, analyze, and visualize all your log data. This solution leverages the Elastic Stack to provide a robust and scalable logging infrastructure.

## Architecture

The general architecture involves:

1.  **Beats (Agents):** Lightweight data shippers installed on your servers/applications to collect various types of logs (application, system, access).
2.  **Logstash (Processing Pipeline):** An open-source data collection pipeline that ingests data from Beats, transforms it, and then sends it to Elasticsearch.
3.  **Elasticsearch (Data Store):** A distributed, RESTful search and analytics engine capable of storing and indexing large volumes of log data.
4.  **Kibana (Visualization):** A web interface for searching, analyzing, and visualizing data stored in Elasticsearch.

```bash
+----------------+       +-------------------+       +-------------------+       +-----------------+       +--------------------+
|   Applications | ----> |     Beats         | ----> |     Logstash      | ----> |   Elasticsearch  | ---->|   Grafana/Kibana   |
|   Servers      |       | (Filebeat, etc.)  |       | (Parsing, Filter) |       | (Indexing, Store)|      |  (Visualization)   |
|   Network      |       +-------------------+       +-------------------+       +-----------------+        +-------------------+
+----------------+                                                                       |

```

## Components

### Beats

Beats are lightweight data shippers that send data from hundreds or thousands of machines to Logstash or Elasticsearch. Each Beat is designed for a specific type of data:

* **Filebeat:** For collecting and forwarding log files.
* **Metricbeat:** For collecting system and service metrics.
* **Packetbeat:** For analyzing network packet data.
* **Winlogbeat:** For collecting Windows event logs.
* **Auditbeat:** For collecting audit data from your Linux systems.

### Logstash

Logstash is a powerful open-source data collection pipeline with real-time pipelining capabilities. It can dynamically ingest data from a multitude of sources, transform it, and send it to your chosen "stash," in this case, Elasticsearch.

### Elasticsearch

Elasticsearch is a distributed, open-source search and analytics engine built on Apache Lucene. It's designed for horizontally scalable, near real-time data storage and retrieval. It's the core of the Elastic Stack for storing and indexing your log data.

## Getting Started

This section outlines the steps to set up your centralized logging solution.

### Prerequisites

Before you begin, ensure you have:

* A Linux-based operating system (e.g., Ubuntu, CentOS) for your Elastic Stack components.
* Servers/applications from which you want to collect logs.
* Basic understanding of command-line operations.
* Java Development Kit (JDK) installed (required for Elasticsearch and Logstash).

### Installation and Configuration

#### Elasticsearch Setup

1.  **Install Elasticsearch:** Follow the official Elasticsearch documentation for installation on your chosen operating system.
    * [Elasticsearch Installation Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html)
2.  **Configure `elasticsearch.yml`:**
    ```yaml
    # /etc/elasticsearch/elasticsearch.yml
    network.host: 0.0.0.0 # Or your server's IP
    http.port: 9200
    # cluster.name: my-logging-cluster # Optional, for multi-node clusters
    # node.name: node-1 # Optional
    ```
3.  **Start Elasticsearch:**
    ```bash
    sudo systemctl start elasticsearch
    sudo systemctl enable elasticsearch
    ```

#### Logstash Setup

1.  **Install Logstash:** Follow the official Logstash documentation for installation.
    * [Logstash Installation Guide](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html)
2.  **Create Logstash Configuration Files:** Logstash uses configuration files to define input, filter, and output plugins. These files are typically located in `/etc/logstash/conf.d/`.

    * **Example: `01-beats-input.conf` (Input for Beats)**
        ```logstash
        # /etc/logstash/conf.d/01-beats-input.conf
        input {
          beats {
            port => 5044
            ssl => true
            ssl_certificate => "/etc/logstash/certs/logstash-beats.crt" # Path to your SSL certificate
            ssl_key => "/etc/logstash/certs/logstash-beats.key"     # Path to your SSL key
          }
        }
        ```
        *Note: SSL is highly recommended for secure communication between Beats and Logstash.*

    * **Example: `30-elasticsearch-output.conf` (Output to Elasticsearch)**
        ```logstash
        # /etc/logstash/conf.d/30-elasticsearch-output.conf
        output {
          elasticsearch {
            hosts => ["localhost:9200"] # Or your Elasticsearch host(s)
            index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
            user => "elastic" # If X-Pack security is enabled
            password => "your_password" # If X-Pack security is enabled
            ssl => true # If Elasticsearch uses HTTPS
            ssl_certificate_verification => false # Set to true in production with proper CAs
          }
          stdout { codec => rubydebug } # For debugging Logstash output
        }
        ```
        *Note: Adjust `hosts` and security settings as per your Elasticsearch configuration.*

    * **Example: `10-application-logs.conf` (Filter for application logs - see "Log Types" section for details)**

3.  **Generate SSL Certificates for Beats-Logstash communication:**
    ```bash
    # On your Logstash server
    sudo apt-get install openssl # if not installed
    sudo openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -keyout /etc/logstash/certs/logstash-beats.key -out /etc/logstash/certs/logstash-beats.crt
    sudo chown logstash:logstash /etc/logstash/certs/*
    sudo chmod 400 /etc/logstash/certs/logstash-beats.key
    ```
    *Copy `logstash-beats.crt` to all your Beat-enabled servers.*

4.  **Start Logstash:**
    ```bash
    sudo systemctl start logstash
    sudo systemctl enable logstash
    ```

#### Beats Setup

Install and configure the appropriate Beats on the servers/applications you wish to monitor. Remember to copy the `logstash-beats.crt` file from your Logstash server to a secure location on each Beat-enabled server (e.g., `/etc/filebeat/certs/`).

##### Filebeat (Application & System Logs)

Filebeat is the most common Beat for collecting log files.

1.  **Install Filebeat:** Follow the official Filebeat documentation.
    * [Filebeat Installation Guide](https://www.elastic.co/guide/en/beats/filebeat/current/install-filebeat.html)
2.  **Configure `filebeat.yml`:**
    ```yaml
    # /etc/filebeat/filebeat.yml
    filebeat.inputs:
    - type: log
      enabled: true
      paths:
        - /var/log/syslog       # Example: System logs
        - /var/log/auth.log     # Example: Authentication logs
        - /var/log/nginx/access.log # Example: Nginx access logs
        - /var/log/nginx/error.log  # Example: Nginx error logs
        - /path/to/your/application.log # Example: Custom application logs
      fields:
        log_type: syslog # Add custom fields for filtering in Logstash/Kibana

    #----------------------------- Logstash output --------------------------------
    output.logstash:
      hosts: ["your_logstash_ip:5044"]
      ssl.certificate_authorities: ["/etc/filebeat/certs/logstash-beats.crt"] # Path to Logstash CA cert
      ssl.verification_mode: full # Recommended for production

    #----------------------------- General settings -------------------------------
    setup.kibana:
      host: "your_kibana_ip:5601" # Optional, for loading Kibana dashboards directly from Beat
    ```
3.  **Enable Filebeat Modules (Optional but Recommended):** Filebeat comes with pre-built modules for common log types (e.g., Nginx, Apache, System).
    ```bash
    sudo filebeat modules enable system nginx # Enable system and Nginx modules
    sudo filebeat setup -e # Setup Kibana dashboards and index templates
    ```
4.  **Start Filebeat:**
    ```bash
    sudo systemctl start filebeat
    sudo systemctl enable filebeat
    ```

##### Auditbeat (System Audit Logs)

For auditing system events and user activity.

1.  **Install Auditbeat:** Follow the official Auditbeat documentation.
    * [Auditbeat Installation Guide](https://www.elastic.co/guide/en/beats/auditbeat/current/install-auditbeat.html)
2.  **Configure `auditbeat.yml`:**
    ```yaml
    # /etc/auditbeat/auditbeat.yml
    auditbeat.modules:
    - module: auditd
      enabled: true
      # ... other auditd configurations
    - module: file_integrity
      enabled: true
      paths:
        - /bin
        - /usr/bin
        - /sbin
        - /usr/sbin
        - /etc
      # ... other file_integrity configurations

    output.logstash:
      hosts: ["your_logstash_ip:5044"]
      ssl.certificate_authorities: ["/etc/auditbeat/certs/logstash-beats.crt"]
      ssl.verification_mode: full

    setup.kibana:
      host: "your_kibana_ip:5601"
    ```
3.  **Start Auditbeat:**
    ```bash
    sudo systemctl start auditbeat
    sudo systemctl enable auditbeat
    ```

##### Metricbeat (System Metrics)

For collecting system metrics like CPU, memory, disk I/O, etc.

1.  **Install Metricbeat:** Follow the official Metricbeat documentation.
    * [Metricbeat Installation Guide](https://www.elastic.co/guide/en/beats/metricbeat/current/install-metricbeat.html)
2.  **Configure `metricbeat.yml`:**
    ```yaml
    # /etc/metricbeat/metricbeat.yml
    metricbeat.modules:
    - module: system
      metricsets: ["cpu", "load", "memory", "network", "process", "diskio", "fsstat"]
      enabled: true
      period: 10s

    output.logstash:
      hosts: ["your_logstash_ip:5044"]
      ssl.certificate_authorities: ["/etc/metricbeat/certs/logstash-beats.crt"]
      ssl.verification_mode: full

    setup.kibana:
      host: "your_kibana_ip:5601"
    ```
3.  **Start Metricbeat:**
    ```bash
    sudo systemctl start metricbeat
    sudo systemctl enable metricbeat
    ```

##### Packetbeat (Network Traffic)

For monitoring network traffic at the packet level.

1.  **Install Packetbeat:** Follow the official Packetbeat documentation.
    * [Packetbeat Installation Guide](https://www.elastic.co/guide/en/beats/packetbeat/current/install-packetbeat.html)
2.  **Configure `packetbeat.yml`:**
    ```yaml
    # /etc/packetbeat/packetbeat.yml
    packetbeat.interfaces:
      device: eth0 # Or your network interface
    packetbeat.flows:
      timeout: 30s
      period: 10s
    packetbeat.procs:
      enabled: true

    output.logstash:
      hosts: ["your_logstash_ip:5044"]
      ssl.certificate_authorities: ["/etc/packetbeat/certs/logstash-beats.crt"]
      ssl.verification_mode: full

    setup.kibana:
      host: "your_kibana_ip:5601"
    ```
3.  **Start Packetbeat:**
    ```bash
    sudo systemctl start packetbeat
    sudo systemctl enable packetbeat
    ```

##### Winlogbeat (Windows Event Logs)

For collecting Windows event logs.

1.  **Install Winlogbeat:** Follow the official Winlogbeat documentation.
    * [Winlogbeat Installation Guide](https://www.elastic.co/guide/en/beats/winlogbeat/current/winlogbeat-installation.html)
2.  **Configure `winlogbeat.yml`:**
    ```yaml
    # C:\Program Files\Winlogbeat\winlogbeat.yml
    winlogbeat.event_logs:
      - name: Application
        ignore_older: 72h
      - name: Security
      - name: System

    output.logstash:
      hosts: ["your_logstash_ip:5044"]
      ssl.certificate_authorities: ["C:\Program Files\Winlogbeat\certs\logstash-beats.crt"] # Path to Logstash CA cert
      ssl.verification_mode: full

    setup.kibana:
      host: "your_kibana_ip:5601"
    ```
3.  **Start Winlogbeat:**
    ```powershell
    # Open PowerShell as Administrator
    cd "C:\Program Files\Winlogbeat"
    .\install-service-winlogbeat.ps1
    Start-Service Winlogbeat
    ```

## Log Types and Configuration Examples

This section provides specific Logstash filter configurations for common log types. These filters will parse raw log lines into structured data (fields) that are easily searchable and visualizable in Kibana.

## **Application Logs**

Application logs can vary widely in format. You'll typically use the `grok` filter to parse these.

**Filebeat Configuration (on application server):**

```yaml
# /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/your_app/app.log
  fields:
    log_type: your_application
    env: production # Example: Add environment field

Logstash Configuration (on Logstash server - /etc/logstash/conf.d/10-application-logs.conf):
filter {
  if [fields][log_type] == "your_application" {
    # Example: Apache Common Log Format
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
      remove_tag => [ "_grokparsefailure" ] # Remove if successful
    }
    # Example: JSON logs
    json {
      source => "message"
      target => "application_data"
      remove_field => ["message"]
    }
    # Example: Custom application log format (adjust as needed)
    # grok {
    #   match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:loglevel} \[%{WORD:thread}\] %{GREEDYDATA:message_content}" }
    #   add_field => { "received_at" => "%{@timestamp}" }
    # }

    # Mutate to clean up fields
    mutate {
      convert => {
        "bytes" => "integer" # If applicable from grok
        "response" => "integer" # If applicable
      }
      # remove_field => ["_grokparsefailure"] # Remove if parsing is consistently successful
    }

    # Date filter to set @timestamp
    date {
      match => [ "timestamp", "ISO8601", "MMM dd HH:mm:ss", "dd/MMM/yyyy:HH:mm:ss Z" ] # Add formats for your app
      target => "@timestamp"
      remove_field => ["timestamp"]
    }
  }
}
```
# **System Logs**
System logs (e.g., syslog, auth.log) are typically handled well by Filebeat's system module and corresponding Logstash modules.

```yml
Filebeat Configuration (on system server):
# /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/syslog
    - /var/log/auth.log
    - /var/log/kern.log
  fields:
    log_type: system

# OR use Filebeat modules (recommended):
# filebeat.modules:
# - module: system
#   syslog.enabled: true
#   auth.enabled: true

Logstash Configuration (on Logstash server - /etc/logstash/conf.d/10-system-logs.conf):
filter {
  # If using Filebeat system module, Logstash does less work
  if [fields][log_type] == "system" or [fileset][module] == "system" {
    # Example for generic syslog parsing if not using Filebeat modules
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
      add_field => [ "received_from", "%{host.name}" ]
      add_field => [ "received_at", "%{@timestamp}" ]
    }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
      target => "@timestamp"
      remove_field => [ "syslog_timestamp" ]
    }
    # Other system log specific parsing
  }
}
```

# **Access Logs**
Access logs (e.g., Nginx, Apache) are usually in a structured format and can be effectively parsed with grok.

Filebeat Configuration (on web server):

```yaml
# /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
    - /var/log/apache2/access.log # For Apache
  fields:
    log_type: access

# OR use Filebeat modules (recommended):
# filebeat.modules:
# - module: nginx
#   access.enabled: true
# - module: apache
#   access.enabled: true

Logstash Configuration (on Logstash server - /etc/logstash/conf.d/10-access-logs.conf):
filter {
  if [fields][log_type] == "access" or [fileset][module] == "nginx" or [fileset][module] == "apache" {
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
      # This pattern works for Nginx if configured with combined log format
      # If using default Nginx log format, use: '%{IPORHOST:clientip} %{NGINXACCESS}'
    }
    date {
      match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
      target => "@timestamp"
    }
    geoip {
      source => "clientip" # Add geo-location information
    }
    useragent {
      source => "agent" # Parse user-agent string
      target => "user_agent_info"
    }
    # Convert relevant fields to appropriate types
    mutate {
      convert => {
        "response" => "integer"
        "bytes" => "integer"
        "duration" => "float" # If you have response time in logs
      }
      remove_field => ["message"]
    }
  }
}
```


# **Grafana Dashboards and Visualization**
Once data is flowing into Elasticsearch, use Grafana to explore and visualize it.

- Access Grafana: Open your web browser and navigate to http://your_grafana_ip:3000. Log in with your credentials.

- Add Elasticsearch Data Source: (As described in the Grafana Setup section).

- Explore Logs in Explore:

    - Click the "Explore" icon (compass) on the left sidebar.

    - Select your Elasticsearch data source from the dropdown menu at the top.

    - You can now write Lucene queries in the query editor to filter and search your logs. For example, to see all filebeat system logs: _index:filebeat-* AND fields.log_type:system.

    - The "Logs" view will show your raw log lines. You can expand individual log entries to see all parsed fields.

    - Create Custom Dashboards:

        - Click the "+" icon on the left sidebar, then select "Dashboard".

        - Click "Add a new panel".

        - Select your Elasticsearch data source.

        - Query Editor:

            - Query: Use Lucene syntax to filter your logs (e.g., _index:filebeat-* AND loglevel:error).

            - Metrics: Choose an aggregation to visualize. For logs, common metrics include:

                1.Logs (for displaying raw log lines in a table or logs panel)

                2.Count (for log volume over time)

                3.Terms (for breakdowns by specific fields, like fields.log_type, host.name, loglevel).

                4.Group by: Set the "Date Histogram" for time-series visualizations.

        - Visualization: Choose the appropriate visualization type (e.g., Graph for time-series, Table for raw logs, Bar Chart for aggregations).

            - Panel Options: Customize title, axis labels, legends, and more.

            - Repeat to add more panels to your dashboard.

    - Import Pre-built Dashboards: While not as extensive as Kibana for Elastic-specific pre-built dashboards, the Grafana community provides many dashboards for Elasticsearch and various applications. You can often find them on Grafana Labs' dashboard-sharing platform.

        - Click the "+" icon on the left sidebar, then select "Import".

        - Enter the dashboard ID from Grafana Labs or upload a JSON file.