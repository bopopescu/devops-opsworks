define :uwsgi_site, :enable => true do

  if params[:enable]
    execute "create sym link from apps-available to apps-enabled" do
      command "ln -s #{node[:uwsgi][:dir]}/apps-available/#{params[:name]}.ini #{node[:uwsgi][:dir]}/apps-enabled/#{params[:name]}.ini"
      #notifies :reload, resources(:service => "uwsgi")
      not_if do
        ::File.symlink?("#{node[:uwsgi][:dir]}/sites-enabled/#{params[:name]}.ini") or
        ::File.symlink?("#{node[:uwsgi][:dir]}/sites-enabled/000-#{params[:name]}.ini")
      end
      only_if do ::File.exists?("#{node[:uwsgi][:dir]}/sites-available/#{params[:name]}.ini") end
    end
  else
    execute "remove sym link from apps-enabled" do
      command "rm -f #{node[:uwsgi][:dir]}/apps-enabled/#{params[:name]}.ini"
      #notifies :reload, resources(:service => "uwsgi")
      only_if do ::File.symlink?("#{node[:uwsgi][:dir]}/sites-enabled/#{params[:name]}.ini") end
    end
  end

end
