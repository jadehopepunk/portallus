
module ActionView
  module Helpers
    module FormHelper
      
		def blext_area(object, method, options = {})
			InstanceTag.new(object, method, self).to_text_area_tag(options)
		end
      
    end

  end
end
