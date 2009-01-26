
# ===========================================================================
#
# Don't encode control characters
#
def is_bad_char? entity_num
  (0x0000..0x001F).include?(entity_num) || (0x007F..0x009F).include?(entity_num)
end

# ===========================================================================
#
# These characters aren't named, just specified by a range.
#
# 3400;<CJK Ideograph Extension A, First>;Lo;0;L;;;;;N;;;;;
# 4DB5;<CJK Ideograph Extension A, Last>;Lo;0;L;;;;;N;;;;;
# 4E00;<CJK Ideograph, First>;Lo;0;L;;;;;N;;;;;
# 9FC3;<CJK Ideograph, Last>;Lo;0;L;;;;;N;;;;;
# AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
# D7A3;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;
# D800;<Non Private Use High Surrogate, First>;Cs;0;L;;;;;N;;;;;
# DB7F;<Non Private Use High Surrogate, Last>;Cs;0;L;;;;;N;;;;;
# DB80;<Private Use High Surrogate, First>;Cs;0;L;;;;;N;;;;;
# DBFF;<Private Use High Surrogate, Last>;Cs;0;L;;;;;N;;;;;
# DC00;<Low Surrogate, First>;Cs;0;L;;;;;N;;;;;
# DFFF;<Low Surrogate, Last>;Cs;0;L;;;;;N;;;;;
# E000;<Private Use, First>;Co;0;L;;;;;N;;;;;
# F8FF;<Private Use, Last>;Co;0;L;;;;;N;;;;;
# 20000;<CJK Ideograph Extension B, First>;Lo;0;L;;;;;N;;;;;
# 2A6D6;<CJK Ideograph Extension B, Last>;Lo;0;L;;;;;N;;;;;
# F0000;<Plane 15 Private Use, First>;Co;0;L;;;;;N;;;;;
# FFFFD;<Plane 15 Private Use, Last>;Co;0;L;;;;;N;;;;;
# 100000;<Plane 16 Private Use, First>;Co;0;L;;;;;N;;;;;
# 10FFFD;<Plane 16 Private Use, Last>;Co;0;L;;;;;N;;;;;
#
#
OTHER_UNICODE_CHAR_NAMES = {
  0x3400..0x4DB5     => "CJK Ideograph Extension A",
  0x4E00..0x9FC3     => "CJK Ideograph",
  0xAC00..0xD7A3     => "Hangul Syllable",
  0xD800..0xDB7F     => "Non Private Use High Surrogate",
  0xDB80..0xDBFF     => "Private Use High Surrogate",
  0xDC00..0xDFFF     => "Low Surrogate",
  0xE000..0xF8FF     => "Private Use",
  0x20000..0x2A6D6   => "CJK Ideograph Extension B",
  0xF0000..0xFFFFD   => "Plane 15 Private Use",
  0x100000..0x10FFFD => "Plane 16 Private Use",
}

# ===========================================================================
#
# These characters have awesome names in UnicodeData
#
NAMED_UNICODE_CHAR_NAMES = { }

# ===========================================================================
#
# Collect all the names from UnicodeData
#
def gather_unicode_names!
  $stderr.puts "Gathering UnicodeData.txt names"
  File.open(File.dirname(__FILE__)+'/unicode/UnicodeData.txt').each do |line|
    #
    # For each entity
    #
    entity_hex, name, category,
    combining, bidi, decomp,
    as_decimal, as_digit,
    as_numeric, mirrored, u1_name, comment,
    to_upper, to_lower, to_title            = line.chomp.split(";")
    entity = entity_hex.hex
    #
    # Skip the lines specifying OTHER_UNICODE_CHAR_NAMES
    # codes; they're fake, we want to use OTHER_UNICODE_CHAR_NAMES
    #
    next if line =~ /[0-9A-F];<[^>]+, (First|Last)>;/i;
    #
    # Format the name
    #
    name = name.split(/\s+/).map(&:capitalize).join(" ")
    name = name.gsub(/\bCjk\b/i, 'CJK')
    #
    # And save it
    #
    NAMED_UNICODE_CHAR_NAMES[entity] = name
    # puts [entity, name].join("\t")
  end
end

# ===========================================================================
#
# Actually names the entity, from UnicodeData if it's explicit;
# or from the 'other' name for the Miscellaneous Ideogram ranges
# or fall back to just "Uncoded character [XML decimal encoding]"
#
def find_entity_name entity_num, freq
  raise "Please call gather_unicode_names! once" if NAMED_UNICODE_CHAR_NAMES.empty?
  NAMED_UNICODE_CHAR_NAMES[63743] = "Private Use - &#{entity_num}; - probably Apple icon"
  name =   NAMED_UNICODE_CHAR_NAMES[entity_num]
  if !name
    range, name = OTHER_UNICODE_CHAR_NAMES.find{ |range, name| range.include?(entity_num) }
    name += " - &##{entity_num};" if name
  end
  if !name
    name    = "Uncoded character &##{entity_num};"
    decoded = "##{entity_num}"
    warn_missing_info(:name, entity_num, '[none]', freq)
  end
  name
end
#
# These ended up unencoded (1/22/09)
#
# &#1971  ; (0007b3), occurs     8 times
# &#1975  ; (0007b7), occurs     7 times
# &#40931 ; (009fe3), occurs    43 times
# &#42211 ; (00a4e3), occurs    23 times
# &#4250  ; (00109a), occurs   114 times
# &#4251  ; (00109b), occurs   161 times
# &#42723 ; (00a6e3), occurs    31 times
# &#42726 ; (00a6e6), occurs     6 times
# &#42979 ; (00a7e3), occurs    23 times
# &#42981 ; (00a7e5), occurs    10 times
# &#43235 ; (00a8e3), occurs    36 times
# &#43238 ; (00a8e6), occurs     7 times
# &#43491 ; (00a9e3), occurs    18 times
# &#43747 ; (00aae3), occurs    67 times
# &#43749 ; (00aae5), occurs     6 times
# &#43945 ; (00aba9), occurs    16 times
# &#44003 ; (00abe3), occurs    37 times
# &#8375  ; (0020b7), occurs    22 times
# &#930   ; (0003a2), occurs    12 times
# &#9984  ; (002700), occurs     6 times
#
