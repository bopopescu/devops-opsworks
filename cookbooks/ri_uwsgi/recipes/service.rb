service "uwsgi" do
	# exit code == 0 in case restart, start, .. [fail]
	supports :start => true, :stop => true, :restart => true, :status => false, :reload => true
	action :nothing
end