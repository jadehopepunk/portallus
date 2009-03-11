class SectionType < ActiveRecord::Base

  def component
    name
  end

  def can_be_used_on?(site)
    return site != nil && is_allowed_for_site_type_name(site.type_name)
  end

  def another_instance_allowed(site)
    return !(self.is_singleton && site.contains_section_of_type(self))
  end

  def self.find_all_user_createable(site_type_name, parent_section)
    return [parent_section.section_type] if parent_section != nil && parent_section.section_type != nil && parent_section.section_type.is_hierarchical
    SectionType.find(:all, :conditions => ["(is_singleton is NULL || is_singleton = 0) && is_user_creatable = 1 && (site_type IS NULL or site_type = ?)", site_type_name])
  end

private

  def is_allowed_for_site_type_name(site_type_name)
    return !site_type_name.blank? && (self.site_type.blank? || self.site_type == site_type_name)
  end

end
