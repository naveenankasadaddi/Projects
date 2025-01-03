# **Prometheus**
  - Prometheus is an open-source monitoring and alerting toolkit primarily designed for reliability and scalability.
  - It works by scraping metrics from configured endpoints at regular intervals, storing them in a time-series database for analysis.
  - Prometheus uses a multi-dimensional data model, where each metric is identified by a unique set of key-value pairs, called labels.
  - The main data type in Prometheus is the time series, which represents data points over time, including counter, gauge, histogram, and summary types.
  - Prometheus is highly effective for monitoring microservices, containers, and other infrastructure components.
  - It can be used by defining scraping configurations, setting up alerting rules, and using its query language, PromQL, to analyze metrics.
  - The default port for Prometheus is 9090, which is where the Prometheus web UI and API are accessible.
  - Applications such as Kubernetes, Docker, and various system exporters like Node Exporter or Windows Exporter can integrate with Prometheus for effective monitoring and alerting.
  - prometheus.yml is the configuration file used by the Prometheus to
    1.Scrape Configuration: Defines the target endpoints from which Prometheus scrapes metrics, including scrape intervals and timeouts.
    2.Alerting Rules: Specifies conditions for triggering alerts, including severity, description, and labels.
    3.Global Settings: Configures global parameters such as scrape interval, external labels, and time zone settings.
    4.Remote Write/Read: Allows Prometheus to send data to remote systems or query data from external storage.
    5.Rule Files: Points to files containing alerting or recording rules to process data and trigger alerts.
    6.Service Discovery: Configures automatic discovery of targets in dynamic environments like Kubernetes or Consul.
    7.Recording Rules: Defines calculations or transformations on time series data, storing the results as new time series.
    8.Target Grouping: Specifies how to organize and label scraped targets for easier management and query.

    <img align="left" src="https://code.dlang.org/packages/prometheus/logo?s=5b00c78395e28c9f431d203d" alt="Monitoring Banner" width="400"/>

<br clear="left"/>

  - A Sample of prometheus.yml can be seen in this directory.
