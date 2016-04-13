directory "#{node['jenkins']['node']['home']}" do
  action :create
  not_if { File.directory?("#{node['jenkins']['node']['home']}") }
end

ri_ebs_mount do
  cookbook "ri_ebs"
  service 'jenkins'
  mount_dir node['jenkins']['server']['home']
  owner node['jenkins']['server'][:user]
  group node['jenkins']['server'][:group]

  ec2_path node['jenkins']['server'][:ec2_path]
  ec2_ebs_mount node['jenkins']['server'][:ec2_ebs_mount]
end