class PersonaDetails < ActiveRecord::Base
  set_table_name "persona_details"
  belongs_to :section
  validates_presence_of(:local_group, :kingdom)
  file_column :device, :magick => { :geometry => "120x120>" }

  def site
    section.site unless section == nil
  end

  def name
    site.name unless site == nil
  end

  def full_name
    result = String.new
    result += title unless title.blank?
    result += " " unless title.blank? || name.blank?
    result += name unless name.blank?
    return result
  end

  def title_options
    ["", "Lord", "Lady", "His Lordship", "Her Ladyship", "Sir", "Master", "Mistress", "Baron", "Baroness", "Viscount", "Viscountess", "Count", "Countess", "Earl", "Duke", "Duchess"]
  end

  def kingdom_options
    ["", "Lochac"]
  end

protected

  def before_save
    File.chmod(0644, self.device) unless self.device.blank?
  end

end
