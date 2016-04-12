node.override[:nginx][:worker_processes] = node[:cloud][:my_cpu]

if node[:cloud][:my_layer].nil?
	node.override[:cloud][:my_layer] = "nginx"
	Chef::Log.debug("nginx : this node is in layer #{node[:cloud][:my_layer]}") 
end

if node[:cloud][:provider] == "vagrant"
	node.override[:nginx][:disable_default_site] = false
end