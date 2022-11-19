class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  validates :name, :presence => true, :length => { :minimum => 5}

  protected

  def generate_token
    self.token = loop do
      safe_token = SecureRandom.urlsafe_base64(nil, false)
      break safe_token unless Application.exists?(token: safe_token)
    end
  end
end
