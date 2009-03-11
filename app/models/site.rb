
class Site < ActiveRecord::Base
  has_many :sections
  belongs_to :user
  file_column :picture, :magick => { :geometry => "150x150>", :versions => { "thumb" => "80x80" } }

  validates_presence_of(:user)
  validates_associated(:user, :message => "Error: You can only create one Person website for your account.")

  def root_section
    section = Section.new
    section.is_root = true
    section.site = self

    section
  end

  def type_name
    self[:type]
  end

  def find_first_section(name_array)
    root_section.find_child_with_name_array(name_array)
  end

  def can_be_administered_by?(user)
    (nil != user and user == self.user)
  end

  def update_unique_name
    if !name.blank? then
      self.unique_name = name.downcase.gsub(/[^a-z]/, '')
      while Person.count(["unique_name = ?", unique_name]) > 0 do
        self.unique_name.sub!(/\d*$/) { |match| (match.to_i + 1).to_s }
      end
    end
  end

  def to_param
    unique_name
  end

  def contains_section_of_type(section_type)
    sections.each do |section|
      return true if section.is_or_contains_section_of_type(section_type)
    end unless section_type == nil

    return false
  end

  def add_section(new_section)
    root_section.add_child(new_section)
    new_section.site = self
  end

protected

  def find_singleton_section(section_type)
    Section.find(:first, :conditions => ["site_id = ? and section_type_id = ?", self.id, section_type.id])
  end

  def before_save
    File.chmod(0644, self.picture) unless self.picture.blank?
  end

end
