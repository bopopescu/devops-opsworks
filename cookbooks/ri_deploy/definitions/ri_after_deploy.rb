define :ri_after_deploy do
	Chef::Log.info("deploy : after_deploy")

	application = params[:app]


	directory "#{node[:rawiron][:web_root]}" do
	  user "deploy"
	  group node[:rawiron][:web_group]
	  mode 0755
	  action :create
	  not_if { File.exists?("#{node[:rawiron][:web_root]}") }
	end

	execute "create sym link to deploy::deploy_to dir" do
	  command "ln -s /srv/www/#{application}/current  #{node[:rawiron][:web_root]}/#{application}"
	  action :run
	  not_if { File.symlink?("#{node[:rawiron][:web_root]}/#{application}") }
	end

end