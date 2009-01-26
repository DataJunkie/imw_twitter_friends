#!/usr/bin/env ruby
$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__)+'/../../lib'
require 'unicode_names'
require 'unicode_planes'
require 'unicode_classification'
require 'unicode_decoder_ring'

COMPLAINT_LEVEL = 12  # Don't even carp for entities happening fewer than this times

def warn_missing_info context, entity_num, freq, entity_name
  return unless freq && freq.to_i > 12
  decoded, *_ = robustly_decode_entity(entity_num)
  warn "No #{context} for %-8s / %8s, occurs %5d times (#{decoded})" % ["&##{entity_num}", "%06x"%entity_num, freq.to_i]
end


#
# For all the entities in the scrape,
#
gather_unicode_names!
$stderr.puts "Collecting entity info from input"
$stdin.each do |line|
  entity_num, freq, *_ = line.chomp.split("\t")
  entity_num = entity_num.to_i
  # Name
  entity_name           = find_entity_name(entity_num, freq)
  # Decode
  decoded, entity_xml_alpha, entity_xml_form = robustly_decode_entity(entity_num)
  # find classification
  classification_info   = find_entity_classification(entity_num, freq, entity_name)
  # Find plane
  plane_info            = find_entity_plane(entity_num, freq, entity_name)
  # Emit
  puts [entity_num, freq, entity_xml_form, entity_xml_alpha, decoded, entity_name, classification_info, plane_info].flatten.join("\t")
end


