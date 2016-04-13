Chef::Log.info("gatling : deploy nginx virtual server to serve load test results")  

template "gatling_results.conf" do
  path "/etc/nginx/sites-available/gatling_results.conf"
  source "nginx_results.erb"
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :app_domain => "#{node['ipaddress']}",
    :app_dir => "/srv/www/gatling/current/results/"
  )
end

execute "create sym link from apps-available to apps-enabled" do
  command "ln -s /etc/nginx/sites-available/gatling_results.conf /etc/nginx/sites-enabled/gatling_results.conf"
  action :run
  not_if { ::File.exists?("/etc/nginx/sites-enabled/gatling_results.conf") }
end

execute "remove default from apps-enabled" do
  command "rm -f /etc/nginx/sites-enabled/default"
  action :run
end
