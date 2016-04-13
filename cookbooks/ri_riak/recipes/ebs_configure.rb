ri_ebs_mount do
  cookbook "ri_ebs"
  service 'riak'
  mount_dir node['riak']['data_dir']
  owner node['riak'][:user]
  group node['riak'][:group]

  ec2_path node['riak'][:ec2_path]
  ec2_ebs_mount node['riak'][:ec2_ebs_mount]
end