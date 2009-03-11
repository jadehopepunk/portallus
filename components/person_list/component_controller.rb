
class PersonList::ComponentController < ApplicationController
	uses_component_template_root
	layout nil

	def index
	  @people = Person.find_all
	end


private


end
