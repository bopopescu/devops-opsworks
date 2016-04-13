define :leave_ring do
	Chef::Log.debug("leave riak ring")
	
	execute "stage leave" do
	  command "./riak-admin cluster leave"
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

	Chef::Log.debug("leave ring committed")
end