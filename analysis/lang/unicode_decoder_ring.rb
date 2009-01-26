require 'wukong'                       ; include Wukong

def xmlify entity_num
  "&##{entity_num};"
end

def robustly_decode_entity entity_num
  # Decoding
  entity_xml_decimal = xmlify(entity_num)
  if is_bad_char?(entity_num)
    entity_alpha  = entity_xml_decimal
    decoded = ''
  else
    # this silly thing will re-encode using named entities (&yen;, &raquo;, etc.)
    entity_xml_alpha  = entity_xml_decimal.wukong_decode.wukong_encode
    decoded = entity_xml_decimal.wukong_decode
  end
  [decoded, entity_xml_alpha, entity_xml_decimal]
end
