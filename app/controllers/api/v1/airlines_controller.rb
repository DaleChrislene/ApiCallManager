require 'net/http'

module Api
 	module V1
    	class AirlinesController < ApplicationController
    		skip_before_filter :verify_authenticity_token
            

    		def search

    			search_params = {:from => params[:from], :to => params[:to]}
    			search_params = search_params.to_json
    			Rails.logger.info "Search parameters as JSON String: #{search_params}"

    			#convert json to xml
    			xml_search_req = convert_to_xml(search_params)
    			Rails.logger.info "Search parameters as XML String: #{xml_search_req}"

    			#REST call to backend  			
    			url = backend_url + '/routes/search'
		        escaped_url = URI.encode(url)
		        uri = URI.parse(escaped_url)
		        req = Net::HTTP::Post.new(uri.to_s, nil)
		        req.body = xml_search_req
		        req.content_type = 'application/xml'
		        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		          http.request(req)
		        end
		        search_res = res.body
		        Rails.logger.info "REST Response: #{search_res}"

    			#convert xml response to json
    			json_response = convert_to_json(search_res)	
    			Rails.logger.info "JSON Converted Response: #{json_response}"

    			#return response to FrontEnd
                render json: json_response
                
    		end

    		private
    		def convert_to_xml(json_val)
    			xml_val = JSON.parse(json_val.to_s).to_xml(:root => 'route')
    			return xml_val
    		end

    		private
    		def convert_to_json(xml_val)
    			json_val = Hash.from_xml(xml_val).to_json
    			return json_val
    		end


    	end
    end
end
