define :uwsgi_service do
	if params[:action] == "start"
		execute "uwsgi #{params[:name]} start" do
	      command "/etc/init.d/uwsgi-#{params[:name]} start"
	    end		
	elsif params[:action] == "reload"
		execute "uwsgi #{params[:name]} reload" do
	      command "/etc/init.d/uwsgi-#{params[:name]} reload"
	    end
	elsif params[:action] == "stop"
		execute "uwsgi #{params[:name]} stop" do
	      command "/etc/init.d/uwsgi-#{params[:name]} stop"
	    end
	end
end
