# Steps to install and configure mysqld_exporter
- This guide provides a step-by-step setup to monitor MySQL databases using mysqld_exporter, Prometheus, and Grafana.

##  Prerequisites
- Linux machine (Amazon Linux / Ubuntu / CentOS)

- MySQL installed and running

- Prometheus installed and configured

- Grafana installed (optional for dashboards)

###  Step 1: Download and Install mysqld_exporter
```
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.0/mysqld_exporter-0.15.0.linux-amd64.tar.gz

tar -xzf mysqld_exporter-0.15.0.linux-amd64.tar.gz.1

cd mysqld_exporter-0.15.0.linux-amd64/
```

### Step 2: Create .my.cnf Configuration File
```

vim .my.cnf

[client]
user=<user_name>
password=<Password>
host=<hostname>
```
#### Note:
- Make sure you have created a usernme,password and grant the required acces to the user

```
CREATE USER '<username>'@'localhost' IDENTIFIED BY '<Password>';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO '<username>'@'localhost';
FLUSH PRIVILEGES;
```
### Step 3: Run mysqld_exporter

```
./mysqld_exporter --config.my-cnf=.my.cnf &

```

- This will run mysqld_exporter in the background and expose MySQL metrics on:
```
http://localhost:9104/metrics

```

### Step 4: Configure Prometheus to Scrape MySQL Metrics

```
sudo vi /etc/prometheus/prometheus.yml

  - job_name: 'mysql'
    static_configs:
      - targets: ['localhost:9104']

```

### Step 5: Restart Prometheus
```
systemctl restart prometheus.service

```

### Step 6: Visualize Metrics in Grafana
- Add Prometheus as a data source in Grafana.

- Import MySQL dashboards from Grafana marketplace (e.g., Dashboard ID: 7362).