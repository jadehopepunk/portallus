
class Section < ActiveRecord::Base
  belongs_to :site
  belongs_to :section_type

  validates_presence_of(:heading, :position, :name, :section_type)
  validates_format_of(:name, :with => /^[a-z_0-9]*$/)
  validates_presence_of(:section_type, :message => 'must be selected from one of the available options')

  def validate
    if section_type != nil
      if !section_type.can_be_used_on?(site)
        errors.add(:section_type_id, "is not correct for this type of Portallus site.")
      end
    end
  end

  def validate_on_create
    if section_type != nil
      if !section_type.another_instance_allowed(site)
        errors.add(:section_type_id, "is not allowed. You can only have one of these sections per site.")
      end
    end
  end

  def record_id
    id
  end

  def component
    return section_type == nil ? nil : section_type.component
  end

  def move_forward
    self.parent.move_child_forward(self)
  end

  def move_backward
    self.parent.move_child_backward(self)
  end

  def add_child(new_section)
    if (new_section != nil)
      if (new_section.position != nil && new_section.position > 0)
        for index in 0...self.children.length
          section = self.children[index]
          if section.position > new_section.position
            next_section_index = index
            break
          end
        end
      else
        new_section.position = next_available_position
      end

      if (next_section_index == nil)
        self.children << new_section
      else
        self.children[next_section_index, 0] = new_section
      end

      new_section.parent = self
    end
  end

  def remove_child(child)
    children.delete(child)
  end

  def children
    load_children if @children == nil
    @children
  end

  def hierarchy_name
    if (parent != nil and !parent.is_root? and parent.name != '')
      parent_section_name = parent.hierarchy_name + '/'
    else
      parent_section_name = ''
    end
    parent_section_name + name
  end

  def before_validation_on_create
    set_name_from_heading
    set_position
  end

  def parent
    if nil == @parent
      unless self.is_root?
        if (nil == self.parent_section_id or 0 == self.parent_section_id)
          @parent = Section.new
          @parent.site_id = site_id
          @parent.is_root = true
        else
          @parent = Section.find(self.parent_section_id)
        end
      end
    end
    @parent
  end

  def parent=(new_value)
    @parent = new_value
    self.is_root = false

    if (nil != new_value) then
      self.parent_section_id = new_value.id
    end
  end

  def has_children
    self.children.length > 0
  end

  def self.find_with_name_array(search_name_array)
    Section.new_root.find_child_with_name_array(search_name_array)
  end

  def find_child_with_name_array(search_name_array)
    if search_name_array.length > 0
      this_result = find_with_name(search_name_array[0])

      if (nil != this_result)
        if this_result.has_children and search_name_array.length > 1
          remaining_array = search_name_array.slice(1..-1)
          better_result = this_result.find_child_with_name_array(remaining_array)
          this_result = better_result unless better_result == nil
        end
        return this_result
      end
    end
    nil
  end

  def name_array
    result = []

    unless self.is_root?
      unless nil == self.parent
        result = self.parent.name_array
      end

      result << self.name
    end
    result
  end

  def to_param
    name_array.join('/')
  end

  def url
    '/people/' + self.site.unique_name + '/' + to_param
  end

  def parent_section_id=(new_value)
    super(new_value)
    self.is_root = false
  end

  def is_root?
    @is_root
  end

  def self.new_root
    section = Section.new
    section.is_root = true
    section
  end

  def is_root=(new_value)
    @is_root = new_value
  end

  def breadcrumb_trail
    result = []

    unless self.is_root?
      unless nil == self.parent
        result = self.parent.breadcrumb_trail
      end

      result << self
    end

    result
  end

  def after_destroy
    Page.delete_all("section_id = '" + self.id.to_s + "'")
  end

  def trim_name_heirarchy_from_array(input_array)
    self.parent.trim_name_heirarchy_from_array(input_array) unless self.parent == nil
    if input_array[0] == self.name then input_array.shift end
    input_array
  end

  def is_or_contains_section_of_type(section_type)
    return true if self.section_type == section_type

    children.each do |child|
      return true if child.is_or_contains_section_of_type(section_type)
    end

    return false
  end

protected

  def before_destroy
    children.each { |section| section.destroy }
  end

  def name_exists_for_another_section(search_section)
    self.children.each{ |section| return true if section.name == search_section.name and section.id != search_section.id }
    false
  end

  def move_child_forward(section_to_move)
    i = self.children.index(section_to_move)
    if (i != nil and i+1 != self.children.length)
      this_section = self.children[i]
      next_section = self.children[i+1]
      next_position = next_section.position

      next_section.position = self.children[i].position
      this_section.position = next_position

      if !next_section.valid? || !this_section.valid?
        return false
      end

      return false unless next_section.save
      return false unless this_section.save
    end
    true
  end

  def move_child_backward(section_to_move)
    i = self.children.index(section_to_move)
    if (i != nil and i-1 >= 0)
      this_section = self.children[i]
      previous_section = self.children[i-1]
      previous_position = previous_section.position

      previous_section.position = self.children[i].position
      return false unless previous_section.save
      this_section.position = previous_position
      return false unless this_section.save
    end
    true
  end

  def before_save
    self.parent_section_id = 0 if nil === self.parent_section_id
  end

private

  def find_with_name (search_name)
    self.children.each { |section| return section if section.name == search_name }
    return nil
  end

  def set_name_from_heading
    self.name = self.heading.downcase.gsub(/[^a-z_0-9]/, '').slice(0, 30) unless nil == self.heading

    while (name_invalid)
      suffix_index = self.name.index(/[0-9]*$/)
      suffix = self.name[suffix_index..-1].to_i
      suffix = 1 if suffix < 1
      suffix += 1

      self.name.sub!(/[0-9]*$/, suffix.to_s)
    end
  end

  def name_invalid
    unless nil == self.parent
      if (self.parent.name_exists_for_another_section(self))
        return true
      end
    end

    self.name == 'new'
  end

  def load_children
    @children = []

    condition = is_root? ? ["(parent_section_id IS NULL or parent_section_id = 0) AND site_id = ?", self.site_id] : ["parent_section_id = ? AND site_id = ?", id, self.site_id]
    sections = Section.find(:all, :conditions => condition)

    for section in sections
      add_child(section)
    end
  end

  def next_available_position
    if (self.children.length > 0)
      return self.children.last.position + 1
    else
      return 1
    end
  end

  def set_position
    if nil == self.position or 0 == self.position then
      parent.add_child(self) unless nil == parent
    end
  end

end
