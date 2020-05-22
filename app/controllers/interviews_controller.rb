class InterviewsController < ApplicationController
    def index
        @details = hash_for_index
    end



    def create

    end

    private
    def hash_for_index
        details = {}
        if params[:monthyear]
            details[:month] = params[:monthyear].split("-")[1].to_i
            details[:year] = params[:monthyear].split("-")[0].to_i
            details[:month_name] = Date::MONTHNAMES[details[:month]]
            details[:days] = Time.days_in_month(details[:month], details[:year])
        else
            details[:month] = Date.today.month
            details[:year] = Date.today.year
            details[:month_name] = Date::MONTHNAMES[details[:month]]
            details[:days] = Time.days_in_month(details[:month], details[:year])
        end
        return details
    end
end