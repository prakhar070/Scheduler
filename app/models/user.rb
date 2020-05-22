class User < ApplicationRecord
    has_secure_password 
    has_many :interviews, :foreign_key => "interviewer_id"
    belongs_to :interview

     #validations added
     validates :firstname, presence: true, length: {minimum: 2}
     validates :lastname, presence: true, length: {minimum: 2}
     validates :password, presence: true, length: { minimum: 8 }
     validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP}
end
