class Persona < Site
  after_create :add_default_sections

  def name
    society_name
  end

  def details
    if nil == @details
      if about_persona_section
        @details = PersonaDetails.find(:first, :conditions => ['section_id = ?', about_persona_section.id]);
      end

      if nil == @details
        @details = PersonaDetails.new
        @details.section = about_persona_section
      end
    end

    @details
  end

protected

  def about_persona_section
    @about_persona_section = find_singleton_section(about_persona_section_type) if nil == @about_persona_section
    @about_persona_section
  end

  def about_persona_section_type
    SectionType.find(:first, :conditions => "name = 'AboutPersona'")
  end

  def add_default_sections
    about_me = Section.new
    about_me.name = "aboutme"
    about_me.heading = "About Me"
    about_me.section_type = about_persona_section_type
    add_section(about_me)

    about_me.create

    relationships = Section.new
    relationships.name = "relationships"
    relationships.heading = "Relationships"
    relationships.section_type = SectionType.find(:first, :conditions => "name = 'Relationships'")
    add_section(relationships)

    relationships.create
  end

end
