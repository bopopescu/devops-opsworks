def delegate_gatling(opsworks_event, message, application, deploy)
	case message
	when "load_testing"
		Chef::Log.debug("opsworks : call #{opsworks_event.to_s} load_testing for application #{application}")
		ri_deploy_gatling do
			cookbook "ri_gatling"
			deploy_data deploy
			app application
		end
	when "load_scenarios"
		Chef::Log.debug("opsworks : call #{opsworks_event.to_s} load_scenarios for application #{application}")
		ri_deploy_scenarios do
			cookbook "ri_gatling"
			deploy_data deploy
			app application
		end
	else
		Chef::Log.debug("opsworks : skipping application #{application}")
	end
end

def delegate_gatling_setup(message, application, deploy)
	delegate_gatling(:setup, message, application, deploy)
end

def delegate_gatling_deploy(message, application, deploy)
	delegate_gatling(:deploy, message, application, deploy)
end



def delegate_django_setup(message, application, deploy)
	case message
	when "release"
		Chef::Log.info("opsworks : call deploy release for application #{application}")
		deploy_release do
			deploy_data deploy
			app application
		end
	else
		Chef::Log.info("opsworks : skipping application #{application} as it is not a release")
	end
end


def delegate_django_init_deploy(message, application, deploy)
	case message
	when "init_data"
		Chef::Log.info("opsworks : call init data")
		init_data do
		end
	when "init_static"
		Chef::Log.info("opsworks : call init static")
		init_static do
		end
	
	else
		Chef::Log.info("opsworks : skipping message #{message}")
	end
end


def delegate_django_maint_deploy(message, application, deploy)
	case message
	when "release"
		Chef::Log.info("opsworks : call deploy release for application #{application}")
		deploy_release do
			deploy_data deploy
			app application
		end
	
	else
		delegate_django_init_deploy(message, application, deploy)	
	end
end


def delegate_django_app_setup(message, application, deploy)
	delegate_django_setup(message, application, deploy)
end


def delegate_django_app_deploy(message, application, deploy)
	case message
	when "release"
		Chef::Log.debug("opsworks : call deploy release for application #{application}")
		deploy_release do
			deploy_data deploy
			app application
		end
		include_recipe "ri_uwsgi::restart"
		
	when "restart_uwsgi"
		Chef::Log.debug("opsworks : call restart uwsgi")
		include_recipe "ri_uwsgi::restart"
	when "restart_nginx"
		Chef::Log.debug("opsworks : call restart nginx")
		include_recipe "ri_nginx::restart"
	when "restart_all"
		Chef::Log.debug("opsworks : call restart uwsgi and nginx")
		include_recipe "ri_uwsgi::restart"
		include_recipe "ri_nginx::restart"
	
	else
		Chef::Log.debug("opsworks : skipping message #{message}")
	end
end


def delegate_nginx_deploy(message, application, deploy)
	case message	
	when "restart_nginx"
		Chef::Log.debug("opsworks : call restart nginx")
		include_recipe "ri_nginx::restart"
	when "restart_all"
		Chef::Log.debug("opsworks : call restart nginx")
		include_recipe "ri_nginx::restart"
	
	else
		Chef::Log.debug("opsworks : skipping message #{message}")
	end
end



Chef::Log.info("opsworks : deploy delegate")

layers = node[:cloud][:layers]
this_instance = node[:cloud][:instance]
this_node = node[:cloud][:this_node]
my_layer = node[:cloud][:my_layer]
# require 'json'
#Chef::Log.debug("node is #{node.to_json}")

rawiron_config = node[:rawiron]
applications = node[:deploy]

Chef::Log.debug("opsworks : delegate received #{applications.length} message(s)")

isSetup = false
if Rawiron::Util.setup?(applications)
	isSetup = true
end


applications.each do |application, deploy|
	if Rawiron::Util.skip_application?(deploy[:application_type])
		Chef::Log.debug("opsworks : skipping application #{application}")
		next
	end
	message = Rawiron::Util.lookup_message_by(rawiron_config, application)
	Chef::Log.debug("opsworks : message is #{message}")

	if isSetup
		if my_layer == "djangoapp"
			Chef::Log.info("opsworks : app setup delegate")
			delegate_django_app_setup(message, application, deploy)

		elsif my_layer == "db-master"
			if node[:rawiron][:stack][:db_servers].empty? or
				 node[:rawiron][:stack][:db_servers][:layer] != "app"
				Chef::Log.info("opsworks : app setup delegate")
				delegate_django_app_setup(message, application, deploy)
			end

		elsif my_layer == "gatling"
			Chef::Log.info("opsworks : gatling setup delegate")
			delegate_gatling_setup(message, application, deploy)

		else
			Chef::Log.info("opsworks : no setup delegate found")
		end

	else
		if my_layer == "djangoapp"
			if node[:rawiron][:stack][:db_servers][:layer] == "app"
				Chef::Log.info("opsworks : init deploy delegate")
				delegate_django_init_deploy(message, application, deploy)
			end
			Chef::Log.info("opsworks : app deploy delegate")
			delegate_django_app_deploy(message, application, deploy)

		elsif my_layer == "nginx"
			Chef::Log.info("opsworks : nginx deploy delegate")
			delegate_nginx_deploy(message, application, deploy)

		elsif my_layer == "db-master"
			if node[:rawiron][:stack][:db_servers].empty? or 
				 node[:rawiron][:stack][:db_servers][:layer] != "app"
				Chef::Log.info("opsworks : maint deploy delegate")
				delegate_django_maint_deploy(message, application, deploy)
			end

		elsif my_layer == "gatling"
			Chef::Log.info("opsworks : gatling deploy delegate")
			delegate_gatling_deploy(message, application, deploy)

		else
			Chef::Log.info("opsworks : no deploy delegate found")			
		end
	end
end