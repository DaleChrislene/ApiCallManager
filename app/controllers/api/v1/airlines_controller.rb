require 'net/http'

module Api
 	module V1
    	class AirlinesController < ApplicationController
    		include AirlinesHelper

            skip_before_filter :verify_authenticity_token
                        
    		def search
    			search_params = {:from => params[:from], :to => params[:to]}
    			search_params = search_params.to_json

                #call helper methods to make post request
                init_airline_helper(search_params, ENV['XML_CONTENT_TYPE'],ENV['JSON_CONTENT_TYPE'],  ENV['SEARCH_API'])
                search_result = call_post_api()

    			#return response to FrontEnd
                render json: search_result               
    		end
    	end
    end
end
