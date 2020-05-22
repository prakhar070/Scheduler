class Interview < ApplicationRecord
    belongs_to :interviewer, :class_name => "User"
    has_many :participants, :class_name => "User"

    #validations 
    #the timestamp for the interview is required
    validates :tstamp, presence: true
end
