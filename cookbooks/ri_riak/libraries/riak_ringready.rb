module Rawiron
module Riak

module RingReady
	def self.parse_status_from(out)
		if out.start_with?("TRUE")
			return true
		elsif out.start_with?("FALSE")
			return false
		end
	end

	def self.words_of(out)
		return out.split(' ')
	end

	def self.servers_list(servers_word)
		if not servers_word
			return []
		end
		servers_word.delete! "["
		servers_word.delete! "]"
		servers_word.delete! "'"
		return servers_word.split(",")
	end

	def self.servers_listed_down(first_line)
		servers_word = first_line[1]
		return servers_list(servers_word)
	end

	def self.servers_listed_up(first_line)
		servers_word = first_line[7]
		return servers_list(servers_word)
	end

	def self.ringready(ringready_out)
		response = {}
		response[:status] = parse_status_from(ringready_out)

		if response[:status]
			response[:first_line] = words_of(ringready_out)
			response[:servers_up] = servers_listed_up(response[:first_line])			
		elsif
			response[:first_line] = words_of(ringready_out)
			response[:servers_down] = servers_listed_down(response[:first_line])
		end
		return response
	end
end

end
end