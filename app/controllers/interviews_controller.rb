#controller to maintain the requests related to interviews
class InterviewsController < ApplicationController
    #this ensures that the user should be allowed any post related activity once he is logged in
    before_action :authorized
    #this action is required to convert params[:date] to params[:year], params[:month] and params[:day]
    before_action :destructure, only: [:update]

    #this action creates a @details hash that contains day, month and year info, its necessary to parse calender, if params[:day] is available, it will also construct a date object @d
    before_action :hash_for_index, only: [:index, :create, :edit, :update, :destroy]

    #this action creates a datetime object @dt using the data entered by the user either in edit or in new forms
    before_action :construct_starttime_and_endtime, only: [:create, :update]

    before_action :fetch_interviews_for_user, only: [:index, :edit]

    def index
    end


    def create
        #create a new interview with the datetime object created as timestamp, interviewer_id as 1 (I have kept it constant just for now, will change it when I will use authentication), and title as the title present in the params
        @interview = Interview.new(starttime: @sdt, endtime: @edt, interviewer_id: current_user.id, title: params[:title])
        @interview.resumes.attach(params[:resumes])
        
        #the params also has an array of participant ids, we will fetch all the users with those ids in @participants variable
        @participants = User.where(id: params[:participants])
        #for each of the participant in @participants, we will push in the @interview object collection of participants
        @participants.each do |participant|
            @interview.participants << participant
        end
        #finally we will save the interview
        if @interview.save
            #send mails to all the participants of the interview
            @interview.schedule_reminder
            #always send a new interview mail
            @interview.new_mail_info
        end
        
        fetch_interviews_for_user
        #in either of the cases, if error or no error, we will render the index page
        render :index
    end

    def edit
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
    end

    def update
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
        if @interview.update(starttime: @sdt, endtime: @edt, title: params[:title])
            fetch_interviews_for_user
            render :index
        else
            fetch_interviews_for_user
            render :edit
        end    
    end


    def destroy
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
        @interview.destroy
        fetch_interviews_for_user
        render :index
    end

    private
    def construct_date
        @d = Date.new(
            params[:year].to_i, 
            params[:month].to_i, 
            params[:day].to_i
        )
    end

    def construct_starttime_and_endtime
        if !params[:starttime].blank?
            @sdt = DateTime.new(
                params[:year].to_i, 
                params[:month].to_i, 
                params[:day].to_i, 
                params[:starttime].split(":")[0].to_i,
                params[:starttime].split(":")[1].to_i
            )
        end

        if !params[:endtime].blank?
            @edt = DateTime.new(
                params[:year].to_i, 
                params[:month].to_i, 
                params[:day].to_i, 
                params[:endtime].split(":")[0].to_i,
                params[:endtime].split(":")[1].to_i
            )
        end
    end

    def destructure
        params[:year] = params[:date].split("-")[0]
        params[:month] = params[:date].split("-")[1]
        params[:day] = params[:date].split("-")[2]
    end

    def hash_for_index
        @details = {}
        if params[:month] && params[:year]
            @details[:month] = params[:month].to_i
            @details[:year] = params[:year].to_i
            @details[:days] = Time.days_in_month(@details[:month], @details[:year])
            if params[:day]
                construct_date
                @details[:day] = params[:day]
            end
        else
            @details[:month] = Date.today.month
            @details[:year] = Date.today.year
            @details[:days] = Time.days_in_month(@details[:month], @details[:year])
        end
    end

    def fetch_interviews_for_user
        if @d
            @interviews = current_user.interviews_created.with_date(@d) + current_user.interviews_participated.with_date(@d)
        end
    end
end