class InterviewsController < ApplicationController
    def index
        @details = hash_for_index
    end

    def create
        dt = DateTime.new(
            params[:year].to_i, 
            params[:month].to_i, 
            params[:day].to_i, 
            params[:time].split(":")[0].to_i,
            params[:time].split(":")[1].to_i
        )
        @new_interview = Interview.new(tstamp: dt, interviewer_id: 1)
        @participants = User.where(id: params[:participants])
        @new_interview.save
        @participants.each do |participant|
            @new_interview.participants << participant
        end
        @new_interview.save
        redirect_to interviews_path
    end

    private
    def hash_for_index
        details = {}
        if params[:monthyear]
            details[:month] = params[:monthyear].split("-")[1].to_i
            details[:year] = params[:monthyear].split("-")[0].to_i
            details[:days] = Time.days_in_month(details[:month], details[:year])
        else
            details[:month] = Date.today.month
            details[:year] = Date.today.year
            details[:days] = Time.days_in_month(details[:month], details[:year])
        end
        return details
    end
end