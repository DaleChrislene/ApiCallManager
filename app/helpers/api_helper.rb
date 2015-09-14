require 'net/http'

module ApiHelper
  include FormatHelper

  #return params for request body
  #in format specified
  def prepare_request_body(req_content_type, params, root)
    modified_req_params = ''
    if(req_content_type == ENV['XML_CONTENT_TYPE'])
      modified_req_params = convert_from_json_to_xml(params, root)
    else
      modified_req_params = params
    end

    Rails.logger.info "Prepared Request Body: #{modified_req_params}"
    return modified_req_params
  end

  #return response in specified format
  def prepare_response( response, res_content_type)
    formatted_response = ''
    if(res_content_type == ENV['XML_CONTENT_TYPE'])
      formatted_response = response
    else
      formatted_response = convert_from_xml_to_json(response)
    end

    Rails.logger.info "Prepared Request Body: #{formatted_response}"
    return formatted_response
  end

  #(hostname + api) and encoding
  def prepare_uri( host, api)
    url = host + api
    escaped_url = URI.encode(url)
    uri = URI.parse(escaped_url)

    Rails.logger.info "Prepared URL: #{uri}"
    return uri
  end

  def do_http_post( uri, req_content_type, search_req_params)
    req = Net::HTTP::Post.new(uri.to_s, nil)
    req.body = search_req_params
    req.content_type = req_content_type
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = (uri.scheme == "https")
    begin
      res = http.start do |http|
        http.request(req)
      end
      search_res = res.body
      status = $COMMON_CONST['OK']

    rescue StandardError => e
      search_res = $COMMON_CONST['ERROR_XML']
      status = $COMMON_CONST['SERVICE_UNAVAILABLE']
    end

    Rails.logger.info "HTTP Post response: #{search_res}, STATUS: #{status}"
    return search_res, status
  end

  def response_wrapper(status, response)
    hash = {:status => status, :response => response}
    wrapped_response = hash.to_json
    Rails.logger.info "Wrapped Response: #{wrapped_response}"
    return wrapped_response
  end
end
