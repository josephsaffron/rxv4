require_gem 'ruby-openid'

class OpenidController < ApplicationController

  def new
  end

  def create
	openid_url = params[:openid_url]
  	response = openid_consumer.begin openid_url

  	if response.status == OpenID::SUCCESS
    		redirect_url = response.redirect_url(home_url, complete_openid_url)
    		redirect_to redirect_url
    		return
  	end

  	flash[:error] = "Couldn't find an OpenID for that URL"
  	render :action => :new
  end

  def complete
    response = openid_consumer.complete params

    if response.status == OpenID::SUCCESS
      session[:openid] = response.identity_url
      # the user is now logged in with OpenID!
      redirect_to home_url
      return
    end

    flash[:error] = 'Could not log on with your OpenID'
    redirect_to new_openid_url

  end

  protected

  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::FilesystemStore.new("#{RAILS_ROOT}/tmp/openid"))
  end

end
