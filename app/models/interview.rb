class Interview < ApplicationRecord

    #an interview must have a column for an interviewer_id, i.e the user who created that interview
    belongs_to :interviewer, :class_name => "User"

    #an interview has many participants
    has_and_belongs_to_many :participants, :class_name => "User"
    #validations
    validates :title, presence: true
    validates :tstamp, presence: true
    #an interview should have minimum of one participant
    validates :participants, :length => {:minimum => 1, :message=>"At least one participant" }

    #a class function that fetches interviews with a particular date
    def self.with_date(date)
        where("date(tstamp) == ?", date)
    end
end
