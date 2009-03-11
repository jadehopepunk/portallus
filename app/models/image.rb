class Image < ActiveRecord::Base
  file_column :file
  belongs_to :site

  validates_presence_of :file, :message => "should not be blank."

protected

  def before_save
    File.chmod(0644, self.file)
  end

end
