#user controller manages the users of the application
class UsersController < ApplicationController
    #before the show action, we need to make sure that the user is logged in first, the authorized helper is defined in application_controller.rb
    before_action :authorized, only: [:show]

    #displays the registration form
    def new
        #passes an empty user object
        @user = User.new
    end

    #creates a new user
    def create
        #creates a new user from the user params
        @user = User.create(user_params)
        if @user.save
            #if the user is saved successfully, redirect to the timeline view
            redirect_to root_path
        else
            #otherwise render another form, and display the validation errors
            render :new
        end
    end

    private
    def user_params
        params.require(:user).permit(:firstname,:lastname, :email, :password, :password_confirmation)
    end

end