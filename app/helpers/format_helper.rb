require "rexml/document"

module FormatHelper

    #conversion from JSON -> XML
    def convert_from_json_to_xml(json_val, xml_root_val)
        begin
            xml_val = MultiJson.load(json_val.to_s).to_xml(:root => xml_root_val)
        rescue MultiJson::ParseError => e
            xml_val = $COMMON_CONST['DEFAULT_XML_RESPONSE']

        end
        Rails.logger.info "Converted from JSON: #{json_val} to XML:#{xml_val}"
        return xml_val
    end

    #conversion from XML -> JSON
    def convert_from_xml_to_json(xml_val)

        if xml_val.blank?
            json_val = $COMMON_CONST['DEFAULT_JSON_RESPONSE']
            return json_val
        end

        begin
            json_val = Hash.from_trusted_xml(xml_val).to_json
            
        rescue REXML::ParseException => e
            json_val = $COMMON_CONST['DEFAULT_JSON_RESPONSE']
        end
        Rails.logger.info "Converted from XML: #{xml_val} to JSON:#{json_val}"
        return json_val
    end
end