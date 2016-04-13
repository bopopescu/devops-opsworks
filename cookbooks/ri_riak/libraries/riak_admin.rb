module Rawiron
module Riak


module ClusterPlan
	def self.parse_status_from(out)
		if out.start_with?("There are no staged changes")
			return false
		else
			return true
		end
	end

	def self.clusterplan(out)
		response = {}
		response[:status] = parse_status_from(out)
		return response
	end

	def self.take_down(server_list)
		if not server_list
			return
		end
		server_list.each do |server|
			%x[/usr/local/riak/bin/riak-admin down #{server}]
			%x[/usr/local/riak/bin/riak-admin cluster force-remove #{server}]
		end
	end

	def self.staged_changes?(cluster_plan)
		return cluster_plan[:status]
	end

	def self.commit_staged()
		%x[/usr/local/riak/bin/riak-admin cluster commit]
	end
end


def self.render(response)
	return response
end


Test_ringready_true_out = "TRUE All nodes agree on the ring ['riak@172.31.18.171','riak@172.31.20.46']"
Test_ringready_false_out = "FALSE ['riak@172.31.20.46'] down.  All nodes need to be up to check."
Test_ringready_unexpected_out = ""

def self.ringready
	ringready_out = %x[/usr/local/riak/bin/riak-admin ringready]
	ringready_out.gsub!(/\n +/, "")
	ringready_out.chomp!
	Chef::Log.debug("riak : ring ready output is #{ringready_out.inspect}")

	ready_response = Riak.render(Riak::RingReady.ringready(ringready_out))
	return ready_response
end


Test_clusterplan_none_out = "There are no staged changes"
Test_clusterplan_staged_out = <<-eos
	=============================== Staged Changes ================================
	Action         Details(s)
	-------------------------------------------------------------------------------
	force-remove   'riak@172.31.20.46'
	-------------------------------------------------------------------------------

	WARNING: All of 'riak@172.31.20.46' replicas will be lost

	NOTE: Applying these changes will result in 1 cluster transition

	###############################################################################
	                         After cluster transition 1/1
	###############################################################################

	================================= Membership ==================================
	Status     Ring    Pending    Node
	-------------------------------------------------------------------------------
	valid     100.0%      --      'riak@172.31.18.171'
	-------------------------------------------------------------------------------
	Valid:1 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

	WARNING: Not all replicas will be on distinct nodes

	Partitions reassigned from cluster changes: 8
	  8 reassigned from 'riak@172.31.20.46' to 'riak@172.31.18.171'
	eos

def self.force_remove(ready_response)
	Riak::ClusterPlan.take_down(ready_response[:servers_down])

	clusterplan_out = %x[/usr/local/riak/bin/riak-admin cluster plan]
	clusterplan_out.chomp!

	clusterplan_response = Riak.render(Riak::ClusterPlan.clusterplan(clusterplan_out))
	return clusterplan_response
end


def self.commit(clusterplan_response)
	if Riak::ClusterPlan.staged_changes?(clusterplan_response)
		Riak::ClusterPlan.commit_staged()
	end
end


end
end