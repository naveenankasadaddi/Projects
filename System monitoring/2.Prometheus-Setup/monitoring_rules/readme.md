# Prometheus Rules and Alert Evaluation

Prometheus is not only a powerful monitoring system but also provides capabilities to define **rules** for evaluating alerts and precomputing frequently needed queries. These rules are typically defined in separate YAML files and referenced in the `prometheus.yml` configuration file.

## Types of Rules in Prometheus

1. **Alerting Rules**:  
   - Define conditions under which alerts should be triggered.  
   - Prometheus continuously evaluates these rules at regular intervals.  
   - When conditions are met, an alert is sent to the Alertmanager.

2. **Recording Rules**:  
   - Precompute and store the results of frequently used queries.
   - This improves query performance for dashboards and other use cases.

## Example of Alerting Rule

Below is an example of an alerting rule defined in a rules file (e.g., `alerts.yml`):

```yaml
groups:
  - name: example-alerts
    rules:
      - alert: HighCPUUsage
        expr: avg(rate(node_cpu_seconds_total{mode="user"}[5m])) > 0.8
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage has been above 80% for the past 5 minutes on {{ $labels.instance }}"
