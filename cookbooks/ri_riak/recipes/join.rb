Chef::Log.info("riak : join")

this_node = node[:cloud][:this_node_fqdn]
riak_instances = node[:cloud][:riak_nodes]

Chef::Log.debug("riak : this node private-ip is #{node['ipaddress']}")
Chef::Log.debug("riak : this node is #{this_node}")
Chef::Log.debug("riak : this node name is #{node['hostname']}")
# require 'json'
#Chef::Log.debug("node is #{node.to_json}")


if not Rawiron::Riak::ClusterStatus.alone?(riak_instances, this_node)
	if not Rawiron::Riak::ClusterStatus.cluster_ready?(riak_instances, this_node)
		ring_seed_node = Rawiron::Riak::ClusterStatus.pick_seed_node(riak_instances, this_node)
		
		if ring_seed_node
			join_ring do
				seed_node ring_seed_node
			end
		else
			Chef::Log.info("riak : could not select ring seed node")	
		end
	end
end