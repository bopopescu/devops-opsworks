module Rawiron
module Riak


module ClusterStatus

	def self.alone?(riak_instances, this_node)
		if riak_instances.length == 0
			return true
		end

		if riak_instances.length == 1
			riak_instances.take(1).each do |instance|
				if instance == this_node
					return true
				end
			end
		end
		
		Chef::Log.debug("riak : there are other nodes in the cluster")
		return false
	end


	def self.pick_seed_node(riak_instances, this_node)
		riak_seed_node = nil
		pick_first_from_sorted = riak_instances.sort
		pick_first_from_sorted.each do |instance|
			if instance == this_node
				next
			else
				riak_seed_node = instance
				break
			end
		end
		return riak_seed_node
	end


	def self.cluster_ready?(riak_instances, this_node)
		ready_response = Rawiron::Riak.ringready()
		Chef::Log.debug("riak : ring ready #{ready_response.to_json}")
		
		if not ready_response[:status]
			Chef::Log.debug("riak : ring ready FALSE")
			return false
		end

		if not ready_response[:servers_up].include? "riak@#{this_node}"
			Chef::Log.debug("riak : #{this_node} not included in servers_up")
			return false
		end
		
		riak_instances.each do |instance|
			if not ready_response[:servers_up].include? "riak@#{instance}"
				Chef::Log.debug("riak : #{instance} not included in servers_up")
				return false
			end
		end
		
		Chef::Log.debug("riak : all nodes joined the cluster")
		return true
	end
end

end
end