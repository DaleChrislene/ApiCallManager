require 'rails_helper'

describe Api::V1::AirlinesController do
	airline_const = Hash.new
	common_const = Hash.new

	before :all do
		string_constants_file = File.join(Rails.root, 'config', 'test_string_constants.yml')
		
        if File.exists?(string_constants_file)
            all_const = YAML.load(ERB.new(IO.read(string_constants_file)).result) || {}
            hash = all_const['rspec_search'] 
            hash.each do |key, val|
                airline_const[key]= val
            end
        end 

        common_constants_file = File.join(Rails.root, 'config', 'common_const.yml')
        if File.exists?(common_constants_file)
            all_const = YAML.load(ERB.new(IO.read(common_constants_file)).result) || {}           
            all_const.each do |key, val|
                common_const[key]= val
            end
        end 

	end

	describe '/api/v1/search POST' do
		describe 'test for original HTTP request-response status' do
			it ' expects 200 with no parameters set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})
				
				post 'search'

				expect(response).to have_http_status(common_const['OK'])
			end


			it ' expects 200 with 1 parameter set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search', {:from => 'from'}

				expect(response).to have_http_status(200)
			end

			it ' expects 200 with 2 parameters set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search', {:from => 'from', :to => 'to'}

				expect(response).to have_http_status(common_const['OK'])
			end
		end

		describe 'test for Status within Response' do
			it ' expects 400 with no parameters set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search'

				expected_val = MultiJson.load(response.body)
				expect(expected_val['status']).to eq(common_const['BAD_REQUEST'])
			end

			it ' expects 400 with 1 parameter set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search', {:from => 'from'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['status']).to eq(common_const['BAD_REQUEST'])
			end

			it ' expects 200 with 2 parameters set' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search', {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['status']).to eq(common_const['OK'])
			end			
		end

		describe 'test for Status and  Response' do
			it ' expects status 500 when backend service is unavailable' do
				post 'search', {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['status']).to eq(common_const['SERVICE_UNAVAILABLE'])
			end
			it ' expects error response when backend service is unavailable' do
				post 'search', {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq(airline_const['ERROR_JSON'])
			end
		end

		describe 'test for Response body for invalid case' do
			it ' expects nil when insufficient (0) parameters' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search'

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq(nil)
			end

			it ' expects nil when insufficient (1) parameters' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "stubbed response", headers: {})

				post 'search', {:from => 'from'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq(nil)
			end
		end

		describe 'test for Response body for valid params' do
			it 'expects empty list - 0 results' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "#{airline_const['XML_EMPTY_RESULT']}", headers: {})

				post 'search' , {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq("#{airline_const['JSON_EMPTY_RESULT']}")
			end

			it 'expects 1 item in list - 1 result' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "#{airline_const['XML_SINGLE_RESULT']}", headers: {})
				post 'search', {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq("#{airline_const['JSON_SINGLE_RESULT']}")
			end

			it 'expects many items in list - 3 results ' do
				stub_request(:post, "localhost:8080/routes/search").
				to_return(status: 200, body: "#{airline_const['XML_MANY_RESULTS']}", headers: {})
				post 'search', {:from => 'from', :to => 'to'}

				expected_val = MultiJson.load(response.body)
				expect(expected_val['response']).to eq("#{airline_const['JSON_MANY_RESULTS']}")
			end
		end
	end
end