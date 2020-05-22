class User < ApplicationRecord
  has_secure_password
  #a user has many interviews, identified by foreign_key interviewer_id
  has_many :interviews_created, :foreign_key => "interviewer_id", :class_name => "Interview"
  has_and_belongs_to_many :interviews_participated, :class_name => "Interview"

  #validations added
  validates :firstname, presence: true, length: { minimum: 2 }
  validates :lastname, presence: true, length: { minimum: 2 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
