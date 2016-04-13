require 'json'


module Rawiron
module Zookeeper


module VirtualMachine
	
	OS_REQUIRES_GB = 1

	@@aws_instance_types = {
	'c1.medium' => {:cpu => 2, :ecu => 5, :memory => 1.7, :ssd => false},
	'c1.xlarge' => {:cpu => 8, :ecu => 20, :memory => 7, :ssd => false},

	'c3.large' => {:cpu => 2, :ecu => 7, :memory => 3.75, :ssd => true},
	'c3.xlarge' => {:cpu => 4, :ecu => 14, :memory => 7, :ssd => true},
	'c3.2xlarge' => {:cpu => 8, :ecu => 28, :memory => 15, :ssd => true},
	'c3.4xlarge' => {:cpu => 16, :ecu => 55, :memory => 30, :ssd => true},

	'cc2.8xlarge' => {:cpu => 32, :ecu => 88, :memory => 60.5, :ssd => false},	
	'cr1.8xlarge' => {:cpu => 32, :ecu => 88, :memory => 244, :ssd => true},
	'hi1.4xlarge' => {:cpu => 16, :ecu => 35, :memory => 60.5, :ssd => true},
	}

	def self.ecu(type_name)
		@@aws_instance_types[type_name][:ecu]
	end
	
	def self.cpu(type_name)
		@@aws_instance_types[type_name][:cpu]
	end	
	
	def self.memory(type_name)
		@@aws_instance_types[type_name][:memory]
	end

	def self.user_memory(type_name)
		((self.memory(type_name) - OS_REQUIRES_GB) * 1024).to_int
	end

	def self.memory_by_percent(type_name, percentage)
		if (percentage > 1 or percentage < 0)
			percentage = 0.5
		end
		((self.memory(type_name) - OS_REQUIRES_GB) * 1024 * percentage).to_int
	end

	module Nic
		def self.private_ip(config)
			"#{config['ipaddress']}" 
		end
		
		def self.public_ip(config, layers, shortname)
			instances = Rawiron::Zookeeper::Layers.get_instances(layers, shortname)
			if instances.length > 0
				instances.each do |instance_name, instance|
					if config['hostname'] == instance_name
						return instance[:ip]
					end
				end
			end
			return nil
		end
		
		def self.fqdn(config)
			"#{config['hostname']}.#{config['fathom']['fqdn']}" 
		end
	end
end

end # Zookeeper
end # Rawiron