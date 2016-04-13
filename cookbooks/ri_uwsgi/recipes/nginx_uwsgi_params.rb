remote_file "#{node[:uwsgi][:app_root]}/uwsgi_params" do
  source "https://github.com/nginx/nginx/blob/master/conf/uwsgi_params"
end