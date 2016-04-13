define :join_ring do
	ring_seed_node = params[:seed_node]

	Chef::Log.info("riak : join riak ring")
	Chef::Log.debug("riak : seed node selected #{ring_seed_node}")

	execute "stage join" do
	  command "./riak-admin cluster join riak@#{ring_seed_node}"
	  cwd "/usr/local/riak/bin"
	  action :run
	end

	execute "display plan" do
	  command "./riak-admin cluster plan"
	  cwd "/usr/local/riak/bin"
	  action :run
	end

	execute "commit" do
	  command "./riak-admin cluster commit"
	  cwd "/usr/local/riak/bin"
	  action :run
	end
	Chef::Log.info("riak : join ring committed")
end