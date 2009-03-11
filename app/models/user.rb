require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern.
class User < ActiveRecord::Base
  has_many(:sites, :order => "type ASC")

  validates_uniqueness_of(:email, :on => :create)
  validates_presence_of(:email)
  validates_presence_of :password, :if => :validate_password?
  validates_confirmation_of :password, :if => :validate_password?
  validates_length_of :password, { :minimum => 5, :if => :validate_password? }
  validates_length_of :password, { :maximum => 40, :if => :validate_password? }

  after_validation(:crypt_password)
  after_save('@new_password = false')

  @@salt = 'portallus_server001'
  cattr_accessor :salt
  attr_accessor :new_password

  def initialize(attributes = nil)
    super
    @new_password = false
  end

  # Authenticate a user.
  #
  # Example:
  # @user = User.authenticate('bob', 'bobpass')
  #
  def self.authenticate(email, pass)
    find_first(["email = ? AND password = ?", email, User.sha1(pass)])
  end

  def set_password(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation
    @new_password = true
  end

  def default_person_param
    default_person.to_param unless default_person == nil
  end

  def default_person
    sites.length > 0 ? sites[0] : nil
  end

protected

  # Apply SHA1 encryption to the supplied password.
  # We will additionally surround the password with a salt
  # for additional security.
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{@@salt}--#{pass}--")
  end

  # Before saving the record to database we will crypt the password
  # using SHA1.
  # We never store the actual password in the DB.
  def crypt_password
      if @new_password
      self.password = self.class.sha1(password)
      @new_password = false
    end
  end

  def validate_password?
    @new_password
  end

end
