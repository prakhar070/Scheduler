class Interview < ApplicationRecord


    has_many_attached :resumes
    #an interview must have a column for an interviewer_id, i.e the user who created that interview
    belongs_to :interviewer, :class_name => "User"

    #an interview has many participants
    has_and_belongs_to_many :participants, :class_name => "User"
    #validations
    validate :date_must_make_sense
    validate :members_available
    validates :title, presence: true
    validates :starttime, presence: true
    validates :endtime, presence: true
    #an interview should have minimum of one participant
    validates :participants, :length => {:minimum => 1, :message=>"At least one participant" }
    
    #a class function that fetches interviews with a particular date
    def self.with_date(date)
        where("date(starttime) == ? OR date(endtime) == ?", date, date)
    end

    def members_available
        self.participants.each do |participant|
            if id.nil?
                clash = participant.interviews_created.where("(((starttime BETWEEN ? AND ? ) OR (starttime < ? AND endtime > ? ) OR (endtime BETWEEN ? AND ?)) )", starttime,endtime,starttime,endtime,starttime,endtime)
                if clash.exists?
                    errors.add(:participants, "#{participant.firstname} has another interview this time")
                    return
                end
                clash = participant.interviews_participated.where("(((starttime BETWEEN ? AND ? ) OR (starttime < ? AND endtime > ? ) OR (endtime BETWEEN ? AND ?)) )", starttime,endtime,starttime,endtime,starttime,endtime)
                if clash.exists?
                    errors.add(:participants, "#{participant.firstname} has another interview this time")
                    return
                end
            else
                clash = participant.interviews_created.where("((id != ?) AND ((starttime BETWEEN ? AND ? ) OR (starttime < ? AND endtime > ? ) OR (endtime BETWEEN ? AND ?)) )",id, starttime,endtime,starttime,endtime,starttime,endtime)
                if clash.exists?
                    errors.add(:participants, "#{participant.firstname} has another interview this time")
                    return
                end
                clash = participant.interviews_participated.where("((id != ?) AND ((starttime BETWEEN ? AND ? ) OR (starttime < ? AND endtime > ? ) OR (endtime BETWEEN ? AND ?)) )",id, starttime,endtime,starttime,endtime,starttime,endtime)
                if clash.exists?
                    errors.add(:participants, "#{participant.firstname} has another interview this time")
                    return
                end
            end

        end
    end

    def date_must_make_sense
        if starttime.present? and endtime.present?  and starttime >= endtime
            errors.add(:starttime, "ensure that the starttime is less than the endtime of the interview")
        elsif starttime.present? && starttime <= (Time.current + 19800)
            errors.add(:starttime, "you are trying to schedule an interview in the past")
        end
    end

    def schedule_reminder
        min = (self.starttime - Time.now)
        min = (min.to_i - 19800)/60 - 30
        if min>0
            self.participants.each do |participant|
                SendReminderMailWorker.perform_in(min.minutes, participant.email)
            end
        end
    end
    
    def new_mail_info
        self.participants.each do |participant|
            SendNewMailWorker.perform_async(participant.email)
        end
    end
end
