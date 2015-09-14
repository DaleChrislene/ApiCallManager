class HomeController < ApplicationController
	def index		
		render :text => "Welcome to API Call Manager!"
	end
end