class Contact < ApplicationRecord
    validates :first_name, :last_name, :email,  presence: true
    validates_uniqueness_of :email, message: 'Your Request has been  already submitted'
    validates_format_of  :email, :with  => Devise.email_regexp
end
