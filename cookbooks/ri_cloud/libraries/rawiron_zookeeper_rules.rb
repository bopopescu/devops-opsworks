require 'json'


module Rawiron
module Zookeeper

module LoadBalancers
	def self.does_balance_for?(lbs, lb_layer, balanced_layer)
		if not lbs
			return false
		end

		if lbs.key?(lb_layer) and lbs[lb_layer] == balanced_layer
	   		return true
	   	else
	   		false
	   	end
	end
end

end # Zookeeper
end # Rawiron