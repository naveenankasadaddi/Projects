#nohup /usr/local/bin/alertmanager --data.retention=24h --cluster.peer=gbp-monitor-04.ec2-east1.glassbeam.com:9094 --config.file=/ebs/alertmanager/current/alertmanager.yml  --web.config.file=/ebs/alertmanager/current/web-config.yaml --log.level=info --log.format=logfmt 1>>out.log 2>>out.err &

nohup /usr/local/bin/alertmanager --data.retention=24h  --config.file=/ebs/alertmanager/current/alertmanager.yml  --log.level=info --log.format=logfmt 1>>out.log 2>>out.err &
