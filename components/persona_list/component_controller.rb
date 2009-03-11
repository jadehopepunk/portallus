
class PersonaList::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  def index
    active_section
    @people = Person.find_all
    @personae = Persona.find_all
  end


private


end
