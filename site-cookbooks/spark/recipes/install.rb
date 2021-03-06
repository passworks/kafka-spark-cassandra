#
# Cookbook Name:: spark
# Recipe:: install
#
# Copyright 2015, Passworks
#
# All rights reserved - Do Not Redistribute
#

# Create the user
include_recipe "spark::create-user"

spark_user  = node[:spark][:user]
spark_group = node[:spark][:group]
spark_dir   = "#{node[:spark][:install_dir]}/spark-#{node[:spark][:version]}"

# Create the home directory
directory node[:spark][:install_dir] do
  owner     spark_user
  group     spark_group
  mode      0770
  action    :create
  recursive true
end

# Download and untar spark
remote_file "#{spark_dir}.tgz" do
  source    node[:spark][:download_url]
  backup    false
  notifies  :run, "execute[unzip spark source]"
  notifies  :run, "execute[chown spark files]"
  not_if    { ::File.exist?(::File.join(node[:spark][:install_dir], spark_dir)) }
end

execute "unzip spark source" do
  command "tar -zxvf #{spark_dir}.tgz -C #{node[:spark][:install_dir]}"
  not_if  { ::File.exist?(spark_dir) }
end

# Give permissions in all files
# Give permissions to the user inside the spark_dir
execute "chown spark files" do
  command "chmod -R 770 #{spark_dir}"
  command "chown -R #{spark_user}:#{spark_group} #{spark_dir}"
end