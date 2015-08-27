#
# Cookbook Name:: spark
# Recipe:: config
#
# Copyright 2015, Passworks
#
# All rights reserved - Do Not Redistribute
#

spark_user  = node[:spark][:user]
spark_group = node[:spark][:group]
spark_dir   = "#{node[:spark][:install_dir]}/spark-#{node[:spark][:version]}"

bag = data_bag_item('config', node["spark-cluster"]["databag"])

# File to setup spark environment
template  "#{spark_dir}/conf/spark-env.sh" do
  source  "spark-env.sh.erb"
  owner   spark_user
  group   spark_group
  mode    0770
  variables(
    :spark_master => bag["master"],
    :others       => node["spark"]["env"]["others"]
  )

  notifies :restart, "service[spark_master]", :Delayed
  notifies :restart, "service[spark_worker]", :delayed
end

# File to setup spark defaults
template "#{spark_dir}/conf/spark-defaults.conf" do
  source "spark-defaults.conf.erb"
  owner spark_user
  group spark_group
  mode 0770
  variables(
    :spark_master => bag["master"],
    :others       => node[:spark][:defaults][:others]
  )

  notifies :restart, "service[spark_master]", :Delayed
  notifies :restart, "service[spark_worker]", :delayed
end

# File with all the slaves
template "#{spark_dir}/conf/slaves" do
  source  "slaves.erb"
  owner   spark_user
  group   spark_group
  mode    0770
  variables(
    :slaves => bag["slaves"]
  )
 
  notifies :restart, "service[spark_master]", :delayed
  notifies :restart, "service[spark_worker]", :delayed
end

# Script to start and stop spark master
template "/etc/init/spark_master.conf" do
  source "spark_master.init.erb"
  owner  spark_user
  group  spark_group
  action :create
  mode   0770
  notifies :restart, "service[spark_master]", :delayed
  variables(
    :spark_dir => spark_dir,
    :spark_master => bag["master"]
  )
  notifies :restart, "service[spark_master]", :Delayed
end

# Script to start and stop spark workers
template "/etc/init/spark_worker.conf" do
  source "spark_worker.init.erb"
  owner  spark_user
  group  spark_group
  action :create
  mode   0770
  notifies :restart, "service[spark_worker]", :delayed
  variables(
    :spark_dir => spark_dir,
    :spark_master => bag["master"]
  )
  notifies :restart, "service[spark_worker]", :delayed
end

service "spark_master" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :stop => true
  action :enable
end

service "spark_worker" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :stop => true
  action :enable
end