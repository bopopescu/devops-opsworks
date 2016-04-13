def this_node_name
  node[:cloud][:this_node]
end

def this_node_private_ip
  "#{node[:cloud][:my_private_ip]}"
end

def this_node_public_ip
  "#{node[:cloud][:my_public_ip]}"
end


def previous_ip
  if (node['riak']['ec2_path'] && FileTest.directory?("#{node['riak']['ec2_path']}/recover"))
    # recover old ipaddress
    if File.exists?("#{node['riak']['ec2_path']}/recover/ipaddress")
      ipaddress_file = File.open("#{node['riak']['ec2_path']}/recover/ipaddress", "r")
      previous_ip = ipaddress_file.read
      ipaddress_file.close
      return previous_ip
    else
      return nil
    end
  end
end

def current_ip
  this_node_private_ip
end

def restart?
  (previous_ip != current_ip)
end

def init?
  (previous_ip.nil?)
end


if init? or restart?
=begin
  execute "remove riak ring files" do
    command "rm -f #{node['riak']['ec2_path']}/ring/riak_core_ring.default.*"
    action :run
  end
=end
end


def save_ip
  file "#{node['riak']['ec2_path']}/recover/ipaddress" do
    owner node['riak']['user']
    group node['riak']['group']
    mode 0644
    action :create_if_missing
  end

  ruby_block "write ip to file" do
    block do
      ipaddress_file = File.open("#{node['riak']['ec2_path']}/recover/ipaddress", "w")
      ipaddress_file.write(node['ipaddress'])
      ipaddress_file.close
    end
  end
end

save_ip