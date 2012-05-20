class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  skip_before_filter :authenticate_user!  ,:only => :create
  def index
    @authentications = current_user.authentications if current_user
  end

  # GET /authentications/1
  # GET /authentications/1.json

  # GET /authentications/new
  # GET /authentications/new.json
  def new
    @authentication = Authentication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authentication }
    end
  end

  def show
    @authentication = Authentication.find(params[:id])
  end

  # GET /authentications/1/edit
  def edit
    @authentication = Authentication.find(params[:id])

  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successful."
      sign_in_and_redirect(:user,authentication.user)
    elsif current_user
      authentication = current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentication_url(authentication)
    else
      user = User.new(:email => omniauth['info'].email,:password => Devise.friendly_token[0,20])
      authentication = user.apply_omniauth(omniauth)
      if user.save

        flash[:notice] = "Signed in successful."
        sign_in_and_redirect(:user,authentication.user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_path
      end
    end



  end

  # PUT /authentications/1
  # PUT /authentications/1.json
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
