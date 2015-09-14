module AirlinesHelper
  include ApiHelper

  def call_post_api(params)
    #set reused variables
    req_content_type = ENV['XML_CONTENT_TYPE']
    res_content_type = ENV['JSON_CONTENT_TYPE']

    unless is_valid_params(params)
      Rails.logger.info "Invalid params: #{params}"
      return response_wrapper($COMMON_CONST['BAD_REQUEST'], nil)
    end

    #parse to get from, to
    search_params = parse_params_for_search(params)

    #prepare body in content_type required by backend
    search_req_params = prepare_request_body(req_content_type, search_params, ENV['XML_ROOT'])

    #prepare complete url and encode
    uri = prepare_uri(ENV["AIRLINE_SEARCH_HOST"], ENV['SEARCH_API'])

    #POST request
    response = do_http_post( uri, req_content_type, search_req_params)

    Rails.logger.info "response of POST: #{response}"

    search_result = response.at(0)
    status = response.at(1)

    #convert response to format
    response = prepare_response(search_result, res_content_type)

    #wrap response with status
    response_wrapper(status, response)
  end

  def parse_params_for_search(rawParams)
    search_params = {:from => rawParams[:from], :to => rawParams[:to]}
    search_params = search_params.to_json
    Rails.logger.info "Parsed Params: #{search_params}"
    return search_params
  end

  def is_valid_params(rawParams)
    (rawParams[:from].present? && rawParams[:to].present?) ? true : false
  end
end
