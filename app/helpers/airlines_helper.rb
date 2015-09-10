module AirlinesHelper

	#init variables to be used for a single api call
	def init_airline_helper(params,content_type,api_path)
		@params = params
		@content_type = content_type
		@api_path = api_path

		Rails.logger.info "Search parameters received: #{@params}"
		Rails.logger.info "Content_type requested: #{@content_type}"
		Rails.logger.info "API Path: #{@api_path}"

	end

	#wrapper method to make a post call
	def call_post_api		
		search_req_params = prepare_request_body()
		   				
		uri = prepare_uri()

        req = Net::HTTP::Post.new(uri.to_s, nil)
        req.body = search_req_params
        req.content_type = @content_type
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        search_res = res.body
        Rails.logger.info "REST Response from Backend: #{search_res}"

		#convert xml response to json
		json_response = convert_to_json(search_res)	
		Rails.logger.info "JSON Converted Response: #{json_response}"

		return json_response
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

    #return params fpr request body
    #in format specified 
    def prepare_request_body
    	search_req_params = ''
    	if(@content_type == ENV['XML_CONTENT_TYPE'])
    		search_req_params = convert_to_xml(@params)   		
    	else
    		search_req_params = @params
    	end

    	Rails.logger.info "Search request body: #{search_req_params}"
    	return search_req_params
    end

    def prepare_uri
    	url = ENV["AIRLINE_SEARCH_HOST"] + @api_path
        escaped_url = URI.encode(url)
        uri = URI.parse(escaped_url)
        return uri
    end
end
