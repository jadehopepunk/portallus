
class ActiveRecord::Base
	@@mock_results = Hash.new
	@@mock_count_results = Hash.new
	@@mock_allow_unexpected = false
	
	def self.mock_find(*args)
		if !@@mock_allow_unexpected && @@mock_results.has_key?(args.inspect) then
			fail "mock_find called without an expection being set for key: " + args.inspect
		end	
		return @@mock_results[args.inspect]
	end

	def self.mock_set_result(result, arg_string)
		@@mock_results[arg_string] = result 
	end

	def self.mock_allow_unexpected=(value)
		@@mock_allow_unexpected = value
	end

	def self.mock_count(*args)
		if @@mock_count_results.has_key?(args.inspect) then
			return @@mock_count_results[args.inspect]
		else
			if !@@mock_allow_unexpected then
				fail "mock_count called without an expection being set for key: " + args.inspect
			end
		end
		return 0
	end

	def self.mock_count_set_result(result, arg_string)
		@@mock_count_results[arg_string] = result
	end

end

class FindManager
	def self.setup
		ActiveRecord::Base.class_eval <<-END 
			class <<self
				alias_method :original_find, :find
				alias_method :find, :mock_find

				alias_method :original_count, :count
				alias_method :count, :mock_count
			end
		END
	end

	def self.teardown
		ActiveRecord::Base.class_eval <<-END
			class <<self
				alias_method :find, :original_find
				alias_method :count, :original_count
			end
		END
	end

	def self.set_find_result(result, *args)
		ActiveRecord::Base::mock_set_result(result, args.inspect)
	end

	def self.set_count_result(result, *args)
		ActiveRecord::Base::mock_count_set_result(result, args.inspect)
	end

	def self.allow_unexpected=(value)
		ActiveRecord::Base::mock_allow_unexpected = value
	end
		
end
