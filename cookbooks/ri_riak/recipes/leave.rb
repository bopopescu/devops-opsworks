Chef::Log.debug("riak : leave")
Chef::Log.debug("riak : this node is #{node['ipaddress']}")


riak_instances = node[:cloud][:riak_instances]

if riak_instances.length > 0
	leave_ring {}
end