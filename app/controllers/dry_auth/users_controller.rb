require_dependency "dry_auth/application_controller"

module DryAuth
  class UsersController < ApplicationController
    respond_to :html

    load_and_authorize_resource :dry_auth_user, parent: false, class: 'DryAuth::User'

    def index
      @users = User.all
    end
  
    def show
      # If no user_id param is passed then a user is editing their profile, so use current_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end
  
    def new
      @user = User.new
    end
  
    def edit
      # If no user_id param is passed then a user is editing their profile, so use current_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to users_path, notice: 'Account successfully created.'
      else
        render action: :new
      end
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to((current_user.has_role? :admin) ? @user : profile_path,notice: 'Account successfully updated.')
      else
        render action: :edit
      end
    end
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to users_url
    end


    private

    # strong_parameters
    def user_params
      params[:user].permit(:id, :username, :email, :locale, :time_zone )
    end

=begin
      Rails.logger.debug '#############'
      User.reflect_on_all_associations.map do |assoc|
        Rails.logger.debug assoc.name
        sym = eval(assoc.class_name).strong_parameters_for_user
        Rails.logger.debug sym
      end
      p 'hello'
      Rails.logger.debug '#############'
      #params[:user].permit(:username, :email, mcp_rank_user_attributes: [:name])
=end
#      params[:user].permit(:username, :email, :common_profile_locale, mcp_rank_profile_attributes: [:name])
      #params[:user].permit(:id, :username, :email, :locale, :time_zone, mcp_pbx_user_attributes: [:email_report] )
      #params[:user].permit(:id, :username, :email, mcp_common_user_attributes: [:first_name, :last_name, :locale], mcp_pbx_user_attributes: [:email_report] )
#      params[:user].permit(:id, :username, :email, mcp_pbx_user_attributes: [:email_report] )

#      params[:dnc_list].permit(:name, dnc_numbers_file_attributes: [:file_name])
=begin
      params.require(:user).permit(:username, :email, :password, agent_attributes: [:pin], asterisk_user_map_attributes: [:asterisk_user_id], 

=end

  end
end

