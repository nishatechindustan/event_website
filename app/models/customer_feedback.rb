class CustomerFeedback < ApplicationRecord
    validates :name, :description, :email,  presence: true
    validates_uniqueness_of :email
    validates_format_of  :email, :with  => Devise.email_regexp
end
