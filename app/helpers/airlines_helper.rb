module AirlinesHelper

	#init variables to be used for a single api call
	def init_airline_helper(params,req_content_type,res_content_type, api_path)
		@params = params
		@req_content_type = req_content_type
		@api_path = api_path
		@res_content_type = res_content_type

		Rails.logger.info "Search parameters received: #{@params}"
		Rails.logger.info "Content_type of Request: #{@req_content_type}"
		Rails.logger.info "API Path: #{@api_path}"
		Rails.logger.info "Content_type of Response: #{@res_content_type}"
	end

	#wrapper method to make a POST call
	def call_post_api

		#change param format to XML/JSON depending on setting	
		search_req_params = prepare_request_body()
		
		#prepare complete url and encode
		uri = prepare_uri()

		#do POST request
        req = Net::HTTP::Post.new(uri.to_s, nil)
        req.body = search_req_params
        req.content_type = @req_content_type
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        search_res = res.body
        Rails.logger.info "REST Response from Backend: #{search_res}"

		#convert response to format
		response = prepare_response(search_res)

		return response
	end

	#conversion from JSON -> XML
    def convert_to_xml(json_val)
    	xml_val = JSON.parse(json_val.to_s).to_xml(:root => ENV['XML_ROOT'])
    	return xml_val
    end

    #conversion from XML -> JSON
   	def convert_to_json(xml_val)
    	json_val = Hash.from_xml(xml_val).to_json
    	return json_val
    end

    #return params for request body
    #in format specified 
    def prepare_request_body
    	modified_req_params = ''
    	if(@req_content_type == ENV['XML_CONTENT_TYPE'])
    		modified_req_params = convert_to_xml(@params)   		
    	else
    		modified_req_params = @params
    	end

    	Rails.logger.info "Search request body: #{modified_req_params}"
    	return modified_req_params
    end

    #return response in specified format
    def prepare_response(response)
    	formatted_response = ''
    	if(@res_content_type == ENV['XML_CONTENT_TYPE'])
    		formatted_response = response   		
    	else
    		formatted_response = convert_to_json(response)
    	end

    	Rails.logger.info "Formatted Response: #{formatted_response}"
    	return formatted_response
    end

    #(hostname + api) and encoding 
    def prepare_uri
    	url = ENV["AIRLINE_SEARCH_HOST"] + @api_path
        escaped_url = URI.encode(url)
        uri = URI.parse(escaped_url)
        return uri
    end
end
