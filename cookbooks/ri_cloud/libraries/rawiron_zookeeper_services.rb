module Rawiron
module Zookeeper


module Services
  SERVICE_ATTRIBUTE = ["sql", "nosql", "restful", "default"]

  def self.services_requested_with_definitions(rawiron_config, request)
	  services_request = Rawiron::Util.deep_copy_to_hash(request)
	  defined_service_groups = Rawiron::Util.deep_copy_to_hash(rawiron_config[:define][:service_groups])
	  defined_services = Rawiron::Util.deep_copy_to_hash(rawiron_config[:define][:services])

	  if services_request.nil? or defined_service_groups.nil? or defined_services.nil?
	    Chef::Log.error("zookeeper : services cannot be processed: data is nil")
	    return {}, {}
	  end
	  Chef::Log.debug("zookeeper : classes are #{services_request.class} #{defined_service_groups.class} #{defined_services.class}")
	  
	  
	  merged_services = {}
	  services_request.each do |service_name, service_desc|
	    Chef::Log.debug("zookeeper : #{service_name} #{service_desc}")
	    if not defined_services.include?(service_name) and
	      defined_service_groups.include?(service_name)
	      merged_services.merge!(defined_service_groups[service_name])
	    else
	      merged_services.merge!({service_name => service_desc})
	    end
	  end

	  merged_services.each do |service_name, service_desc|
	  	if not service_desc
    	  Chef::Log.debug("zookeeper : delete service: #{service_name}")
	      merged_services.delete(service_name)
	    end
	  end
	  services_request = merged_services

	  require 'json'
	  Chef::Log.debug("zookeeper : services_request after merge are: #{services_request.to_json}")


	  services = {}
	  service_definitions = {}

	  services_request.each do |service_group, service_impl_requested|
	    service_or_service_group = defined_services[service_group]
	    service_or_service_group.each do |service_id, service_impl|
	      if SERVICE_ATTRIBUTE.include?(service_id)
	        services.merge!({service_group => service_impl_requested})
	        service_definitions.merge!({service_group => defined_services[service_group]})
	        break
	      else
	        services.merge!({"#{service_group}:#{service_id}" => service_impl_requested})
	        service_definitions.merge!({"#{service_group}:#{service_id}" => defined_services[service_group][service_id]})
	      end
	    end
	  end

	  require 'json'
	  Chef::Log.debug("zookeeper : services are #{services.to_json}")
	  Chef::Log.debug("zookeeper : service definitions are #{service_definitions.to_json}")


	  services.each do |id, impl|
	  	if impl == "default"
	      impl = service_definitions[id]['default']
	      services[id] = impl
	    end
	    if service_definitions[id][impl].nil?
	      services.delete(id)
	    end
	  end

	  services.each do |id, impl|
	    Chef::Log.debug("zookeeper : service iteration: #{id} #{impl}")
	    impl = service_definitions[id]['default'] if impl == "default"
	    plugin_command = service_definitions[id][impl]
	    if plugin_command.instance_of?(Chef::Node::ImmutableMash)
	      plugin_command = plugin_command.to_json
	    end
	    Chef::Log.debug("zookeeper : service iteration: #{id} #{impl} #{plugin_command}" )
	  end

	  return services, service_definitions
	end

end


end # Zookeeper
end # Rawiron