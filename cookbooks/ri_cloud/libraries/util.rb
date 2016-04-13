module Rawiron
	module Util
	
		def self.setup?(messages)
			if messages.length != 1
				# when a new instance is created 
				# messages contains all apps
				# => SETUP event
			  return true
			else
			  return false
			end
		end

		def self.skip_application?(application_type)
			if application_type != 'other'
			  return true
			else
				return false
			end
		end

		def self.lookup_message_by(rawiron_config, application)
			rawiron_config[:deploy_delegate][application]
		end

		def self.urlencode(hashmap)
			return hashmap.map{|k,v| "#{k}=#{v}"}.join('&')
		end

		def self.deep_copy_to_hash(source)
		  copy_of_source = nil
		  if source.instance_of?(Chef::Node::ImmutableMash)
		    copy_of_source = source.to_hash
		  else
		    copy_of_source = Marshal.load(Marshal.dump(source))
		  end
		  copy_of_source
		end
	
	end
end