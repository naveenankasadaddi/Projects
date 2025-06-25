#nohup  ./prometheus --storage.tsdb.retention.time=30d --storage.tsdb.path="/ebs/prometheus/data"  --web.enable-lifecycle --web.enable-admin-api --log.level=debug --config.file=/ebs/prometheus/current/prometheus.yml    1>>pro.log 2>>pro.err &

nohup  ./prometheus --storage.tsdb.retention.time=30d --storage.tsdb.path="/ebs/prometheus/data"  --web.enable-lifecycle --web.enable-admin-api --log.level=debug --config.file=/ebs/prometheus/current/prometheus.yml  --web.config.file=/ebs/prometheus/current/web-config.yaml  1>>pro.log 2>>pro.err &
