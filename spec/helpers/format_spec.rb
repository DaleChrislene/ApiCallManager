require 'rails_helper'
#require './helpers'

RSpec.configure do |c|
  c.include FormatHelper
end

describe FormatHelper do

	common_const = Hash.new
	airline_const = Hash.new

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

	describe 'XML to JSON converter' do
		it ' expects empty list and no REXML::ParseException for invalid XML' do
			expect(convert_from_xml_to_json('invalid xml')).to eq(airline_const['JSON_EMPTY_RESULT']);
		end
		it ' expects empty list no REXML::ParseException for empty' do
			expect(convert_from_xml_to_json('')).to eq(airline_const['JSON_EMPTY_RESULT']);
		end
	end

	describe 'JSON to XML converter' do
		it ' expects no ParseError for invalid JSON' do
			expect(convert_from_json_to_xml('invalid json','route')).to eq(common_const['DEFAULT_XML_RESPONSE']);
		end
		it ' expects no ParseError for empty JSON ' do
			expect(convert_from_json_to_xml('','route')).to eq(common_const['DEFAULT_XML_RESPONSE']);
		end
	end
end