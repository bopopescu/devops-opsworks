include_recipe "nginx::service"

=begin
service "nginx" do
  action :restart
end
=end

execute "restart-nginx" do
	command "sudo service nginx restart"
	action :run
	user "ubuntu"
end