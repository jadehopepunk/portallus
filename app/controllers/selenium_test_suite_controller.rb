
class SeleniumTestSuite < Object

	def get_test(test)
		setup
		eval(test)
		tear_down
		
		@buffer
	end


protected

	def open(location)
		action("open", location, nil)
	end
	
	def type(field, value)
		action("type", field, value)
	end
	
	def clickAndWait(field)
		action("clickAndWait", field, nil)
	end
	
	def click(field)
		action("click", field, nil)
	end
	
	def assertTextNotPresent(value)
		action("assertTextNotPresent", value, nil)
	end
	
	def assertTextPresent(value)
		action("assertTextPresent", value, nil)
	end
	
	def assertLocation(location)
		action("assertLocation", location, nil)
	end
	
	def assertText(element, text)
		action("assertText", element, text)		
	end
	
	def setup
	end
	
	def tear_down
	end

private

	def action(actionName, target, parameter)
		@buffer = Array.new if (@buffer == nil)
		@buffer << {:action => actionName, :target => target, :parameter => parameter}		
	end
end

class SeleniumTestSuiteController < ApplicationController
	@@base_test_path = "test/selenium/"

	def index
		@tests = Array.new
		base_test_directory.entries.each do |filename|
			if !starts_with_dot(filename) && ends_with_tests(filename)
				case file_extension(filename)
					when "html"
						@tests << {
							:link => url_for_test(file_name_without_extension(filename)), 
							:name => test_name_without_prefix(filename)}
					when "rb"
						require_dependency(@@base_test_path + filename)
						suite = eval(class_name(filename)).new
						suite.public_methods.each do |method|
							if (method =~ /^test_/) then
								@tests << {
									:link => url_for(:action => "show_test", :file => file_name_without_extension(filename), :test => method), 
									:name => test_name_without_prefix(method)}
							end
						end
				end
			end
		end
	end
	
	def show_test
		@name = @params[:file]
		@filename = test_filename(@name)
		@title = underscores_to_words(@name)
		
		case file_extension(@filename)
			when "html"
				render_file(@@base_test_path + @filename) 
			when "rb"
				require_dependency(@@base_test_path + @filename)
				suite = eval(class_name(@filename)).new
				@title = underscores_to_words(@params[:test])
				@tests = suite.get_test(@params[:test])
		end
	end
	
private

	def test_filename(name)
		base_test_directory.entries.each do |filename|
			if file_name_without_extension(filename) == name
				return filename
			end
		end
		return nil
	end
	
	def test_name(filename)
		underscores_to_words(file_name_without_extension(filename))
	end
	
	def test_name_without_prefix(filename)
		underscores_to_words(file_name_without_extension(filename)).slice(5..-1)
	end
	
	def class_name(filename)
		test_name(filename).gsub(/ /, '')
	end
	
	def underscores_to_words(value)
		result = value.gsub(/_/, ' ')
		result.gsub(/\b\w/) { $&.upcase }
	end
	
	def file_name_without_extension(filename)
		filename.split('.')[0]
	end
	
	def file_extension(filename)
		filename.split('.')[1]
	end

	def url_for_test(name)
		url_for(:action => 'show_test', :file => name)
	end

	def starts_with_dot(string)
		return string =~ /^\./
	end

	def ends_with_tests(string)
		return string =~ /tests\.?.*$/
	end

	def base_test_directory
		Dir.new(@@base_test_path)
	end

end
