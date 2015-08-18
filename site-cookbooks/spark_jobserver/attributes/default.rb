default["jobserver"]["user"] = "spark"
default["jobserver"]["group"] = "spark"
default["jobserver"]["dir"] = "/opt/jobserver" 
default["jobserver"]["download"] = "https://97010159ed7d6150bf7df2f25118cfc808514446.googledrive.com/host/0B1VEKVUtHYlIflgtOTg3R1JmZjBtbWtjRUczeTIwQmNhVEJaZ0RCTS1wWGZ1ZGRnX2JCa2c/job-server.tar.gz"
default["jobserver"]["log_dir"] = "/var/log/jobserver"
default["jobserver"]["pidfile"] = "spark-jobserver.pid"
default["jobserver"]["memory"] = "1G"
default["jobserver"]["spark_version"] = "1.4.1"
default["jobserver"]["spark_home"] = "/opt/spark/spark-1.4.1"
default["jobserver"]["conf_dir"] = "/opt/spark/spark-1.4.1/conf"
default["jobserver"]["scala_version"] = "2.11.7"
default["jobserver"]["databag"] = "spark"