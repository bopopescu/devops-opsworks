if node[:cloud][:provider] == "ec2" and node['riak']['ebs']
  include_recipe "ri_riak::ebs_configure"
end