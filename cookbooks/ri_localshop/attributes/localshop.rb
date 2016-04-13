node.override['localshop']['user'] = node[:rawiron][:web_user]
node.override['localshop']['group'] = node[:rawiron][:web_group]
node.override['localshop']['secret_key'] = "<your-secret>"
node.override['localshop']['revision'] = "<your-revision>"

default['localshop']['data_dir'] = "#{node['localshop']['dir']}/shared"
default['localshop'][:ebs] = true
default['localshop'][:ec2_path] = "/vol/localshop/data"
default['localshop'][:ec2_ebs_mount] = "/vol/localshop"
