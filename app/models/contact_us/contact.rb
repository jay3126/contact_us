class ContactUs::Contact
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :email, :message, :name, :subject, :website

  validates :email,   :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
                      :presence => true
  validates :message, :presence => true
  validates :name,    :presence => {:if => Proc.new{ContactUs.require_name}}
  validates :subject, :presence => {:if => Proc.new{ContactUs.require_subject}}
  validates :website, :presence => {:if => Proc.new{ContactUs.require_website}}

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def save
    if self.valid?
      ContactUs::ContactMailer.contact_email(self).deliver
      return true
    end
    return false
  end
  
  def persisted?
    false
  end

end
