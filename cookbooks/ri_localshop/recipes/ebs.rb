ri_ebs_mount do
  cookbook "ri_ebs"
  service false
  mount_dir node['localshop']['data_dir']
  owner node['localshop'][:user]
  group node['localshop'][:group]

  ec2_path node['localshop'][:ec2_path]
  ec2_ebs_mount node['localshop'][:ec2_ebs_mount]
end
