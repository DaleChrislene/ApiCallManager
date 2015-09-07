class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def backend_url
  	if Rails.env.development? 
  		'http://localhost:8080'
  	elsif Rails.env.production?
  		'http://morning-everglades-2967.herokuapp.com'
  	end
  		
  end

end
