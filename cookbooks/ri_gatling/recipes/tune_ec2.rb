Chef::Log.info("gatling : tune net")

execute "tune net" do
  cwd "#{node[:gatling][:app_root]}"
  command <<-EOH
		sudo sysctl -w net.core.rmem_max="16777216" 
		sudo sysctl -w net.core.wmem_max="16777216"  
		sudo sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216"  
		sudo sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216"  
		sudo sysctl -w net.ipv4.tcp_no_metrics_save=1
  EOH
end