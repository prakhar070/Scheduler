#controller to maintain the requests related to interviews
class InterviewsController < ApplicationController
    #this action is required to convert params[:date] to params[:year], params[:month] and params[:day]
    before_action :destructure, only: [:update]

    #this action creates a @details hash that contains day, month and year info, its necessary to parse calender, if params[:day] is available, it will also construct a date object @d
    before_action :hash_for_index, only: [:index, :create, :edit, :update, :destroy]

    #this action creates a datetime object @dt using the data entered by the user either in edit or in new forms
    before_action :construct_datetime, only: [:create, :update]

    def index
        if @d
            @interviews = Interview.with_date(@d)
        end
    end


    def create
        #fetch all the interviews with the date equal to @d, this will be displayed in the side column as the list of interviews
        @interviews = Interview.with_date(@d)
        
        #create a new interview with the datetime object created as timestamp, interviewer_id as 1 (I have kept it constant just for now, will change it when I will use authentication), and title as the title present in the params
        @interview = Interview.new(tstamp: @dt, interviewer_id: 1, title: params[:title])
        
        #the params also has an array of participant ids, we will fetch all the users with those ids in @participants variable
        @participants = User.where(id: params[:participants])
        #for each of the participant in @participants, we will push in the @interview object collection of participants
        @participants.each do |participant|
            @interview.participants << participant
        end
        #finally we will save the interview
        @interview.save
        #in either of the cases, if error or no error, we will render the index page
        render :index
    end
    

    def edit
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
        #fetch all the interviews with the date equal to @d, this will be displayed in the side column as the list of interviews
        @interviews = Interview.with_date(@d)
    end

    def update
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
        #first delete all the participants in the participants collection of the interview
        @interview.participants.delete_all
        #the params also has an array of participant ids, we will fetch all the users with those ids in @participants variable
        @participants = User.where(id: params[:participants])
        #for each of the participant in @participants, we will push in the @interview object collection of participants
        @participants.each do |participant|
            @interview.participants << participant
        end
        
        @interviews = Interview.with_date(@d)
        if @interview.update(tstamp: @dt, title: params[:title])
            #in case of no errors, render the index page 
            render :index
        else
            #in case of errors in update, render the edit page
            render :edit
        end    
    end


    def destroy
        #find the interview object via the id stored in params
        @interview = Interview.find(params[:id])
        @interview.participants.delete_all
        @interview.delete
        #fetch all the interviews with the date equal to @d, this will be displayed in the side column as the list of interviews
        @interviews = Interview.with_date(@d)
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

    def construct_datetime
        if !params[:time].blank?
            @dt = DateTime.new(
                params[:year].to_i, 
                params[:month].to_i, 
                params[:day].to_i, 
                params[:time].split(":")[0].to_i,
                params[:time].split(":")[1].to_i
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


end