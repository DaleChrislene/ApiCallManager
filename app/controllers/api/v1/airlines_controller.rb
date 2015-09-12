require 'net/http'

module Api
 	module V1
    	class AirlinesController < ApplicationController
    		include AirlinesHelper

            skip_before_filter :verify_authenticity_token
                        
    		def search
    			#return response to FrontEnd
                render json: call_post_api(params)   
    		end
    	
        end
    end
end
