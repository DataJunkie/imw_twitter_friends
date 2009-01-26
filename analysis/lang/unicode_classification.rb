# ===========================================================================
#
# Classify characters, by plane and script (Devanagari, Latin, etc)
#


#
# NOTE the horrible thing we're doing right here:
# it makes the code down there much nicer tho
# and fuckit it's a oneoff
#
Fixnum.class_eval{  def include?(x) x == self end }


#
# Munged from:
#
#        Scripts-5.1.0.txt
#        Date: 2008-03-20, 17:55:33 GMT [MD]
#
#        Unicode Character Database
#        Copyright (c) 1991-2008 Unicode, Inc.
#        For terms of use, see http://www.unicode.org/terms_of_use.html
#        For documentation, see UCD.html
#
#        ================================================
#
#        Property:     Script
#
#        All code points not explicitly listed for Script
#        have the value Unknown (Zzzz).
#
#        @missing: 0000..10FFFF        ; Unknown
#
#        ================================================
#
#
# BTW, Those wacky Category fields:
#
# Cat   Description
# Lu    Letter, Uppercase
# Ll    Letter, Lowercase
# Lt    Letter, Titlecase
# Lm    Letter, Modifier
# Lo    Letter, Other
# Mn    Mark, Nonspacing
# Mc    Mark, Spacing Combining
# Me    Mark, Enclosing
# Nd    Number, Decimal Digit
# Nl    Number, Letter
# No    Number, Other
# Pc    Punctuation, Connector
# Pd    Punctuation, Dash
# Ps    Punctuation, Open
# Pe    Punctuation, Close
# Pi    Punctuation, Initial quote (may behave like Ps or Pe depending on usage)
# Pf    Punctuation, Final quote (may behave like Ps or Pe depending on usage)
# Po    Punctuation, Other
# Sm    Symbol, Math
# Sc    Symbol, Currency
# Sk    Symbol, Modifier
# So    Symbol, Other
# Zs    Separator, Space
# Zl    Separator, Line
# Zp    Separator, Paragraph
# Cc    Other, Control
# Cf    Other, Format
# Cs    Other, Surrogate
# Co    Other, Private Use
# Cn    Other, Not Assigned (no characters in the file have this property)
#
UNICODE_CLASSIFICATION_MAPPING = {
  0x0000..0x001F        => [ "Common",  "Cc",   " [32]",        "<control-0000>..<control-001F>",                                                                               ],
  0x0020                => [ "Common",  "Zs",   "     ",        "SPACE",                                                                                                        ],
  0x0021..0x0023        => [ "Common",  "Po",   "  [3]",        "EXCLAMATION MARK..NUMBER SIGN",                                                                                ],
  0x0024                => [ "Common",  "Sc",   "     ",        "DOLLAR SIGN",                                                                                                  ],
  0x0025..0x0027        => [ "Common",  "Po",   "  [3]",        "PERCENT SIGN..APOSTROPHE",                                                                                     ],
  0x0028                => [ "Common",  "Ps",   "     ",        "LEFT PARENTHESIS",                                                                                             ],
  0x0029                => [ "Common",  "Pe",   "     ",        "RIGHT PARENTHESIS",                                                                                            ],
  0x002A                => [ "Common",  "Po",   "     ",        "ASTERISK",                                                                                                     ],
  0x002B                => [ "Common",  "Sm",   "     ",        "PLUS SIGN",                                                                                                    ],
  0x002C                => [ "Common",  "Po",   "     ",        "COMMA",                                                                                                        ],
  0x002D                => [ "Common",  "Pd",   "     ",        "HYPHEN-MINUS",                                                                                                 ],
  0x002E..0x002F        => [ "Common",  "Po",   "  [2]",        "FULL STOP..SOLIDUS",                                                                                           ],
  0x0030..0x0039        => [ "Common",  "Nd",   " [10]",        "DIGIT ZERO..DIGIT NINE",                                                                                       ],
  0x003A..0x003B        => [ "Common",  "Po",   "  [2]",        "COLON..SEMICOLON",                                                                                             ],
  0x003C..0x003E        => [ "Common",  "Sm",   "  [3]",        "LESS-THAN SIGN..GREATER-THAN SIGN",                                                                            ],
  0x003F..0x0040        => [ "Common",  "Po",   "  [2]",        "QUESTION MARK..COMMERCIAL AT",                                                                                 ],
  0x005B                => [ "Common",  "Ps",   "     ",        "LEFT SQUARE BRACKET",                                                                                          ],
  0x005C                => [ "Common",  "Po",   "     ",        "REVERSE SOLIDUS",                                                                                              ],
  0x005D                => [ "Common",  "Pe",   "     ",        "RIGHT SQUARE BRACKET",                                                                                         ],
  0x005E                => [ "Common",  "Sk",   "     ",        "CIRCUMFLEX ACCENT",                                                                                            ],
  0x005F                => [ "Common",  "Pc",   "     ",        "LOW LINE",                                                                                                     ],
  0x0060                => [ "Common",  "Sk",   "     ",        "GRAVE ACCENT",                                                                                                 ],
  0x007B                => [ "Common",  "Ps",   "     ",        "LEFT CURLY BRACKET",                                                                                           ],
  0x007C                => [ "Common",  "Sm",   "     ",        "VERTICAL LINE",                                                                                                ],
  0x007D                => [ "Common",  "Pe",   "     ",        "RIGHT CURLY BRACKET",                                                                                          ],
  0x007E                => [ "Common",  "Sm",   "     ",        "TILDE",                                                                                                        ],
  0x007F..0x009F        => [ "Common",  "Cc",   " [33]",        "<control-007F>..<control-009F>",                                                                               ],
  0x00A0                => [ "Common",  "Zs",   "     ",        "NO-BREAK SPACE",                                                                                               ],
  0x00A1                => [ "Common",  "Po",   "     ",        "INVERTED EXCLAMATION MARK",                                                                                    ],
  0x00A2..0x00A5        => [ "Common",  "Sc",   "  [4]",        "CENT SIGN..YEN SIGN",                                                                                          ],
  0x00A6..0x00A7        => [ "Common",  "So",   "  [2]",        "BROKEN BAR..SECTION SIGN",                                                                                     ],
  0x00A8                => [ "Common",  "Sk",   "     ",        "DIAERESIS",                                                                                                    ],
  0x00A9                => [ "Common",  "So",   "     ",        "COPYRIGHT SIGN",                                                                                               ],
  0x00AB                => [ "Common",  "Pi",   "     ",        "LEFT-POINTING DOUBLE ANGLE QUOTATION MARK",                                                                    ],
  0x00AC                => [ "Common",  "Sm",   "     ",        "NOT SIGN",                                                                                                     ],
  0x00AD                => [ "Common",  "Cf",   "     ",        "SOFT HYPHEN",                                                                                                  ],
  0x00AE                => [ "Common",  "So",   "     ",        "REGISTERED SIGN",                                                                                              ],
  0x00AF                => [ "Common",  "Sk",   "     ",        "MACRON",                                                                                                       ],
  0x00B0                => [ "Common",  "So",   "     ",        "DEGREE SIGN",                                                                                                  ],
  0x00B1                => [ "Common",  "Sm",   "     ",        "PLUS-MINUS SIGN",                                                                                              ],
  0x00B2..0x00B3        => [ "Common",  "No",   "  [2]",        "SUPERSCRIPT TWO..SUPERSCRIPT THREE",                                                                           ],
  0x00B4                => [ "Common",  "Sk",   "     ",        "ACUTE ACCENT",                                                                                                 ],
  0x00B5                => [ "Common",  "L&",   "     ",        "MICRO SIGN",                                                                                                   ],
  0x00B6                => [ "Common",  "So",   "     ",        "PILCROW SIGN",                                                                                                 ],
  0x00B7                => [ "Common",  "Po",   "     ",        "MIDDLE DOT",                                                                                                   ],
  0x00B8                => [ "Common",  "Sk",   "     ",        "CEDILLA",                                                                                                      ],
  0x00B9                => [ "Common",  "No",   "     ",        "SUPERSCRIPT ONE",                                                                                              ],
  0x00BB                => [ "Common",  "Pf",   "     ",        "RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK",                                                                   ],
  0x00BC..0x00BE        => [ "Common",  "No",   "  [3]",        "VULGAR FRACTION ONE QUARTER..VULGAR FRACTION THREE QUARTERS",                                                  ],
  0x00BF                => [ "Common",  "Po",   "     ",        "INVERTED QUESTION MARK",                                                                                       ],
  0x00D7                => [ "Common",  "Sm",   "     ",        "MULTIPLICATION SIGN",                                                                                          ],
  0x00F7                => [ "Common",  "Sm",   "     ",        "DIVISION SIGN",                                                                                                ],
  0x02B9..0x02C1        => [ "Common",  "Lm",   "  [9]",        "MODIFIER LETTER PRIME..MODIFIER LETTER REVERSED GLOTTAL STOP",                                                 ],
  0x02C2..0x02C5        => [ "Common",  "Sk",   "  [4]",        "MODIFIER LETTER LEFT ARROWHEAD..MODIFIER LETTER DOWN ARROWHEAD",                                               ],
  0x02C6..0x02D1        => [ "Common",  "Lm",   " [12]",        "MODIFIER LETTER CIRCUMFLEX ACCENT..MODIFIER LETTER HALF TRIANGULAR COLON",                                     ],
  0x02D2..0x02DF        => [ "Common",  "Sk",   " [14]",        "MODIFIER LETTER CENTRED RIGHT HALF RING..MODIFIER LETTER CROSS ACCENT",                                        ],
  0x02E5..0x02EB        => [ "Common",  "Sk",   "  [7]",        "MODIFIER LETTER EXTRA-HIGH TONE BAR..MODIFIER LETTER YANG DEPARTING TONE MARK",                                ],
  0x02EC                => [ "Common",  "Lm",   "     ",        "MODIFIER LETTER VOICING",                                                                                      ],
  0x02ED                => [ "Common",  "Sk",   "     ",        "MODIFIER LETTER UNASPIRATED",                                                                                  ],
  0x02EE                => [ "Common",  "Lm",   "     ",        "MODIFIER LETTER DOUBLE APOSTROPHE",                                                                            ],
  0x02EF..0x02FF        => [ "Common",  "Sk",   " [17]",        "MODIFIER LETTER LOW DOWN ARROWHEAD..MODIFIER LETTER LOW LEFT ARROW",                                           ],
  0x0374                => [ "Common",  "Lm",   "     ",        "GREEK NUMERAL SIGN",                                                                                           ],
  0x037E                => [ "Common",  "Po",   "     ",        "GREEK QUESTION MARK",                                                                                          ],
  0x0385                => [ "Common",  "Sk",   "     ",        "GREEK DIALYTIKA TONOS",                                                                                        ],
  0x0387                => [ "Common",  "Po",   "     ",        "GREEK ANO TELEIA",                                                                                             ],
  0x0589                => [ "Common",  "Po",   "     ",        "ARMENIAN FULL STOP",                                                                                           ],
  0x0600..0x0603        => [ "Common",  "Cf",   "  [4]",        "ARABIC NUMBER SIGN..ARABIC SIGN SAFHA",                                                                        ],
  0x060C                => [ "Common",  "Po",   "     ",        "ARABIC COMMA",                                                                                                 ],
  0x061B                => [ "Common",  "Po",   "     ",        "ARABIC SEMICOLON",                                                                                             ],
  0x061F                => [ "Common",  "Po",   "     ",        "ARABIC QUESTION MARK",                                                                                         ],
  0x0640                => [ "Common",  "Lm",   "     ",        "ARABIC TATWEEL",                                                                                               ],
  0x0660..0x0669        => [ "Common",  "Nd",   " [10]",        "ARABIC-INDIC DIGIT ZERO..ARABIC-INDIC DIGIT NINE",                                                             ],
  0x06DD                => [ "Common",  "Cf",   "     ",        "ARABIC END OF AYAH",                                                                                           ],
  0x0964..0x0965        => [ "Common",  "Po",   "  [2]",        "DEVANAGARI DANDA..DEVANAGARI DOUBLE DANDA",                                                                    ],
  0x0970                => [ "Common",  "Po",   "     ",        "DEVANAGARI ABBREVIATION SIGN",                                                                                 ],
  0x0CF1..0x0CF2        => [ "Common",  "So",   "  [2]",        "KANNADA SIGN JIHVAMULIYA..KANNADA SIGN UPADHMANIYA",                                                           ],
  0x0E3F                => [ "Common",  "Sc",   "     ",        "THAI CURRENCY SYMBOL BAHT",                                                                                    ],
  0x10FB                => [ "Common",  "Po",   "     ",        "GEORGIAN PARAGRAPH SEPARATOR",                                                                                 ],
  0x16EB..0x16ED        => [ "Common",  "Po",   "  [3]",        "RUNIC SINGLE PUNCTUATION..RUNIC CROSS PUNCTUATION",                                                            ],
  0x1735..0x1736        => [ "Common",  "Po",   "  [2]",        "PHILIPPINE SINGLE PUNCTUATION..PHILIPPINE DOUBLE PUNCTUATION",                                                 ],
  0x1802..0x1803        => [ "Common",  "Po",   "  [2]",        "MONGOLIAN COMMA..MONGOLIAN FULL STOP",                                                                         ],
  0x1805                => [ "Common",  "Po",   "     ",        "MONGOLIAN FOUR DOTS",                                                                                          ],
  0x2000..0x200A        => [ "Common",  "Zs",   " [11]",        "EN QUAD..HAIR SPACE",                                                                                          ],
  0x200B                => [ "Common",  "Cf",   "     ",        "ZERO WIDTH SPACE",                                                                                             ],
  0x200E..0x200F        => [ "Common",  "Cf",   "  [2]",        "LEFT-TO-RIGHT MARK..RIGHT-TO-LEFT MARK",                                                                       ],
  0x2010..0x2015        => [ "Common",  "Pd",   "  [6]",        "HYPHEN..HORIZONTAL BAR",                                                                                       ],
  0x2016..0x2017        => [ "Common",  "Po",   "  [2]",        "DOUBLE VERTICAL LINE..DOUBLE LOW LINE",                                                                        ],
  0x2018                => [ "Common",  "Pi",   "     ",        "LEFT SINGLE QUOTATION MARK",                                                                                   ],
  0x2019                => [ "Common",  "Pf",   "     ",        "RIGHT SINGLE QUOTATION MARK",                                                                                  ],
  0x201A                => [ "Common",  "Ps",   "     ",        "SINGLE LOW-9 QUOTATION MARK",                                                                                  ],
  0x201B..0x201C        => [ "Common",  "Pi",   "  [2]",        "SINGLE HIGH-REVERSED-9 QUOTATION MARK..LEFT DOUBLE QUOTATION MARK",                                            ],
  0x201D                => [ "Common",  "Pf",   "     ",        "RIGHT DOUBLE QUOTATION MARK",                                                                                  ],
  0x201E                => [ "Common",  "Ps",   "     ",        "DOUBLE LOW-9 QUOTATION MARK",                                                                                  ],
  0x201F                => [ "Common",  "Pi",   "     ",        "DOUBLE HIGH-REVERSED-9 QUOTATION MARK",                                                                        ],
  0x2020..0x2027        => [ "Common",  "Po",   "  [8]",        "DAGGER..HYPHENATION POINT",                                                                                    ],
  0x2028                => [ "Common",  "Zl",   "     ",        "LINE SEPARATOR",                                                                                               ],
  0x2029                => [ "Common",  "Zp",   "     ",        "PARAGRAPH SEPARATOR",                                                                                          ],
  0x202A..0x202E        => [ "Common",  "Cf",   "  [5]",        "LEFT-TO-RIGHT EMBEDDING..RIGHT-TO-LEFT OVERRIDE",                                                              ],
  0x202F                => [ "Common",  "Zs",   "     ",        "NARROW NO-BREAK SPACE",                                                                                        ],
  0x2030..0x2038        => [ "Common",  "Po",   "  [9]",        "PER MILLE SIGN..CARET",                                                                                        ],
  0x2039                => [ "Common",  "Pi",   "     ",        "SINGLE LEFT-POINTING ANGLE QUOTATION MARK",                                                                    ],
  0x203A                => [ "Common",  "Pf",   "     ",        "SINGLE RIGHT-POINTING ANGLE QUOTATION MARK",                                                                   ],
  0x203B..0x203E        => [ "Common",  "Po",   "  [4]",        "REFERENCE MARK..OVERLINE",                                                                                     ],
  0x203F..0x2040        => [ "Common",  "Pc",   "  [2]",        "UNDERTIE..CHARACTER TIE",                                                                                      ],
  0x2041..0x2043        => [ "Common",  "Po",   "  [3]",        "CARET INSERTION POINT..HYPHEN BULLET",                                                                         ],
  0x2044                => [ "Common",  "Sm",   "     ",        "FRACTION SLASH",                                                                                               ],
  0x2045                => [ "Common",  "Ps",   "     ",        "LEFT SQUARE BRACKET WITH QUILL",                                                                               ],
  0x2046                => [ "Common",  "Pe",   "     ",        "RIGHT SQUARE BRACKET WITH QUILL",                                                                              ],
  0x2047..0x2051        => [ "Common",  "Po",   " [11]",        "DOUBLE QUESTION MARK..TWO ASTERISKS ALIGNED VERTICALLY",                                                       ],
  0x2052                => [ "Common",  "Sm",   "     ",        "COMMERCIAL MINUS SIGN",                                                                                        ],
  0x2053                => [ "Common",  "Po",   "     ",        "SWUNG DASH",                                                                                                   ],
  0x2054                => [ "Common",  "Pc",   "     ",        "INVERTED UNDERTIE",                                                                                            ],
  0x2055..0x205E        => [ "Common",  "Po",   " [10]",        "FLOWER PUNCTUATION MARK..VERTICAL FOUR DOTS",                                                                  ],
  0x205F                => [ "Common",  "Zs",   "     ",        "MEDIUM MATHEMATICAL SPACE",                                                                                    ],
  0x2060..0x2064        => [ "Common",  "Cf",   "  [5]",        "WORD JOINER..INVISIBLE PLUS",                                                                                  ],
  0x206A..0x206F        => [ "Common",  "Cf",   "  [6]",        "INHIBIT SYMMETRIC SWAPPING..NOMINAL DIGIT SHAPES",                                                             ],
  0x2070                => [ "Common",  "No",   "     ",        "SUPERSCRIPT ZERO",                                                                                             ],
  0x2074..0x2079        => [ "Common",  "No",   "  [6]",        "SUPERSCRIPT FOUR..SUPERSCRIPT NINE",                                                                           ],
  0x207A..0x207C        => [ "Common",  "Sm",   "  [3]",        "SUPERSCRIPT PLUS SIGN..SUPERSCRIPT EQUALS SIGN",                                                               ],
  0x207D                => [ "Common",  "Ps",   "     ",        "SUPERSCRIPT LEFT PARENTHESIS",                                                                                 ],
  0x207E                => [ "Common",  "Pe",   "     ",        "SUPERSCRIPT RIGHT PARENTHESIS",                                                                                ],
  0x2080..0x2089        => [ "Common",  "No",   " [10]",        "SUBSCRIPT ZERO..SUBSCRIPT NINE",                                                                               ],
  0x208A..0x208C        => [ "Common",  "Sm",   "  [3]",        "SUBSCRIPT PLUS SIGN..SUBSCRIPT EQUALS SIGN",                                                                   ],
  0x208D                => [ "Common",  "Ps",   "     ",        "SUBSCRIPT LEFT PARENTHESIS",                                                                                   ],
  0x208E                => [ "Common",  "Pe",   "     ",        "SUBSCRIPT RIGHT PARENTHESIS",                                                                                  ],
  0x20A0..0x20B5        => [ "Common",  "Sc",   " [22]",        "EURO-CURRENCY SIGN..CEDI SIGN",                                                                                ],
  0x2100..0x2101        => [ "Common",  "So",   "  [2]",        "ACCOUNT OF..ADDRESSED TO THE SUBJECT",                                                                         ],
  0x2102                => [ "Common",  "L&",   "     ",        "DOUBLE-STRUCK CAPITAL C",                                                                                      ],
  0x2103..0x2106        => [ "Common",  "So",   "  [4]",        "DEGREE CELSIUS..CADA UNA",                                                                                     ],
  0x2107                => [ "Common",  "L&",   "     ",        "EULER CONSTANT",                                                                                               ],
  0x2108..0x2109        => [ "Common",  "So",   "  [2]",        "SCRUPLE..DEGREE FAHRENHEIT",                                                                                   ],
  0x210A..0x2113        => [ "Common",  "L&",   " [10]",        "SCRIPT SMALL G..SCRIPT SMALL L",                                                                               ],
  0x2114                => [ "Common",  "So",   "     ",        "L B BAR SYMBOL",                                                                                               ],
  0x2115                => [ "Common",  "L&",   "     ",        "DOUBLE-STRUCK CAPITAL N",                                                                                      ],
  0x2116..0x2118        => [ "Common",  "So",   "  [3]",        "NUMERO SIGN..SCRIPT CAPITAL P",                                                                                ],
  0x2119..0x211D        => [ "Common",  "L&",   "  [5]",        "DOUBLE-STRUCK CAPITAL P..DOUBLE-STRUCK CAPITAL R",                                                             ],
  0x211E..0x2123        => [ "Common",  "So",   "  [6]",        "PRESCRIPTION TAKE..VERSICLE",                                                                                  ],
  0x2124                => [ "Common",  "L&",   "     ",        "DOUBLE-STRUCK CAPITAL Z",                                                                                      ],
  0x2125                => [ "Common",  "So",   "     ",        "OUNCE SIGN",                                                                                                   ],
  0x2127                => [ "Common",  "So",   "     ",        "INVERTED OHM SIGN",                                                                                            ],
  0x2128                => [ "Common",  "L&",   "     ",        "BLACK-LETTER CAPITAL Z",                                                                                       ],
  0x2129                => [ "Common",  "So",   "     ",        "TURNED GREEK SMALL LETTER IOTA",                                                                               ],
  0x212C..0x212D        => [ "Common",  "L&",   "  [2]",        "SCRIPT CAPITAL B..BLACK-LETTER CAPITAL C",                                                                     ],
  0x212E                => [ "Common",  "So",   "     ",        "ESTIMATED SYMBOL",                                                                                             ],
  0x212F..0x2131        => [ "Common",  "L&",   "  [3]",        "SCRIPT SMALL E..SCRIPT CAPITAL F",                                                                             ],
  0x2133..0x2134        => [ "Common",  "L&",   "  [2]",        "SCRIPT CAPITAL M..SCRIPT SMALL O",                                                                             ],
  0x2135..0x2138        => [ "Common",  "Lo",   "  [4]",        "ALEF SYMBOL..DALET SYMBOL",                                                                                    ],
  0x2139                => [ "Common",  "L&",   "     ",        "INFORMATION SOURCE",                                                                                           ],
  0x213A..0x213B        => [ "Common",  "So",   "  [2]",        "ROTATED CAPITAL Q..FACSIMILE SIGN",                                                                            ],
  0x213C..0x213F        => [ "Common",  "L&",   "  [4]",        "DOUBLE-STRUCK SMALL PI..DOUBLE-STRUCK CAPITAL PI",                                                             ],
  0x2140..0x2144        => [ "Common",  "Sm",   "  [5]",        "DOUBLE-STRUCK N-ARY SUMMATION..TURNED SANS-SERIF CAPITAL Y",                                                   ],
  0x2145..0x2149        => [ "Common",  "L&",   "  [5]",        "DOUBLE-STRUCK ITALIC CAPITAL D..DOUBLE-STRUCK ITALIC SMALL J",                                                 ],
  0x214A                => [ "Common",  "So",   "     ",        "PROPERTY LINE",                                                                                                ],
  0x214B                => [ "Common",  "Sm",   "     ",        "TURNED AMPERSAND",                                                                                             ],
  0x214C..0x214D        => [ "Common",  "So",   "  [2]",        "PER SIGN..AKTIESELSKAB",                                                                                       ],
  0x214F                => [ "Common",  "So",   "     ",        "SYMBOL FOR SAMARITAN SOURCE",                                                                                  ],
  0x2153..0x215F        => [ "Common",  "No",   " [13]",        "VULGAR FRACTION ONE THIRD..FRACTION NUMERATOR ONE",                                                            ],
  0x2190..0x2194        => [ "Common",  "Sm",   "  [5]",        "LEFTWARDS ARROW..LEFT RIGHT ARROW",                                                                            ],
  0x2195..0x2199        => [ "Common",  "So",   "  [5]",        "UP DOWN ARROW..SOUTH WEST ARROW",                                                                              ],
  0x219A..0x219B        => [ "Common",  "Sm",   "  [2]",        "LEFTWARDS ARROW WITH STROKE..RIGHTWARDS ARROW WITH STROKE",                                                    ],
  0x219C..0x219F        => [ "Common",  "So",   "  [4]",        "LEFTWARDS WAVE ARROW..UPWARDS TWO HEADED ARROW",                                                               ],
  0x21A0                => [ "Common",  "Sm",   "     ",        "RIGHTWARDS TWO HEADED ARROW",                                                                                  ],
  0x21A1..0x21A2        => [ "Common",  "So",   "  [2]",        "DOWNWARDS TWO HEADED ARROW..LEFTWARDS ARROW WITH TAIL",                                                        ],
  0x21A3                => [ "Common",  "Sm",   "     ",        "RIGHTWARDS ARROW WITH TAIL",                                                                                   ],
  0x21A4..0x21A5        => [ "Common",  "So",   "  [2]",        "LEFTWARDS ARROW FROM BAR..UPWARDS ARROW FROM BAR",                                                             ],
  0x21A6                => [ "Common",  "Sm",   "     ",        "RIGHTWARDS ARROW FROM BAR",                                                                                    ],
  0x21A7..0x21AD        => [ "Common",  "So",   "  [7]",        "DOWNWARDS ARROW FROM BAR..LEFT RIGHT WAVE ARROW",                                                              ],
  0x21AE                => [ "Common",  "Sm",   "     ",        "LEFT RIGHT ARROW WITH STROKE",                                                                                 ],
  0x21AF..0x21CD        => [ "Common",  "So",   " [31]",        "DOWNWARDS ZIGZAG ARROW..LEFTWARDS DOUBLE ARROW WITH STROKE",                                                   ],
  0x21CE..0x21CF        => [ "Common",  "Sm",   "  [2]",        "LEFT RIGHT DOUBLE ARROW WITH STROKE..RIGHTWARDS DOUBLE ARROW WITH STROKE",                                     ],
  0x21D0..0x21D1        => [ "Common",  "So",   "  [2]",        "LEFTWARDS DOUBLE ARROW..UPWARDS DOUBLE ARROW",                                                                 ],
  0x21D2                => [ "Common",  "Sm",   "     ",        "RIGHTWARDS DOUBLE ARROW",                                                                                      ],
  0x21D3                => [ "Common",  "So",   "     ",        "DOWNWARDS DOUBLE ARROW",                                                                                       ],
  0x21D4                => [ "Common",  "Sm",   "     ",        "LEFT RIGHT DOUBLE ARROW",                                                                                      ],
  0x21D5..0x21F3        => [ "Common",  "So",   " [31]",        "UP DOWN DOUBLE ARROW..UP DOWN WHITE ARROW",                                                                    ],
  0x21F4..0x22FF        => [ "Common",  "Sm",   "[268]",        "RIGHT ARROW WITH SMALL CIRCLE..Z NOTATION BAG MEMBERSHIP",                                                     ],
  0x2300..0x2307        => [ "Common",  "So",   "  [8]",        "DIAMETER SIGN..WAVY LINE",                                                                                     ],
  0x2308..0x230B        => [ "Common",  "Sm",   "  [4]",        "LEFT CEILING..RIGHT FLOOR",                                                                                    ],
  0x230C..0x231F        => [ "Common",  "So",   " [20]",        "BOTTOM RIGHT CROP..BOTTOM RIGHT CORNER",                                                                       ],
  0x2320..0x2321        => [ "Common",  "Sm",   "  [2]",        "TOP HALF INTEGRAL..BOTTOM HALF INTEGRAL",                                                                      ],
  0x2322..0x2328        => [ "Common",  "So",   "  [7]",        "FROWN..KEYBOARD",                                                                                              ],
  0x2329                => [ "Common",  "Ps",   "     ",        "LEFT-POINTING ANGLE BRACKET",                                                                                  ],
  0x232A                => [ "Common",  "Pe",   "     ",        "RIGHT-POINTING ANGLE BRACKET",                                                                                 ],
  0x232B..0x237B        => [ "Common",  "So",   " [81]",        "ERASE TO THE LEFT..NOT CHECK MARK",                                                                            ],
  0x237C                => [ "Common",  "Sm",   "     ",        "RIGHT ANGLE WITH DOWNWARDS ZIGZAG ARROW",                                                                      ],
  0x237D..0x239A        => [ "Common",  "So",   " [30]",        "SHOULDERED OPEN BOX..CLEAR SCREEN SYMBOL",                                                                     ],
  0x239B..0x23B3        => [ "Common",  "Sm",   " [25]",        "LEFT PARENTHESIS UPPER HOOK..SUMMATION BOTTOM",                                                                ],
  0x23B4..0x23DB        => [ "Common",  "So",   " [40]",        "TOP SQUARE BRACKET..FUSE",                                                                                     ],
  0x23DC..0x23E1        => [ "Common",  "Sm",   "  [6]",        "TOP PARENTHESIS..BOTTOM TORTOISE SHELL BRACKET",                                                               ],
  0x23E2..0x23E7        => [ "Common",  "So",   "  [6]",        "WHITE TRAPEZIUM..ELECTRICAL INTERSECTION",                                                                     ],
  0x2400..0x2426        => [ "Common",  "So",   " [39]",        "SYMBOL FOR NULL..SYMBOL FOR SUBSTITUTE FORM TWO",                                                              ],
  0x2440..0x244A        => [ "Common",  "So",   " [11]",        "OCR HOOK..OCR DOUBLE BACKSLASH",                                                                               ],
  0x2460..0x249B        => [ "Common",  "No",   " [60]",        "CIRCLED DIGIT ONE..NUMBER TWENTY FULL STOP",                                                                   ],
  0x249C..0x24E9        => [ "Common",  "So",   " [78]",        "PARENTHESIZED LATIN SMALL LETTER A..CIRCLED LATIN SMALL LETTER Z",                                             ],
  0x24EA..0x24FF        => [ "Common",  "No",   " [22]",        "CIRCLED DIGIT ZERO..NEGATIVE CIRCLED DIGIT ZERO",                                                              ],
  0x2500..0x25B6        => [ "Common",  "So",   "[183]",        "BOX DRAWINGS LIGHT HORIZONTAL..BLACK RIGHT-POINTING TRIANGLE",                                                 ],
  0x25B7                => [ "Common",  "Sm",   "     ",        "WHITE RIGHT-POINTING TRIANGLE",                                                                                ],
  0x25B8..0x25C0        => [ "Common",  "So",   "  [9]",        "BLACK RIGHT-POINTING SMALL TRIANGLE..BLACK LEFT-POINTING TRIANGLE",                                            ],
  0x25C1                => [ "Common",  "Sm",   "     ",        "WHITE LEFT-POINTING TRIANGLE",                                                                                 ],
  0x25C2..0x25F7        => [ "Common",  "So",   " [54]",        "BLACK LEFT-POINTING SMALL TRIANGLE..WHITE CIRCLE WITH UPPER RIGHT QUADRANT",                                   ],
  0x25F8..0x25FF        => [ "Common",  "Sm",   "  [8]",        "UPPER LEFT TRIANGLE..LOWER RIGHT TRIANGLE",                                                                    ],
  0x2600..0x266E        => [ "Common",  "So",   "[111]",        "BLACK SUN WITH RAYS..MUSIC NATURAL SIGN",                                                                      ],
  0x266F                => [ "Common",  "Sm",   "     ",        "MUSIC SHARP SIGN",                                                                                             ],
  0x2670..0x269D        => [ "Common",  "So",   " [46]",        "WEST SYRIAC CROSS..OUTLINED WHITE STAR",                                                                       ],
  0x26A0..0x26BC        => [ "Common",  "So",   " [29]",        "WARNING SIGN..SESQUIQUADRATE",                                                                                 ],
  0x26C0..0x26C3        => [ "Common",  "So",   "  [4]",        "WHITE DRAUGHTS MAN..BLACK DRAUGHTS KING",                                                                      ],
  0x2701..0x2704        => [ "Common",  "So",   "  [4]",        "UPPER BLADE SCISSORS..WHITE SCISSORS",                                                                         ],
  0x2706..0x2709        => [ "Common",  "So",   "  [4]",        "TELEPHONE LOCATION SIGN..ENVELOPE",                                                                            ],
  0x270C..0x2727        => [ "Common",  "So",   " [28]",        "VICTORY HAND..WHITE FOUR POINTED STAR",                                                                        ],
  0x2729..0x274B        => [ "Common",  "So",   " [35]",        "STRESS OUTLINED WHITE STAR..HEAVY EIGHT TEARDROP-SPOKED PROPELLER ASTERISK",                                   ],
  0x274D                => [ "Common",  "So",   "     ",        "SHADOWED WHITE CIRCLE",                                                                                        ],
  0x274F..0x2752        => [ "Common",  "So",   "  [4]",        "LOWER RIGHT DROP-SHADOWED WHITE SQUARE..UPPER RIGHT SHADOWED WHITE SQUARE",                                    ],
  0x2756                => [ "Common",  "So",   "     ",        "BLACK DIAMOND MINUS WHITE X",                                                                                  ],
  0x2758..0x275E        => [ "Common",  "So",   "  [7]",        "LIGHT VERTICAL BAR..HEAVY DOUBLE COMMA QUOTATION MARK ORNAMENT",                                               ],
  0x2761..0x2767        => [ "Common",  "So",   "  [7]",        "CURVED STEM PARAGRAPH SIGN ORNAMENT..ROTATED FLORAL HEART BULLET",                                             ],
  0x2768                => [ "Common",  "Ps",   "     ",        "MEDIUM LEFT PARENTHESIS ORNAMENT",                                                                             ],
  0x2769                => [ "Common",  "Pe",   "     ",        "MEDIUM RIGHT PARENTHESIS ORNAMENT",                                                                            ],
  0x276A                => [ "Common",  "Ps",   "     ",        "MEDIUM FLATTENED LEFT PARENTHESIS ORNAMENT",                                                                   ],
  0x276B                => [ "Common",  "Pe",   "     ",        "MEDIUM FLATTENED RIGHT PARENTHESIS ORNAMENT",                                                                  ],
  0x276C                => [ "Common",  "Ps",   "     ",        "MEDIUM LEFT-POINTING ANGLE BRACKET ORNAMENT",                                                                  ],
  0x276D                => [ "Common",  "Pe",   "     ",        "MEDIUM RIGHT-POINTING ANGLE BRACKET ORNAMENT",                                                                 ],
  0x276E                => [ "Common",  "Ps",   "     ",        "HEAVY LEFT-POINTING ANGLE QUOTATION MARK ORNAMENT",                                                            ],
  0x276F                => [ "Common",  "Pe",   "     ",        "HEAVY RIGHT-POINTING ANGLE QUOTATION MARK ORNAMENT",                                                           ],
  0x2770                => [ "Common",  "Ps",   "     ",        "HEAVY LEFT-POINTING ANGLE BRACKET ORNAMENT",                                                                   ],
  0x2771                => [ "Common",  "Pe",   "     ",        "HEAVY RIGHT-POINTING ANGLE BRACKET ORNAMENT",                                                                  ],
  0x2772                => [ "Common",  "Ps",   "     ",        "LIGHT LEFT TORTOISE SHELL BRACKET ORNAMENT",                                                                   ],
  0x2773                => [ "Common",  "Pe",   "     ",        "LIGHT RIGHT TORTOISE SHELL BRACKET ORNAMENT",                                                                  ],
  0x2774                => [ "Common",  "Ps",   "     ",        "MEDIUM LEFT CURLY BRACKET ORNAMENT",                                                                           ],
  0x2775                => [ "Common",  "Pe",   "     ",        "MEDIUM RIGHT CURLY BRACKET ORNAMENT",                                                                          ],
  0x2776..0x2793        => [ "Common",  "No",   " [30]",        "DINGBAT NEGATIVE CIRCLED DIGIT ONE..DINGBAT NEGATIVE CIRCLED SANS-SERIF NUMBER TEN",                           ],
  0x2794                => [ "Common",  "So",   "     ",        "HEAVY WIDE-HEADED RIGHTWARDS ARROW",                                                                           ],
  0x2798..0x27AF        => [ "Common",  "So",   " [24]",        "HEAVY SOUTH EAST ARROW..NOTCHED LOWER RIGHT-SHADOWED WHITE RIGHTWARDS ARROW",                                  ],
  0x27B1..0x27BE        => [ "Common",  "So",   " [14]",        "NOTCHED UPPER RIGHT-SHADOWED WHITE RIGHTWARDS ARROW..OPEN-OUTLINED RIGHTWARDS ARROW",                          ],
  0x27C0..0x27C4        => [ "Common",  "Sm",   "  [5]",        "THREE DIMENSIONAL ANGLE..OPEN SUPERSET",                                                                       ],
  0x27C5                => [ "Common",  "Ps",   "     ",        "LEFT S-SHAPED BAG DELIMITER",                                                                                  ],
  0x27C6                => [ "Common",  "Pe",   "     ",        "RIGHT S-SHAPED BAG DELIMITER",                                                                                 ],
  0x27C7..0x27CA        => [ "Common",  "Sm",   "  [4]",        "OR WITH DOT INSIDE..VERTICAL BAR WITH HORIZONTAL STROKE",                                                      ],
  0x27CC                => [ "Common",  "Sm",   "     ",        "LONG DIVISION",                                                                                                ],
  0x27D0..0x27E5        => [ "Common",  "Sm",   " [22]",        "WHITE DIAMOND WITH CENTRED DOT..WHITE SQUARE WITH RIGHTWARDS TICK",                                            ],
  0x27E6                => [ "Common",  "Ps",   "     ",        "MATHEMATICAL LEFT WHITE SQUARE BRACKET",                                                                       ],
  0x27E7                => [ "Common",  "Pe",   "     ",        "MATHEMATICAL RIGHT WHITE SQUARE BRACKET",                                                                      ],
  0x27E8                => [ "Common",  "Ps",   "     ",        "MATHEMATICAL LEFT ANGLE BRACKET",                                                                              ],
  0x27E9                => [ "Common",  "Pe",   "     ",        "MATHEMATICAL RIGHT ANGLE BRACKET",                                                                             ],
  0x27EA                => [ "Common",  "Ps",   "     ",        "MATHEMATICAL LEFT DOUBLE ANGLE BRACKET",                                                                       ],
  0x27EB                => [ "Common",  "Pe",   "     ",        "MATHEMATICAL RIGHT DOUBLE ANGLE BRACKET",                                                                      ],
  0x27EC                => [ "Common",  "Ps",   "     ",        "MATHEMATICAL LEFT WHITE TORTOISE SHELL BRACKET",                                                               ],
  0x27ED                => [ "Common",  "Pe",   "     ",        "MATHEMATICAL RIGHT WHITE TORTOISE SHELL BRACKET",                                                              ],
  0x27EE                => [ "Common",  "Ps",   "     ",        "MATHEMATICAL LEFT FLATTENED PARENTHESIS",                                                                      ],
  0x27EF                => [ "Common",  "Pe",   "     ",        "MATHEMATICAL RIGHT FLATTENED PARENTHESIS",                                                                     ],
  0x27F0..0x27FF        => [ "Common",  "Sm",   " [16]",        "UPWARDS QUADRUPLE ARROW..LONG RIGHTWARDS SQUIGGLE ARROW",                                                      ],
  0x2900..0x2982        => [ "Common",  "Sm",   "[131]",        "RIGHTWARDS TWO-HEADED ARROW WITH VERTICAL STROKE..Z NOTATION TYPE COLON",                                      ],
  0x2983                => [ "Common",  "Ps",   "     ",        "LEFT WHITE CURLY BRACKET",                                                                                     ],
  0x2984                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE CURLY BRACKET",                                                                                    ],
  0x2985                => [ "Common",  "Ps",   "     ",        "LEFT WHITE PARENTHESIS",                                                                                       ],
  0x2986                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE PARENTHESIS",                                                                                      ],
  0x2987                => [ "Common",  "Ps",   "     ",        "Z NOTATION LEFT IMAGE BRACKET",                                                                                ],
  0x2988                => [ "Common",  "Pe",   "     ",        "Z NOTATION RIGHT IMAGE BRACKET",                                                                               ],
  0x2989                => [ "Common",  "Ps",   "     ",        "Z NOTATION LEFT BINDING BRACKET",                                                                              ],
  0x298A                => [ "Common",  "Pe",   "     ",        "Z NOTATION RIGHT BINDING BRACKET",                                                                             ],
  0x298B                => [ "Common",  "Ps",   "     ",        "LEFT SQUARE BRACKET WITH UNDERBAR",                                                                            ],
  0x298C                => [ "Common",  "Pe",   "     ",        "RIGHT SQUARE BRACKET WITH UNDERBAR",                                                                           ],
  0x298D                => [ "Common",  "Ps",   "     ",        "LEFT SQUARE BRACKET WITH TICK IN TOP CORNER",                                                                  ],
  0x298E                => [ "Common",  "Pe",   "     ",        "RIGHT SQUARE BRACKET WITH TICK IN BOTTOM CORNER",                                                              ],
  0x298F                => [ "Common",  "Ps",   "     ",        "LEFT SQUARE BRACKET WITH TICK IN BOTTOM CORNER",                                                               ],
  0x2990                => [ "Common",  "Pe",   "     ",        "RIGHT SQUARE BRACKET WITH TICK IN TOP CORNER",                                                                 ],
  0x2991                => [ "Common",  "Ps",   "     ",        "LEFT ANGLE BRACKET WITH DOT",                                                                                  ],
  0x2992                => [ "Common",  "Pe",   "     ",        "RIGHT ANGLE BRACKET WITH DOT",                                                                                 ],
  0x2993                => [ "Common",  "Ps",   "     ",        "LEFT ARC LESS-THAN BRACKET",                                                                                   ],
  0x2994                => [ "Common",  "Pe",   "     ",        "RIGHT ARC GREATER-THAN BRACKET",                                                                               ],
  0x2995                => [ "Common",  "Ps",   "     ",        "DOUBLE LEFT ARC GREATER-THAN BRACKET",                                                                         ],
  0x2996                => [ "Common",  "Pe",   "     ",        "DOUBLE RIGHT ARC LESS-THAN BRACKET",                                                                           ],
  0x2997                => [ "Common",  "Ps",   "     ",        "LEFT BLACK TORTOISE SHELL BRACKET",                                                                            ],
  0x2998                => [ "Common",  "Pe",   "     ",        "RIGHT BLACK TORTOISE SHELL BRACKET",                                                                           ],
  0x2999..0x29D7        => [ "Common",  "Sm",   " [63]",        "DOTTED FENCE..BLACK HOURGLASS",                                                                                ],
  0x29D8                => [ "Common",  "Ps",   "     ",        "LEFT WIGGLY FENCE",                                                                                            ],
  0x29D9                => [ "Common",  "Pe",   "     ",        "RIGHT WIGGLY FENCE",                                                                                           ],
  0x29DA                => [ "Common",  "Ps",   "     ",        "LEFT DOUBLE WIGGLY FENCE",                                                                                     ],
  0x29DB                => [ "Common",  "Pe",   "     ",        "RIGHT DOUBLE WIGGLY FENCE",                                                                                    ],
  0x29DC..0x29FB        => [ "Common",  "Sm",   " [32]",        "INCOMPLETE INFINITY..TRIPLE PLUS",                                                                             ],
  0x29FC                => [ "Common",  "Ps",   "     ",        "LEFT-POINTING CURVED ANGLE BRACKET",                                                                           ],
  0x29FD                => [ "Common",  "Pe",   "     ",        "RIGHT-POINTING CURVED ANGLE BRACKET",                                                                          ],
  0x29FE..0x2AFF        => [ "Common",  "Sm",   "[258]",        "TINY..N-ARY WHITE VERTICAL BAR",                                                                               ],
  0x2B00..0x2B2F        => [ "Common",  "So",   " [48]",        "NORTH EAST WHITE ARROW..WHITE VERTICAL ELLIPSE",                                                               ],
  0x2B30..0x2B44        => [ "Common",  "Sm",   " [21]",        "LEFT ARROW WITH SMALL CIRCLE..RIGHTWARDS ARROW THROUGH SUPERSET",                                              ],
  0x2B45..0x2B46        => [ "Common",  "So",   "  [2]",        "LEFTWARDS QUADRUPLE ARROW..RIGHTWARDS QUADRUPLE ARROW",                                                        ],
  0x2B47..0x2B4C        => [ "Common",  "Sm",   "  [6]",        "REVERSE TILDE OPERATOR ABOVE RIGHTWARDS ARROW..RIGHTWARDS ARROW ABOVE REVERSE TILDE OPERATOR",                 ],
  0x2B50..0x2B54        => [ "Common",  "So",   "  [5]",        "WHITE MEDIUM STAR..WHITE RIGHT-POINTING PENTAGON",                                                             ],
  0x2E00..0x2E01        => [ "Common",  "Po",   "  [2]",        "RIGHT ANGLE SUBSTITUTION MARKER..RIGHT ANGLE DOTTED SUBSTITUTION MARKER",                                      ],
  0x2E02                => [ "Common",  "Pi",   "     ",        "LEFT SUBSTITUTION BRACKET",                                                                                    ],
  0x2E03                => [ "Common",  "Pf",   "     ",        "RIGHT SUBSTITUTION BRACKET",                                                                                   ],
  0x2E04                => [ "Common",  "Pi",   "     ",        "LEFT DOTTED SUBSTITUTION BRACKET",                                                                             ],
  0x2E05                => [ "Common",  "Pf",   "     ",        "RIGHT DOTTED SUBSTITUTION BRACKET",                                                                            ],
  0x2E06..0x2E08        => [ "Common",  "Po",   "  [3]",        "RAISED INTERPOLATION MARKER..DOTTED TRANSPOSITION MARKER",                                                     ],
  0x2E09                => [ "Common",  "Pi",   "     ",        "LEFT TRANSPOSITION BRACKET",                                                                                   ],
  0x2E0A                => [ "Common",  "Pf",   "     ",        "RIGHT TRANSPOSITION BRACKET",                                                                                  ],
  0x2E0B                => [ "Common",  "Po",   "     ",        "RAISED SQUARE",                                                                                                ],
  0x2E0C                => [ "Common",  "Pi",   "     ",        "LEFT RAISED OMISSION BRACKET",                                                                                 ],
  0x2E0D                => [ "Common",  "Pf",   "     ",        "RIGHT RAISED OMISSION BRACKET",                                                                                ],
  0x2E0E..0x2E16        => [ "Common",  "Po",   "  [9]",        "EDITORIAL CORONIS..DOTTED RIGHT-POINTING ANGLE",                                                               ],
  0x2E17                => [ "Common",  "Pd",   "     ",        "DOUBLE OBLIQUE HYPHEN",                                                                                        ],
  0x2E18..0x2E19        => [ "Common",  "Po",   "  [2]",        "INVERTED INTERROBANG..PALM BRANCH",                                                                            ],
  0x2E1A                => [ "Common",  "Pd",   "     ",        "HYPHEN WITH DIAERESIS",                                                                                        ],
  0x2E1B                => [ "Common",  "Po",   "     ",        "TILDE WITH RING ABOVE",                                                                                        ],
  0x2E1C                => [ "Common",  "Pi",   "     ",        "LEFT LOW PARAPHRASE BRACKET",                                                                                  ],
  0x2E1D                => [ "Common",  "Pf",   "     ",        "RIGHT LOW PARAPHRASE BRACKET",                                                                                 ],
  0x2E1E..0x2E1F        => [ "Common",  "Po",   "  [2]",        "TILDE WITH DOT ABOVE..TILDE WITH DOT BELOW",                                                                   ],
  0x2E20                => [ "Common",  "Pi",   "     ",        "LEFT VERTICAL BAR WITH QUILL",                                                                                 ],
  0x2E21                => [ "Common",  "Pf",   "     ",        "RIGHT VERTICAL BAR WITH QUILL",                                                                                ],
  0x2E22                => [ "Common",  "Ps",   "     ",        "TOP LEFT HALF BRACKET",                                                                                        ],
  0x2E23                => [ "Common",  "Pe",   "     ",        "TOP RIGHT HALF BRACKET",                                                                                       ],
  0x2E24                => [ "Common",  "Ps",   "     ",        "BOTTOM LEFT HALF BRACKET",                                                                                     ],
  0x2E25                => [ "Common",  "Pe",   "     ",        "BOTTOM RIGHT HALF BRACKET",                                                                                    ],
  0x2E26                => [ "Common",  "Ps",   "     ",        "LEFT SIDEWAYS U BRACKET",                                                                                      ],
  0x2E27                => [ "Common",  "Pe",   "     ",        "RIGHT SIDEWAYS U BRACKET",                                                                                     ],
  0x2E28                => [ "Common",  "Ps",   "     ",        "LEFT DOUBLE PARENTHESIS",                                                                                      ],
  0x2E29                => [ "Common",  "Pe",   "     ",        "RIGHT DOUBLE PARENTHESIS",                                                                                     ],
  0x2E2A..0x2E2E        => [ "Common",  "Po",   "  [5]",        "TWO DOTS OVER ONE DOT PUNCTUATION..REVERSED QUESTION MARK",                                                    ],
  0x2E2F                => [ "Common",  "Lm",   "     ",        "VERTICAL TILDE",                                                                                               ],
  0x2E30                => [ "Common",  "Po",   "     ",        "RING POINT",                                                                                                   ],
  0x2FF0..0x2FFB        => [ "Common",  "So",   " [12]",        "IDEOGRAPHIC DESCRIPTION CHARACTER LEFT TO RIGHT..IDEOGRAPHIC DESCRIPTION CHARACTER OVERLAID",                  ],
  0x3000                => [ "Common",  "Zs",   "     ",        "IDEOGRAPHIC SPACE",                                                                                            ],
  0x3001..0x3003        => [ "Common",  "Po",   "  [3]",        "IDEOGRAPHIC COMMA..DITTO MARK",                                                                                ],
  0x3004                => [ "Common",  "So",   "     ",        "JAPANESE INDUSTRIAL STANDARD SYMBOL",                                                                          ],
  0x3006                => [ "Common",  "Lo",   "     ",        "IDEOGRAPHIC CLOSING MARK",                                                                                     ],
  0x3008                => [ "Common",  "Ps",   "     ",        "LEFT ANGLE BRACKET",                                                                                           ],
  0x3009                => [ "Common",  "Pe",   "     ",        "RIGHT ANGLE BRACKET",                                                                                          ],
  0x300A                => [ "Common",  "Ps",   "     ",        "LEFT DOUBLE ANGLE BRACKET",                                                                                    ],
  0x300B                => [ "Common",  "Pe",   "     ",        "RIGHT DOUBLE ANGLE BRACKET",                                                                                   ],
  0x300C                => [ "Common",  "Ps",   "     ",        "LEFT CORNER BRACKET",                                                                                          ],
  0x300D                => [ "Common",  "Pe",   "     ",        "RIGHT CORNER BRACKET",                                                                                         ],
  0x300E                => [ "Common",  "Ps",   "     ",        "LEFT WHITE CORNER BRACKET",                                                                                    ],
  0x300F                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE CORNER BRACKET",                                                                                   ],
  0x3010                => [ "Common",  "Ps",   "     ",        "LEFT BLACK LENTICULAR BRACKET",                                                                                ],
  0x3011                => [ "Common",  "Pe",   "     ",        "RIGHT BLACK LENTICULAR BRACKET",                                                                               ],
  0x3012..0x3013        => [ "Common",  "So",   "  [2]",        "POSTAL MARK..GETA MARK",                                                                                       ],
  0x3014                => [ "Common",  "Ps",   "     ",        "LEFT TORTOISE SHELL BRACKET",                                                                                  ],
  0x3015                => [ "Common",  "Pe",   "     ",        "RIGHT TORTOISE SHELL BRACKET",                                                                                 ],
  0x3016                => [ "Common",  "Ps",   "     ",        "LEFT WHITE LENTICULAR BRACKET",                                                                                ],
  0x3017                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE LENTICULAR BRACKET",                                                                               ],
  0x3018                => [ "Common",  "Ps",   "     ",        "LEFT WHITE TORTOISE SHELL BRACKET",                                                                            ],
  0x3019                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE TORTOISE SHELL BRACKET",                                                                           ],
  0x301A                => [ "Common",  "Ps",   "     ",        "LEFT WHITE SQUARE BRACKET",                                                                                    ],
  0x301B                => [ "Common",  "Pe",   "     ",        "RIGHT WHITE SQUARE BRACKET",                                                                                   ],
  0x301C                => [ "Common",  "Pd",   "     ",        "WAVE DASH",                                                                                                    ],
  0x301D                => [ "Common",  "Ps",   "     ",        "REVERSED DOUBLE PRIME QUOTATION MARK",                                                                         ],
  0x301E..0x301F        => [ "Common",  "Pe",   "  [2]",        "DOUBLE PRIME QUOTATION MARK..LOW DOUBLE PRIME QUOTATION MARK",                                                 ],
  0x3020                => [ "Common",  "So",   "     ",        "POSTAL MARK FACE",                                                                                             ],
  0x3030                => [ "Common",  "Pd",   "     ",        "WAVY DASH",                                                                                                    ],
  0x3031..0x3035        => [ "Common",  "Lm",   "  [5]",        "VERTICAL KANA REPEAT MARK..VERTICAL KANA REPEAT MARK LOWER HALF",                                              ],
  0x3036..0x3037        => [ "Common",  "So",   "  [2]",        "CIRCLED POSTAL MARK..IDEOGRAPHIC TELEGRAPH LINE FEED SEPARATOR SYMBOL",                                        ],
  0x303C                => [ "Common",  "Lo",   "     ",        "MASU MARK",                                                                                                    ],
  0x303D                => [ "Common",  "Po",   "     ",        "PART ALTERNATION MARK",                                                                                        ],
  0x303E..0x303F        => [ "Common",  "So",   "  [2]",        "IDEOGRAPHIC VARIATION INDICATOR..IDEOGRAPHIC HALF FILL SPACE",                                                 ],
  0x309B..0x309C        => [ "Common",  "Sk",   "  [2]",        "KATAKANA-HIRAGANA VOICED SOUND MARK..KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK",                                ],
  0x30A0                => [ "Common",  "Pd",   "     ",        "KATAKANA-HIRAGANA DOUBLE HYPHEN",                                                                              ],
  0x30FB                => [ "Common",  "Po",   "     ",        "KATAKANA MIDDLE DOT",                                                                                          ],
  0x30FC                => [ "Common",  "Lm",   "     ",        "KATAKANA-HIRAGANA PROLONGED SOUND MARK",                                                                       ],
  0x3190..0x3191        => [ "Common",  "So",   "  [2]",        "IDEOGRAPHIC ANNOTATION LINKING MARK..IDEOGRAPHIC ANNOTATION REVERSE MARK",                                     ],
  0x3192..0x3195        => [ "Common",  "No",   "  [4]",        "IDEOGRAPHIC ANNOTATION ONE MARK..IDEOGRAPHIC ANNOTATION FOUR MARK",                                            ],
  0x3196..0x319F        => [ "Common",  "So",   " [10]",        "IDEOGRAPHIC ANNOTATION TOP MARK..IDEOGRAPHIC ANNOTATION MAN MARK",                                             ],
  0x31C0..0x31E3        => [ "Common",  "So",   " [36]",        "CJK STROKE T..CJK STROKE Q",                                                                                   ],
  0x3220..0x3229        => [ "Common",  "No",   " [10]",        "PARENTHESIZED IDEOGRAPH ONE..PARENTHESIZED IDEOGRAPH TEN",                                                     ],
  0x322A..0x3243        => [ "Common",  "So",   " [26]",        "PARENTHESIZED IDEOGRAPH MOON..PARENTHESIZED IDEOGRAPH REACH",                                                  ],
  0x3250                => [ "Common",  "So",   "     ",        "PARTNERSHIP SIGN",                                                                                             ],
  0x3251..0x325F        => [ "Common",  "No",   " [15]",        "CIRCLED NUMBER TWENTY ONE..CIRCLED NUMBER THIRTY FIVE",                                                        ],
  0x327F                => [ "Common",  "So",   "     ",        "KOREAN STANDARD SYMBOL",                                                                                       ],
  0x3280..0x3289        => [ "Common",  "No",   " [10]",        "CIRCLED IDEOGRAPH ONE..CIRCLED IDEOGRAPH TEN",                                                                 ],
  0x328A..0x32B0        => [ "Common",  "So",   " [39]",        "CIRCLED IDEOGRAPH MOON..CIRCLED IDEOGRAPH NIGHT",                                                              ],
  0x32B1..0x32BF        => [ "Common",  "No",   " [15]",        "CIRCLED NUMBER THIRTY SIX..CIRCLED NUMBER FIFTY",                                                              ],
  0x32C0..0x32CF        => [ "Common",  "So",   " [16]",        "IDEOGRAPHIC TELEGRAPH SYMBOL FOR JANUARY..LIMITED LIABILITY SIGN",                                             ],
  0x3358..0x33FF        => [ "Common",  "So",   "[168]",        "IDEOGRAPHIC TELEGRAPH SYMBOL FOR HOUR ZERO..SQUARE GAL",                                                       ],
  0x4DC0..0x4DFF        => [ "Common",  "So",   " [64]",        "HEXAGRAM FOR THE CREATIVE HEAVEN..HEXAGRAM FOR BEFORE COMPLETION",                                             ],
  0xA700..0xA716        => [ "Common",  "Sk",   " [23]",        "MODIFIER LETTER CHINESE TONE YIN PING..MODIFIER LETTER EXTRA-LOW LEFT-STEM TONE BAR",                          ],
  0xA717..0xA71F        => [ "Common",  "Lm",   "  [9]",        "MODIFIER LETTER DOT VERTICAL BAR..MODIFIER LETTER LOW INVERTED EXCLAMATION MARK",                              ],
  0xA720..0xA721        => [ "Common",  "Sk",   "  [2]",        "MODIFIER LETTER STRESS AND HIGH TONE..MODIFIER LETTER STRESS AND LOW TONE",                                    ],
  0xA788                => [ "Common",  "Lm",   "     ",        "MODIFIER LETTER LOW CIRCUMFLEX ACCENT",                                                                        ],
  0xA789..0xA78A        => [ "Common",  "Sk",   "  [2]",        "MODIFIER LETTER COLON..MODIFIER LETTER SHORT EQUALS SIGN",                                                     ],
  0xFD3E                => [ "Common",  "Ps",   "     ",        "ORNATE LEFT PARENTHESIS",                                                                                      ],
  0xFD3F                => [ "Common",  "Pe",   "     ",        "ORNATE RIGHT PARENTHESIS",                                                                                     ],
  0xFDFD                => [ "Common",  "So",   "     ",        "ARABIC LIGATURE BISMILLAH AR-RAHMAN AR-RAHEEM",                                                                ],
  0xFE10..0xFE16        => [ "Common",  "Po",   "  [7]",        "PRESENTATION FORM FOR VERTICAL COMMA..PRESENTATION FORM FOR VERTICAL QUESTION MARK",                           ],
  0xFE17                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT WHITE LENTICULAR BRACKET",                                                 ],
  0xFE18                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT WHITE LENTICULAR BRAKCET",                                                ],
  0xFE19                => [ "Common",  "Po",   "     ",        "PRESENTATION FORM FOR VERTICAL HORIZONTAL ELLIPSIS",                                                           ],
  0xFE30                => [ "Common",  "Po",   "     ",        "PRESENTATION FORM FOR VERTICAL TWO DOT LEADER",                                                                ],
  0xFE31..0xFE32        => [ "Common",  "Pd",   "  [2]",        "PRESENTATION FORM FOR VERTICAL EM DASH..PRESENTATION FORM FOR VERTICAL EN DASH",                               ],
  0xFE33..0xFE34        => [ "Common",  "Pc",   "  [2]",        "PRESENTATION FORM FOR VERTICAL LOW LINE..PRESENTATION FORM FOR VERTICAL WAVY LOW LINE",                        ],
  0xFE35                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT PARENTHESIS",                                                              ],
  0xFE36                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT PARENTHESIS",                                                             ],
  0xFE37                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT CURLY BRACKET",                                                            ],
  0xFE38                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT CURLY BRACKET",                                                           ],
  0xFE39                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT TORTOISE SHELL BRACKET",                                                   ],
  0xFE3A                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT TORTOISE SHELL BRACKET",                                                  ],
  0xFE3B                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT BLACK LENTICULAR BRACKET",                                                 ],
  0xFE3C                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT BLACK LENTICULAR BRACKET",                                                ],
  0xFE3D                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT DOUBLE ANGLE BRACKET",                                                     ],
  0xFE3E                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT DOUBLE ANGLE BRACKET",                                                    ],
  0xFE3F                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT ANGLE BRACKET",                                                            ],
  0xFE40                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT ANGLE BRACKET",                                                           ],
  0xFE41                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT CORNER BRACKET",                                                           ],
  0xFE42                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT CORNER BRACKET",                                                          ],
  0xFE43                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT WHITE CORNER BRACKET",                                                     ],
  0xFE44                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT WHITE CORNER BRACKET",                                                    ],
  0xFE45..0xFE46        => [ "Common",  "Po",   "  [2]",        "SESAME DOT..WHITE SESAME DOT",                                                                                 ],
  0xFE47                => [ "Common",  "Ps",   "     ",        "PRESENTATION FORM FOR VERTICAL LEFT SQUARE BRACKET",                                                           ],
  0xFE48                => [ "Common",  "Pe",   "     ",        "PRESENTATION FORM FOR VERTICAL RIGHT SQUARE BRACKET",                                                          ],
  0xFE49..0xFE4C        => [ "Common",  "Po",   "  [4]",        "DASHED OVERLINE..DOUBLE WAVY OVERLINE",                                                                        ],
  0xFE4D..0xFE4F        => [ "Common",  "Pc",   "  [3]",        "DASHED LOW LINE..WAVY LOW LINE",                                                                               ],
  0xFE50..0xFE52        => [ "Common",  "Po",   "  [3]",        "SMALL COMMA..SMALL FULL STOP",                                                                                 ],
  0xFE54..0xFE57        => [ "Common",  "Po",   "  [4]",        "SMALL SEMICOLON..SMALL EXCLAMATION MARK",                                                                      ],
  0xFE58                => [ "Common",  "Pd",   "     ",        "SMALL EM DASH",                                                                                                ],
  0xFE59                => [ "Common",  "Ps",   "     ",        "SMALL LEFT PARENTHESIS",                                                                                       ],
  0xFE5A                => [ "Common",  "Pe",   "     ",        "SMALL RIGHT PARENTHESIS",                                                                                      ],
  0xFE5B                => [ "Common",  "Ps",   "     ",        "SMALL LEFT CURLY BRACKET",                                                                                     ],
  0xFE5C                => [ "Common",  "Pe",   "     ",        "SMALL RIGHT CURLY BRACKET",                                                                                    ],
  0xFE5D                => [ "Common",  "Ps",   "     ",        "SMALL LEFT TORTOISE SHELL BRACKET",                                                                            ],
  0xFE5E                => [ "Common",  "Pe",   "     ",        "SMALL RIGHT TORTOISE SHELL BRACKET",                                                                           ],
  0xFE5F..0xFE61        => [ "Common",  "Po",   "  [3]",        "SMALL NUMBER SIGN..SMALL ASTERISK",                                                                            ],
  0xFE62                => [ "Common",  "Sm",   "     ",        "SMALL PLUS SIGN",                                                                                              ],
  0xFE63                => [ "Common",  "Pd",   "     ",        "SMALL HYPHEN-MINUS",                                                                                           ],
  0xFE64..0xFE66        => [ "Common",  "Sm",   "  [3]",        "SMALL LESS-THAN SIGN..SMALL EQUALS SIGN",                                                                      ],
  0xFE68                => [ "Common",  "Po",   "     ",        "SMALL REVERSE SOLIDUS",                                                                                        ],
  0xFE69                => [ "Common",  "Sc",   "     ",        "SMALL DOLLAR SIGN",                                                                                            ],
  0xFE6A..0xFE6B        => [ "Common",  "Po",   "  [2]",        "SMALL PERCENT SIGN..SMALL COMMERCIAL AT",                                                                      ],
  0xFEFF                => [ "Common",  "Cf",   "     ",        "ZERO WIDTH NO-BREAK SPACE",                                                                                    ],
  0xFF01..0xFF03        => [ "Common",  "Po",   "  [3]",        "FULLWIDTH EXCLAMATION MARK..FULLWIDTH NUMBER SIGN",                                                            ],
  0xFF04                => [ "Common",  "Sc",   "     ",        "FULLWIDTH DOLLAR SIGN",                                                                                        ],
  0xFF05..0xFF07        => [ "Common",  "Po",   "  [3]",        "FULLWIDTH PERCENT SIGN..FULLWIDTH APOSTROPHE",                                                                 ],
  0xFF08                => [ "Common",  "Ps",   "     ",        "FULLWIDTH LEFT PARENTHESIS",                                                                                   ],
  0xFF09                => [ "Common",  "Pe",   "     ",        "FULLWIDTH RIGHT PARENTHESIS",                                                                                  ],
  0xFF0A                => [ "Common",  "Po",   "     ",        "FULLWIDTH ASTERISK",                                                                                           ],
  0xFF0B                => [ "Common",  "Sm",   "     ",        "FULLWIDTH PLUS SIGN",                                                                                          ],
  0xFF0C                => [ "Common",  "Po",   "     ",        "FULLWIDTH COMMA",                                                                                              ],
  0xFF0D                => [ "Common",  "Pd",   "     ",        "FULLWIDTH HYPHEN-MINUS",                                                                                       ],
  0xFF0E..0xFF0F        => [ "Common",  "Po",   "  [2]",        "FULLWIDTH FULL STOP..FULLWIDTH SOLIDUS",                                                                       ],
  0xFF10..0xFF19        => [ "Common",  "Nd",   " [10]",        "FULLWIDTH DIGIT ZERO..FULLWIDTH DIGIT NINE",                                                                   ],
  0xFF1A..0xFF1B        => [ "Common",  "Po",   "  [2]",        "FULLWIDTH COLON..FULLWIDTH SEMICOLON",                                                                         ],
  0xFF1C..0xFF1E        => [ "Common",  "Sm",   "  [3]",        "FULLWIDTH LESS-THAN SIGN..FULLWIDTH GREATER-THAN SIGN",                                                        ],
  0xFF1F..0xFF20        => [ "Common",  "Po",   "  [2]",        "FULLWIDTH QUESTION MARK..FULLWIDTH COMMERCIAL AT",                                                             ],
  0xFF3B                => [ "Common",  "Ps",   "     ",        "FULLWIDTH LEFT SQUARE BRACKET",                                                                                ],
  0xFF3C                => [ "Common",  "Po",   "     ",        "FULLWIDTH REVERSE SOLIDUS",                                                                                    ],
  0xFF3D                => [ "Common",  "Pe",   "     ",        "FULLWIDTH RIGHT SQUARE BRACKET",                                                                               ],
  0xFF3E                => [ "Common",  "Sk",   "     ",        "FULLWIDTH CIRCUMFLEX ACCENT",                                                                                  ],
  0xFF3F                => [ "Common",  "Pc",   "     ",        "FULLWIDTH LOW LINE",                                                                                           ],
  0xFF40                => [ "Common",  "Sk",   "     ",        "FULLWIDTH GRAVE ACCENT",                                                                                       ],
  0xFF5B                => [ "Common",  "Ps",   "     ",        "FULLWIDTH LEFT CURLY BRACKET",                                                                                 ],
  0xFF5C                => [ "Common",  "Sm",   "     ",        "FULLWIDTH VERTICAL LINE",                                                                                      ],
  0xFF5D                => [ "Common",  "Pe",   "     ",        "FULLWIDTH RIGHT CURLY BRACKET",                                                                                ],
  0xFF5E                => [ "Common",  "Sm",   "     ",        "FULLWIDTH TILDE",                                                                                              ],
  0xFF5F                => [ "Common",  "Ps",   "     ",        "FULLWIDTH LEFT WHITE PARENTHESIS",                                                                             ],
  0xFF60                => [ "Common",  "Pe",   "     ",        "FULLWIDTH RIGHT WHITE PARENTHESIS",                                                                            ],
  0xFF61                => [ "Common",  "Po",   "     ",        "HALFWIDTH IDEOGRAPHIC FULL STOP",                                                                              ],
  0xFF62                => [ "Common",  "Ps",   "     ",        "HALFWIDTH LEFT CORNER BRACKET",                                                                                ],
  0xFF63                => [ "Common",  "Pe",   "     ",        "HALFWIDTH RIGHT CORNER BRACKET",                                                                               ],
  0xFF64..0xFF65        => [ "Common",  "Po",   "  [2]",        "HALFWIDTH IDEOGRAPHIC COMMA..HALFWIDTH KATAKANA MIDDLE DOT",                                                   ],
  0xFF70                => [ "Common",  "Lm",   "     ",        "HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK",                                                             ],
  0xFF9E..0xFF9F        => [ "Common",  "Lm",   "  [2]",        "HALFWIDTH KATAKANA VOICED SOUND MARK..HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK",                              ],
  0xFFE0..0xFFE1        => [ "Common",  "Sc",   "  [2]",        "FULLWIDTH CENT SIGN..FULLWIDTH POUND SIGN",                                                                    ],
  0xFFE2                => [ "Common",  "Sm",   "     ",        "FULLWIDTH NOT SIGN",                                                                                           ],
  0xFFE3                => [ "Common",  "Sk",   "     ",        "FULLWIDTH MACRON",                                                                                             ],
  0xFFE4                => [ "Common",  "So",   "     ",        "FULLWIDTH BROKEN BAR",                                                                                         ],
  0xFFE5..0xFFE6        => [ "Common",  "Sc",   "  [2]",        "FULLWIDTH YEN SIGN..FULLWIDTH WON SIGN",                                                                       ],
  0xFFE8                => [ "Common",  "So",   "     ",        "HALFWIDTH FORMS LIGHT VERTICAL",                                                                               ],
  0xFFE9..0xFFEC        => [ "Common",  "Sm",   "  [4]",        "HALFWIDTH LEFTWARDS ARROW..HALFWIDTH DOWNWARDS ARROW",                                                         ],
  0xFFED..0xFFEE        => [ "Common",  "So",   "  [2]",        "HALFWIDTH BLACK SQUARE..HALFWIDTH WHITE CIRCLE",                                                               ],
  0xFFF9..0xFFFB        => [ "Common",  "Cf",   "  [3]",        "INTERLINEAR ANNOTATION ANCHOR..INTERLINEAR ANNOTATION TERMINATOR",                                             ],
  0xFFFC..0xFFFD        => [ "Common",  "So",   "  [2]",        "OBJECT REPLACEMENT CHARACTER..REPLACEMENT CHARACTER",                                                          ],
  0x10100..0x10101      => [ "Common",  "Po",   "  [2]",        "AEGEAN WORD SEPARATOR LINE..AEGEAN WORD SEPARATOR DOT",                                                        ],
  0x10102               => [ "Common",  "So",   "     ",        "AEGEAN CHECK MARK",                                                                                            ],
  0x10107..0x10133      => [ "Common",  "No",   " [45]",        "AEGEAN NUMBER ONE..AEGEAN NUMBER NINETY THOUSAND",                                                             ],
  0x10137..0x1013F      => [ "Common",  "So",   "  [9]",        "AEGEAN WEIGHT BASE UNIT..AEGEAN MEASURE THIRD SUBUNIT",                                                        ],
  0x10190..0x1019B      => [ "Common",  "So",   " [12]",        "ROMAN SEXTANS SIGN..ROMAN CENTURIAL SIGN",                                                                     ],
  0x101D0..0x101FC      => [ "Common",  "So",   " [45]",        "PHAISTOS DISC SIGN PEDESTRIAN..PHAISTOS DISC SIGN WAVY BAND",                                                  ],
  0x1D000..0x1D0F5      => [ "Common",  "So",   "[246]",        "BYZANTINE MUSICAL SYMBOL PSILI..BYZANTINE MUSICAL SYMBOL GORGON NEO KATO",                                     ],
  0x1D100..0x1D126      => [ "Common",  "So",   " [39]",        "MUSICAL SYMBOL SINGLE BARLINE..MUSICAL SYMBOL DRUM CLEF-2",                                                    ],
  0x1D129..0x1D164      => [ "Common",  "So",   " [60]",        "MUSICAL SYMBOL MULTIPLE MEASURE REST..MUSICAL SYMBOL ONE HUNDRED TWENTY-EIGHTH NOTE",                          ],
  0x1D165..0x1D166      => [ "Common",  "Mc",   "  [2]",        "MUSICAL SYMBOL COMBINING STEM..MUSICAL SYMBOL COMBINING SPRECHGESANG STEM",                                    ],
  0x1D16A..0x1D16C      => [ "Common",  "So",   "  [3]",        "MUSICAL SYMBOL FINGERED TREMOLO-1..MUSICAL SYMBOL FINGERED TREMOLO-3",                                         ],
  0x1D16D..0x1D172      => [ "Common",  "Mc",   "  [6]",        "MUSICAL SYMBOL COMBINING AUGMENTATION DOT..MUSICAL SYMBOL COMBINING FLAG-5",                                   ],
  0x1D173..0x1D17A      => [ "Common",  "Cf",   "  [8]",        "MUSICAL SYMBOL BEGIN BEAM..MUSICAL SYMBOL END PHRASE",                                                         ],
  0x1D183..0x1D184      => [ "Common",  "So",   "  [2]",        "MUSICAL SYMBOL ARPEGGIATO UP..MUSICAL SYMBOL ARPEGGIATO DOWN",                                                 ],
  0x1D18C..0x1D1A9      => [ "Common",  "So",   " [30]",        "MUSICAL SYMBOL RINFORZANDO..MUSICAL SYMBOL DEGREE SLASH",                                                      ],
  0x1D1AE..0x1D1DD      => [ "Common",  "So",   " [48]",        "MUSICAL SYMBOL PEDAL MARK..MUSICAL SYMBOL PES SUBPUNCTIS",                                                     ],
  0x1D300..0x1D356      => [ "Common",  "So",   " [87]",        "MONOGRAM FOR EARTH..TETRAGRAM FOR FOSTERING",                                                                  ],
  0x1D360..0x1D371      => [ "Common",  "No",   " [18]",        "COUNTING ROD UNIT DIGIT ONE..COUNTING ROD TENS DIGIT NINE",                                                    ],
  0x1D400..0x1D454      => [ "Common",  "L&",   " [85]",        "MATHEMATICAL BOLD CAPITAL A..MATHEMATICAL ITALIC SMALL G",                                                     ],
  0x1D456..0x1D49C      => [ "Common",  "L&",   " [71]",        "MATHEMATICAL ITALIC SMALL I..MATHEMATICAL SCRIPT CAPITAL A",                                                   ],
  0x1D49E..0x1D49F      => [ "Common",  "L&",   "  [2]",        "MATHEMATICAL SCRIPT CAPITAL C..MATHEMATICAL SCRIPT CAPITAL D",                                                 ],
  0x1D4A2               => [ "Common",  "L&",   "     ",        "MATHEMATICAL SCRIPT CAPITAL G",                                                                                ],
  0x1D4A5..0x1D4A6      => [ "Common",  "L&",   "  [2]",        "MATHEMATICAL SCRIPT CAPITAL J..MATHEMATICAL SCRIPT CAPITAL K",                                                 ],
  0x1D4A9..0x1D4AC      => [ "Common",  "L&",   "  [4]",        "MATHEMATICAL SCRIPT CAPITAL N..MATHEMATICAL SCRIPT CAPITAL Q",                                                 ],
  0x1D4AE..0x1D4B9      => [ "Common",  "L&",   " [12]",        "MATHEMATICAL SCRIPT CAPITAL S..MATHEMATICAL SCRIPT SMALL D",                                                   ],
  0x1D4BB               => [ "Common",  "L&",   "     ",        "MATHEMATICAL SCRIPT SMALL F",                                                                                  ],
  0x1D4BD..0x1D4C3      => [ "Common",  "L&",   "  [7]",        "MATHEMATICAL SCRIPT SMALL H..MATHEMATICAL SCRIPT SMALL N",                                                     ],
  0x1D4C5..0x1D505      => [ "Common",  "L&",   " [65]",        "MATHEMATICAL SCRIPT SMALL P..MATHEMATICAL FRAKTUR CAPITAL B",                                                  ],
  0x1D507..0x1D50A      => [ "Common",  "L&",   "  [4]",        "MATHEMATICAL FRAKTUR CAPITAL D..MATHEMATICAL FRAKTUR CAPITAL G",                                               ],
  0x1D50D..0x1D514      => [ "Common",  "L&",   "  [8]",        "MATHEMATICAL FRAKTUR CAPITAL J..MATHEMATICAL FRAKTUR CAPITAL Q",                                               ],
  0x1D516..0x1D51C      => [ "Common",  "L&",   "  [7]",        "MATHEMATICAL FRAKTUR CAPITAL S..MATHEMATICAL FRAKTUR CAPITAL Y",                                               ],
  0x1D51E..0x1D539      => [ "Common",  "L&",   " [28]",        "MATHEMATICAL FRAKTUR SMALL A..MATHEMATICAL DOUBLE-STRUCK CAPITAL B",                                           ],
  0x1D53B..0x1D53E      => [ "Common",  "L&",   "  [4]",        "MATHEMATICAL DOUBLE-STRUCK CAPITAL D..MATHEMATICAL DOUBLE-STRUCK CAPITAL G",                                   ],
  0x1D540..0x1D544      => [ "Common",  "L&",   "  [5]",        "MATHEMATICAL DOUBLE-STRUCK CAPITAL I..MATHEMATICAL DOUBLE-STRUCK CAPITAL M",                                   ],
  0x1D546               => [ "Common",  "L&",   "     ",        "MATHEMATICAL DOUBLE-STRUCK CAPITAL O",                                                                         ],
  0x1D54A..0x1D550      => [ "Common",  "L&",   "  [7]",        "MATHEMATICAL DOUBLE-STRUCK CAPITAL S..MATHEMATICAL DOUBLE-STRUCK CAPITAL Y",                                   ],
  0x1D552..0x1D6A5      => [ "Common",  "L&",   "[340]",        "MATHEMATICAL DOUBLE-STRUCK SMALL A..MATHEMATICAL ITALIC SMALL DOTLESS J",                                      ],
  0x1D6A8..0x1D6C0      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL BOLD CAPITAL ALPHA..MATHEMATICAL BOLD CAPITAL OMEGA",                                             ],
  0x1D6C1               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL BOLD NABLA",                                                                                      ],
  0x1D6C2..0x1D6DA      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL BOLD SMALL ALPHA..MATHEMATICAL BOLD SMALL OMEGA",                                                 ],
  0x1D6DB               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL BOLD PARTIAL DIFFERENTIAL",                                                                       ],
  0x1D6DC..0x1D6FA      => [ "Common",  "L&",   " [31]",        "MATHEMATICAL BOLD EPSILON SYMBOL..MATHEMATICAL ITALIC CAPITAL OMEGA",                                          ],
  0x1D6FB               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL ITALIC NABLA",                                                                                    ],
  0x1D6FC..0x1D714      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL ITALIC SMALL ALPHA..MATHEMATICAL ITALIC SMALL OMEGA",                                             ],
  0x1D715               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL ITALIC PARTIAL DIFFERENTIAL",                                                                     ],
  0x1D716..0x1D734      => [ "Common",  "L&",   " [31]",        "MATHEMATICAL ITALIC EPSILON SYMBOL..MATHEMATICAL BOLD ITALIC CAPITAL OMEGA",                                   ],
  0x1D735               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL BOLD ITALIC NABLA",                                                                               ],
  0x1D736..0x1D74E      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL BOLD ITALIC SMALL ALPHA..MATHEMATICAL BOLD ITALIC SMALL OMEGA",                                   ],
  0x1D74F               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL BOLD ITALIC PARTIAL DIFFERENTIAL",                                                                ],
  0x1D750..0x1D76E      => [ "Common",  "L&",   " [31]",        "MATHEMATICAL BOLD ITALIC EPSILON SYMBOL..MATHEMATICAL SANS-SERIF BOLD CAPITAL OMEGA",                          ],
  0x1D76F               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL SANS-SERIF BOLD NABLA",                                                                           ],
  0x1D770..0x1D788      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL SANS-SERIF BOLD SMALL ALPHA..MATHEMATICAL SANS-SERIF BOLD SMALL OMEGA",                           ],
  0x1D789               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL SANS-SERIF BOLD PARTIAL DIFFERENTIAL",                                                            ],
  0x1D78A..0x1D7A8      => [ "Common",  "L&",   " [31]",        "MATHEMATICAL SANS-SERIF BOLD EPSILON SYMBOL..MATHEMATICAL SANS-SERIF BOLD ITALIC CAPITAL OMEGA",               ],
  0x1D7A9               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL SANS-SERIF BOLD ITALIC NABLA",                                                                    ],
  0x1D7AA..0x1D7C2      => [ "Common",  "L&",   " [25]",        "MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL ALPHA..MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL OMEGA",             ],
  0x1D7C3               => [ "Common",  "Sm",   "     ",        "MATHEMATICAL SANS-SERIF BOLD ITALIC PARTIAL DIFFERENTIAL",                                                     ],
  0x1D7C4..0x1D7CB      => [ "Common",  "L&",   "  [8]",        "MATHEMATICAL SANS-SERIF BOLD ITALIC EPSILON SYMBOL..MATHEMATICAL BOLD SMALL DIGAMMA",                          ],
  0x1D7CE..0x1D7FF      => [ "Common",  "Nd",   " [50]",        "MATHEMATICAL BOLD DIGIT ZERO..MATHEMATICAL MONOSPACE DIGIT NINE",                                              ],
  0x1F000..0x1F02B      => [ "Common",  "So",   " [44]",        "MAHJONG TILE EAST WIND..MAHJONG TILE BACK",                                                                    ],
  0x1F030..0x1F093      => [ "Common",  "So",   "[100]",        "DOMINO TILE HORIZONTAL BACK..DOMINO TILE VERTICAL-06-06",                                                      ],
  0xE0001               => [ "Common",  "Cf",   "     ",        "LANGUAGE TAG",                                                                                                 ],
  0xE0020..0xE007F      => [ "Common",  "Cf",   " [96]",        "TAG SPACE..CANCEL TAG",                                                                                        ],

  # Total code points: 5178

  # ================================================

  0x0041..0x005A        => [ "Latin",   "L&",   " [26]",        "LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER Z",                                                               ],
  0x0061..0x007A        => [ "Latin",   "L&",   " [26]",        "LATIN SMALL LETTER A..LATIN SMALL LETTER Z",                                                                   ],
  0x00AA                => [ "Latin",   "L&",   "     ",        "FEMININE ORDINAL INDICATOR",                                                                                   ],
  0x00BA                => [ "Latin",   "L&",   "     ",        "MASCULINE ORDINAL INDICATOR",                                                                                  ],
  0x00C0..0x00D6        => [ "Latin",   "L&",   " [23]",        "LATIN CAPITAL LETTER A WITH GRAVE..LATIN CAPITAL LETTER O WITH DIAERESIS",                                     ],
  0x00D8..0x00F6        => [ "Latin",   "L&",   " [31]",        "LATIN CAPITAL LETTER O WITH STROKE..LATIN SMALL LETTER O WITH DIAERESIS",                                      ],
  0x00F8..0x01BA        => [ "Latin",   "L&",   "[195]",        "LATIN SMALL LETTER O WITH STROKE..LATIN SMALL LETTER EZH WITH TAIL",                                           ],
  0x01BB                => [ "Latin",   "Lo",   "     ",        "LATIN LETTER TWO WITH STROKE",                                                                                 ],
  0x01BC..0x01BF        => [ "Latin",   "L&",   "  [4]",        "LATIN CAPITAL LETTER TONE FIVE..LATIN LETTER WYNN",                                                            ],
  0x01C0..0x01C3        => [ "Latin",   "Lo",   "  [4]",        "LATIN LETTER DENTAL CLICK..LATIN LETTER RETROFLEX CLICK",                                                      ],
  0x01C4..0x0293        => [ "Latin",   "L&",   "[208]",        "LATIN CAPITAL LETTER DZ WITH CARON..LATIN SMALL LETTER EZH WITH CURL",                                         ],
  0x0294                => [ "Latin",   "Lo",   "     ",        "LATIN LETTER GLOTTAL STOP",                                                                                    ],
  0x0295..0x02AF        => [ "Latin",   "L&",   " [27]",        "LATIN LETTER PHARYNGEAL VOICED FRICATIVE..LATIN SMALL LETTER TURNED H WITH FISHHOOK AND TAIL",                 ],
  0x02B0..0x02B8        => [ "Latin",   "Lm",   "  [9]",        "MODIFIER LETTER SMALL H..MODIFIER LETTER SMALL Y",                                                             ],
  0x02E0..0x02E4        => [ "Latin",   "Lm",   "  [5]",        "MODIFIER LETTER SMALL GAMMA..MODIFIER LETTER SMALL REVERSED GLOTTAL STOP",                                     ],
  0x1D00..0x1D25        => [ "Latin",   "L&",   " [38]",        "LATIN LETTER SMALL CAPITAL A..LATIN LETTER AIN",                                                               ],
  0x1D2C..0x1D5C        => [ "Latin",   "Lm",   " [49]",        "MODIFIER LETTER CAPITAL A..MODIFIER LETTER SMALL AIN",                                                         ],
  0x1D62..0x1D65        => [ "Latin",   "L&",   "  [4]",        "LATIN SUBSCRIPT SMALL LETTER I..LATIN SUBSCRIPT SMALL LETTER V",                                               ],
  0x1D6B..0x1D77        => [ "Latin",   "L&",   " [13]",        "LATIN SMALL LETTER UE..LATIN SMALL LETTER TURNED G",                                                           ],
  0x1D79..0x1D9A        => [ "Latin",   "L&",   " [34]",        "LATIN SMALL LETTER INSULAR G..LATIN SMALL LETTER EZH WITH RETROFLEX HOOK",                                     ],
  0x1D9B..0x1DBE        => [ "Latin",   "Lm",   " [36]",        "MODIFIER LETTER SMALL TURNED ALPHA..MODIFIER LETTER SMALL EZH",                                                ],
  0x1E00..0x1EFF        => [ "Latin",   "L&",   "[256]",        "LATIN CAPITAL LETTER A WITH RING BELOW..LATIN SMALL LETTER Y WITH LOOP",                                       ],
  0x2071                => [ "Latin",   "L&",   "     ",        "SUPERSCRIPT LATIN SMALL LETTER I",                                                                             ],
  0x207F                => [ "Latin",   "L&",   "     ",        "SUPERSCRIPT LATIN SMALL LETTER N",                                                                             ],
  0x2090..0x2094        => [ "Latin",   "Lm",   "  [5]",        "LATIN SUBSCRIPT SMALL LETTER A..LATIN SUBSCRIPT SMALL LETTER SCHWA",                                           ],
  0x212A..0x212B        => [ "Latin",   "L&",   "  [2]",        "KELVIN SIGN..ANGSTROM SIGN",                                                                                   ],
  0x2132                => [ "Latin",   "L&",   "     ",        "TURNED CAPITAL F",                                                                                             ],
  0x214E                => [ "Latin",   "L&",   "     ",        "TURNED SMALL F",                                                                                               ],
  0x2160..0x2182        => [ "Latin",   "Nl",   " [35]",        "ROMAN NUMERAL ONE..ROMAN NUMERAL TEN THOUSAND",                                                                ],
  0x2183..0x2184        => [ "Latin",   "L&",   "  [2]",        "ROMAN NUMERAL REVERSED ONE HUNDRED..LATIN SMALL LETTER REVERSED C",                                            ],
  0x2185..0x2188        => [ "Latin",   "Nl",   "  [4]",        "ROMAN NUMERAL SIX LATE FORM..ROMAN NUMERAL ONE HUNDRED THOUSAND",                                              ],
  0x2C60..0x2C6F        => [ "Latin",   "L&",   " [16]",        "LATIN CAPITAL LETTER L WITH DOUBLE BAR..LATIN CAPITAL LETTER TURNED A",                                        ],
  0x2C71..0x2C7C        => [ "Latin",   "L&",   " [12]",        "LATIN SMALL LETTER V WITH RIGHT HOOK..LATIN SUBSCRIPT SMALL LETTER J",                                         ],
  0x2C7D                => [ "Latin",   "Lm",   "     ",        "MODIFIER LETTER CAPITAL V",                                                                                    ],
  0xA722..0xA76F        => [ "Latin",   "L&",   " [78]",        "LATIN CAPITAL LETTER EGYPTOLOGICAL ALEF..LATIN SMALL LETTER CON",                                              ],
  0xA770                => [ "Latin",   "Lm",   "     ",        "MODIFIER LETTER US",                                                                                           ],
  0xA771..0xA787        => [ "Latin",   "L&",   " [23]",        "LATIN SMALL LETTER DUM..LATIN SMALL LETTER INSULAR T",                                                         ],
  0xA78B..0xA78C        => [ "Latin",   "L&",   "  [2]",        "LATIN CAPITAL LETTER SALTILLO..LATIN SMALL LETTER SALTILLO",                                                   ],
  0xA7FB..0xA7FF        => [ "Latin",   "Lo",   "  [5]",        "LATIN EPIGRAPHIC LETTER REVERSED F..LATIN EPIGRAPHIC LETTER ARCHAIC M",                                        ],
  0xFB00..0xFB06        => [ "Latin",   "L&",   "  [7]",        "LATIN SMALL LIGATURE FF..LATIN SMALL LIGATURE ST",                                                             ],
  0xFF21..0xFF3A        => [ "Latin",   "L&",   " [26]",        "FULLWIDTH LATIN CAPITAL LETTER A..FULLWIDTH LATIN CAPITAL LETTER Z",                                           ],
  0xFF41..0xFF5A        => [ "Latin",   "L&",   " [26]",        "FULLWIDTH LATIN SMALL LETTER A..FULLWIDTH LATIN SMALL LETTER Z",                                               ],

  # Total code points: 1241

  # ================================================

  0x0370..0x0373        => [ "Greek",   "L&",   "  [4]",        "GREEK CAPITAL LETTER HETA..GREEK SMALL LETTER ARCHAIC SAMPI",                                                  ],
  0x0375                => [ "Greek",   "Sk",   "     ",        "GREEK LOWER NUMERAL SIGN",                                                                                     ],
  0x0376..0x0377        => [ "Greek",   "L&",   "  [2]",        "GREEK CAPITAL LETTER PAMPHYLIAN DIGAMMA..GREEK SMALL LETTER PAMPHYLIAN DIGAMMA",                               ],
  0x037A                => [ "Greek",   "Lm",   "     ",        "GREEK YPOGEGRAMMENI",                                                                                          ],
  0x037B..0x037D        => [ "Greek",   "L&",   "  [3]",        "GREEK SMALL REVERSED LUNATE SIGMA SYMBOL..GREEK SMALL REVERSED DOTTED LUNATE SIGMA SYMBOL",                    ],
  0x0384                => [ "Greek",   "Sk",   "     ",        "GREEK TONOS",                                                                                                  ],
  0x0386                => [ "Greek",   "L&",   "     ",        "GREEK CAPITAL LETTER ALPHA WITH TONOS",                                                                        ],
  0x0388..0x038A        => [ "Greek",   "L&",   "  [3]",        "GREEK CAPITAL LETTER EPSILON WITH TONOS..GREEK CAPITAL LETTER IOTA WITH TONOS",                                ],
  0x038C                => [ "Greek",   "L&",   "     ",        "GREEK CAPITAL LETTER OMICRON WITH TONOS",                                                                      ],
  0x038E..0x03A1        => [ "Greek",   "L&",   " [20]",        "GREEK CAPITAL LETTER UPSILON WITH TONOS..GREEK CAPITAL LETTER RHO",                                            ],
  0x03A3..0x03E1        => [ "Greek",   "L&",   " [63]",        "GREEK CAPITAL LETTER SIGMA..GREEK SMALL LETTER SAMPI",                                                         ],
  0x03F0..0x03F5        => [ "Greek",   "L&",   "  [6]",        "GREEK KAPPA SYMBOL..GREEK LUNATE EPSILON SYMBOL",                                                              ],
  0x03F6                => [ "Greek",   "Sm",   "     ",        "GREEK REVERSED LUNATE EPSILON SYMBOL",                                                                         ],
  0x03F7..0x03FF        => [ "Greek",   "L&",   "  [9]",        "GREEK CAPITAL LETTER SHO..GREEK CAPITAL REVERSED DOTTED LUNATE SIGMA SYMBOL",                                  ],
  0x1D26..0x1D2A        => [ "Greek",   "L&",   "  [5]",        "GREEK LETTER SMALL CAPITAL GAMMA..GREEK LETTER SMALL CAPITAL PSI",                                             ],
  0x1D5D..0x1D61        => [ "Greek",   "Lm",   "  [5]",        "MODIFIER LETTER SMALL BETA..MODIFIER LETTER SMALL CHI",                                                        ],
  0x1D66..0x1D6A        => [ "Greek",   "L&",   "  [5]",        "GREEK SUBSCRIPT SMALL LETTER BETA..GREEK SUBSCRIPT SMALL LETTER CHI",                                          ],
  0x1DBF                => [ "Greek",   "Lm",   "     ",        "MODIFIER LETTER SMALL THETA",                                                                                  ],
  0x1F00..0x1F15        => [ "Greek",   "L&",   " [22]",        "GREEK SMALL LETTER ALPHA WITH PSILI..GREEK SMALL LETTER EPSILON WITH DASIA AND OXIA",                          ],
  0x1F18..0x1F1D        => [ "Greek",   "L&",   "  [6]",        "GREEK CAPITAL LETTER EPSILON WITH PSILI..GREEK CAPITAL LETTER EPSILON WITH DASIA AND OXIA",                    ],
  0x1F20..0x1F45        => [ "Greek",   "L&",   " [38]",        "GREEK SMALL LETTER ETA WITH PSILI..GREEK SMALL LETTER OMICRON WITH DASIA AND OXIA",                            ],
  0x1F48..0x1F4D        => [ "Greek",   "L&",   "  [6]",        "GREEK CAPITAL LETTER OMICRON WITH PSILI..GREEK CAPITAL LETTER OMICRON WITH DASIA AND OXIA",                    ],
  0x1F50..0x1F57        => [ "Greek",   "L&",   "  [8]",        "GREEK SMALL LETTER UPSILON WITH PSILI..GREEK SMALL LETTER UPSILON WITH DASIA AND PERISPOMENI",                 ],
  0x1F59                => [ "Greek",   "L&",   "     ",        "GREEK CAPITAL LETTER UPSILON WITH DASIA",                                                                      ],
  0x1F5B                => [ "Greek",   "L&",   "     ",        "GREEK CAPITAL LETTER UPSILON WITH DASIA AND VARIA",                                                            ],
  0x1F5D                => [ "Greek",   "L&",   "     ",        "GREEK CAPITAL LETTER UPSILON WITH DASIA AND OXIA",                                                             ],
  0x1F5F..0x1F7D        => [ "Greek",   "L&",   " [31]",        "GREEK CAPITAL LETTER UPSILON WITH DASIA AND PERISPOMENI..GREEK SMALL LETTER OMEGA WITH OXIA",                  ],
  0x1F80..0x1FB4        => [ "Greek",   "L&",   " [53]",        "GREEK SMALL LETTER ALPHA WITH PSILI AND YPOGEGRAMMENI..GREEK SMALL LETTER ALPHA WITH OXIA AND YPOGEGRAMMENI",  ],
  0x1FB6..0x1FBC        => [ "Greek",   "L&",   "  [7]",        "GREEK SMALL LETTER ALPHA WITH PERISPOMENI..GREEK CAPITAL LETTER ALPHA WITH PROSGEGRAMMENI",                    ],
  0x1FBD                => [ "Greek",   "Sk",   "     ",        "GREEK KORONIS",                                                                                                ],
  0x1FBE                => [ "Greek",   "L&",   "     ",        "GREEK PROSGEGRAMMENI",                                                                                         ],
  0x1FBF..0x1FC1        => [ "Greek",   "Sk",   "  [3]",        "GREEK PSILI..GREEK DIALYTIKA AND PERISPOMENI",                                                                 ],
  0x1FC2..0x1FC4        => [ "Greek",   "L&",   "  [3]",        "GREEK SMALL LETTER ETA WITH VARIA AND YPOGEGRAMMENI..GREEK SMALL LETTER ETA WITH OXIA AND YPOGEGRAMMENI",      ],
  0x1FC6..0x1FCC        => [ "Greek",   "L&",   "  [7]",        "GREEK SMALL LETTER ETA WITH PERISPOMENI..GREEK CAPITAL LETTER ETA WITH PROSGEGRAMMENI",                        ],
  0x1FCD..0x1FCF        => [ "Greek",   "Sk",   "  [3]",        "GREEK PSILI AND VARIA..GREEK PSILI AND PERISPOMENI",                                                           ],
  0x1FD0..0x1FD3        => [ "Greek",   "L&",   "  [4]",        "GREEK SMALL LETTER IOTA WITH VRACHY..GREEK SMALL LETTER IOTA WITH DIALYTIKA AND OXIA",                         ],
  0x1FD6..0x1FDB        => [ "Greek",   "L&",   "  [6]",        "GREEK SMALL LETTER IOTA WITH PERISPOMENI..GREEK CAPITAL LETTER IOTA WITH OXIA",                                ],
  0x1FDD..0x1FDF        => [ "Greek",   "Sk",   "  [3]",        "GREEK DASIA AND VARIA..GREEK DASIA AND PERISPOMENI",                                                           ],
  0x1FE0..0x1FEC        => [ "Greek",   "L&",   " [13]",        "GREEK SMALL LETTER UPSILON WITH VRACHY..GREEK CAPITAL LETTER RHO WITH DASIA",                                  ],
  0x1FED..0x1FEF        => [ "Greek",   "Sk",   "  [3]",        "GREEK DIALYTIKA AND VARIA..GREEK VARIA",                                                                       ],
  0x1FF2..0x1FF4        => [ "Greek",   "L&",   "  [3]",        "GREEK SMALL LETTER OMEGA WITH VARIA AND YPOGEGRAMMENI..GREEK SMALL LETTER OMEGA WITH OXIA AND YPOGEGRAMMENI",  ],
  0x1FF6..0x1FFC        => [ "Greek",   "L&",   "  [7]",        "GREEK SMALL LETTER OMEGA WITH PERISPOMENI..GREEK CAPITAL LETTER OMEGA WITH PROSGEGRAMMENI",                    ],
  0x1FFD..0x1FFE        => [ "Greek",   "Sk",   "  [2]",        "GREEK OXIA..GREEK DASIA",                                                                                      ],
  0x2126                => [ "Greek",   "L&",   "     ",        "OHM SIGN",                                                                                                     ],
  0x10140..0x10174      => [ "Greek",   "Nl",   " [53]",        "GREEK ACROPHONIC ATTIC ONE QUARTER..GREEK ACROPHONIC STRATIAN FIFTY MNAS",                                     ],
  0x10175..0x10178      => [ "Greek",   "No",   "  [4]",        "GREEK ONE HALF SIGN..GREEK THREE QUARTERS SIGN",                                                               ],
  0x10179..0x10189      => [ "Greek",   "So",   " [17]",        "GREEK YEAR SIGN..GREEK TRYBLION BASE SIGN",                                                                    ],
  0x1018A               => [ "Greek",   "No",   "     ",        "GREEK ZERO SIGN",                                                                                              ],
  0x1D200..0x1D241      => [ "Greek",   "So",   " [66]",        "GREEK VOCAL NOTATION SYMBOL-1..GREEK INSTRUMENTAL NOTATION SYMBOL-54",                                         ],
  0x1D242..0x1D244      => [ "Greek",   "Mn",   "  [3]",        "COMBINING GREEK MUSICAL TRISEME..COMBINING GREEK MUSICAL PENTASEME",                                           ],
  0x1D245               => [ "Greek",   "So",   "     ",        "GREEK MUSICAL LEIMMA",                                                                                         ],

  # Total code points: 511

  # ================================================

  0x0400..0x0481        => [ "Cyrillic",        "L&",   "[130]",        "CYRILLIC CAPITAL LETTER IE WITH GRAVE..CYRILLIC SMALL LETTER KOPPA",                                   ],
  0x0482                => [ "Cyrillic",        "So",   "     ",        "CYRILLIC THOUSANDS SIGN",                                                                              ],
  0x0483..0x0487        => [ "Cyrillic",        "Mn",   "  [5]",        "COMBINING CYRILLIC TITLO..COMBINING CYRILLIC POKRYTIE",                                                ],
  0x0488..0x0489        => [ "Cyrillic",        "Me",   "  [2]",        "COMBINING CYRILLIC HUNDRED THOUSANDS SIGN..COMBINING CYRILLIC MILLIONS SIGN",                          ],
  0x048A..0x0523        => [ "Cyrillic",        "L&",   "[154]",        "CYRILLIC CAPITAL LETTER SHORT I WITH TAIL..CYRILLIC SMALL LETTER EN WITH MIDDLE HOOK",                 ],
  0x1D2B                => [ "Cyrillic",        "L&",   "     ",        "CYRILLIC LETTER SMALL CAPITAL EL",                                                                     ],
  0x1D78                => [ "Cyrillic",        "Lm",   "     ",        "MODIFIER LETTER CYRILLIC EN",                                                                          ],
  0x2DE0..0x2DFF        => [ "Cyrillic",        "Mn",   " [32]",        "COMBINING CYRILLIC LETTER BE..COMBINING CYRILLIC LETTER IOTIFIED BIG YUS",                             ],
  0xA640..0xA65F        => [ "Cyrillic",        "L&",   " [32]",        "CYRILLIC CAPITAL LETTER ZEMLYA..CYRILLIC SMALL LETTER YN",                                             ],
  0xA662..0xA66D        => [ "Cyrillic",        "L&",   " [12]",        "CYRILLIC CAPITAL LETTER SOFT DE..CYRILLIC SMALL LETTER DOUBLE MONOCULAR O",                            ],
  0xA66E                => [ "Cyrillic",        "Lo",   "     ",        "CYRILLIC LETTER MULTIOCULAR O",                                                                        ],
  0xA66F                => [ "Cyrillic",        "Mn",   "     ",        "COMBINING CYRILLIC VZMET",                                                                             ],
  0xA670..0xA672        => [ "Cyrillic",        "Me",   "  [3]",        "COMBINING CYRILLIC TEN MILLIONS SIGN..COMBINING CYRILLIC THOUSAND MILLIONS SIGN",                      ],
  0xA673                => [ "Cyrillic",        "Po",   "     ",        "SLAVONIC ASTERISK",                                                                                    ],
  0xA67C..0xA67D        => [ "Cyrillic",        "Mn",   "  [2]",        "COMBINING CYRILLIC KAVYKA..COMBINING CYRILLIC PAYEROK",                                                ],
  0xA67E                => [ "Cyrillic",        "Po",   "     ",        "CYRILLIC KAVYKA",                                                                                      ],
  0xA67F                => [ "Cyrillic",        "Lm",   "     ",        "CYRILLIC PAYEROK",                                                                                     ],
  0xA680..0xA697        => [ "Cyrillic",        "L&",   " [24]",        "CYRILLIC CAPITAL LETTER DWE..CYRILLIC SMALL LETTER SHWE",                                              ],

  # Total code points: 404

  # ================================================

  0x0531..0x0556        => [ "Armenian",        "L&",   " [38]",        "ARMENIAN CAPITAL LETTER AYB..ARMENIAN CAPITAL LETTER FEH",                                             ],
  0x0559                => [ "Armenian",        "Lm",   "     ",        "ARMENIAN MODIFIER LETTER LEFT HALF RING",                                                              ],
  0x055A..0x055F        => [ "Armenian",        "Po",   "  [6]",        "ARMENIAN APOSTROPHE..ARMENIAN ABBREVIATION MARK",                                                      ],
  0x0561..0x0587        => [ "Armenian",        "L&",   " [39]",        "ARMENIAN SMALL LETTER AYB..ARMENIAN SMALL LIGATURE ECH YIWN",                                          ],
  0x058A                => [ "Armenian",        "Pd",   "     ",        "ARMENIAN HYPHEN",                                                                                      ],
  0xFB13..0xFB17        => [ "Armenian",        "L&",   "  [5]",        "ARMENIAN SMALL LIGATURE MEN NOW..ARMENIAN SMALL LIGATURE MEN XEH",                                     ],

  # Total code points: 90

  # ================================================

  0x0591..0x05BD        => [ "Hebrew",  "Mn",   " [45]",        "HEBREW ACCENT ETNAHTA..HEBREW POINT METEG",                                                                    ],
  0x05BE                => [ "Hebrew",  "Pd",   "     ",        "HEBREW PUNCTUATION MAQAF",                                                                                     ],
  0x05BF                => [ "Hebrew",  "Mn",   "     ",        "HEBREW POINT RAFE",                                                                                            ],
  0x05C0                => [ "Hebrew",  "Po",   "     ",        "HEBREW PUNCTUATION PASEQ",                                                                                     ],
  0x05C1..0x05C2        => [ "Hebrew",  "Mn",   "  [2]",        "HEBREW POINT SHIN DOT..HEBREW POINT SIN DOT",                                                                  ],
  0x05C3                => [ "Hebrew",  "Po",   "     ",        "HEBREW PUNCTUATION SOF PASUQ",                                                                                 ],
  0x05C4..0x05C5        => [ "Hebrew",  "Mn",   "  [2]",        "HEBREW MARK UPPER DOT..HEBREW MARK LOWER DOT",                                                                 ],
  0x05C6                => [ "Hebrew",  "Po",   "     ",        "HEBREW PUNCTUATION NUN HAFUKHA",                                                                               ],
  0x05C7                => [ "Hebrew",  "Mn",   "     ",        "HEBREW POINT QAMATS QATAN",                                                                                    ],
  0x05D0..0x05EA        => [ "Hebrew",  "Lo",   " [27]",        "HEBREW LETTER ALEF..HEBREW LETTER TAV",                                                                        ],
  0x05F0..0x05F2        => [ "Hebrew",  "Lo",   "  [3]",        "HEBREW LIGATURE YIDDISH DOUBLE VAV..HEBREW LIGATURE YIDDISH DOUBLE YOD",                                       ],
  0x05F3..0x05F4        => [ "Hebrew",  "Po",   "  [2]",        "HEBREW PUNCTUATION GERESH..HEBREW PUNCTUATION GERSHAYIM",                                                      ],
  0xFB1D                => [ "Hebrew",  "Lo",   "     ",        "HEBREW LETTER YOD WITH HIRIQ",                                                                                 ],
  0xFB1E                => [ "Hebrew",  "Mn",   "     ",        "HEBREW POINT JUDEO-SPANISH VARIKA",                                                                            ],
  0xFB1F..0xFB28        => [ "Hebrew",  "Lo",   " [10]",        "HEBREW LIGATURE YIDDISH YOD YOD PATAH..HEBREW LETTER WIDE TAV",                                                ],
  0xFB29                => [ "Hebrew",  "Sm",   "     ",        "HEBREW LETTER ALTERNATIVE PLUS SIGN",                                                                          ],
  0xFB2A..0xFB36        => [ "Hebrew",  "Lo",   " [13]",        "HEBREW LETTER SHIN WITH SHIN DOT..HEBREW LETTER ZAYIN WITH DAGESH",                                            ],
  0xFB38..0xFB3C        => [ "Hebrew",  "Lo",   "  [5]",        "HEBREW LETTER TET WITH DAGESH..HEBREW LETTER LAMED WITH DAGESH",                                               ],
  0xFB3E                => [ "Hebrew",  "Lo",   "     ",        "HEBREW LETTER MEM WITH DAGESH",                                                                                ],
  0xFB40..0xFB41        => [ "Hebrew",  "Lo",   "  [2]",        "HEBREW LETTER NUN WITH DAGESH..HEBREW LETTER SAMEKH WITH DAGESH",                                              ],
  0xFB43..0xFB44        => [ "Hebrew",  "Lo",   "  [2]",        "HEBREW LETTER FINAL PE WITH DAGESH..HEBREW LETTER PE WITH DAGESH",                                             ],
  0xFB46..0xFB4F        => [ "Hebrew",  "Lo",   " [10]",        "HEBREW LETTER TSADI WITH DAGESH..HEBREW LIGATURE ALEF LAMED",                                                  ],

  # Total code points: 133

  # ================================================

  0x0606..0x0608        => [ "Arabic",  "Sm",   "  [3]",        "ARABIC-INDIC CUBE ROOT..ARABIC RAY",                                                                           ],
  0x0609..0x060A        => [ "Arabic",  "Po",   "  [2]",        "ARABIC-INDIC PER MILLE SIGN..ARABIC-INDIC PER TEN THOUSAND SIGN",                                              ],
  0x060B                => [ "Arabic",  "Sc",   "     ",        "AFGHANI SIGN",                                                                                                 ],
  0x060D                => [ "Arabic",  "Po",   "     ",        "ARABIC DATE SEPARATOR",                                                                                        ],
  0x060E..0x060F        => [ "Arabic",  "So",   "  [2]",        "ARABIC POETIC VERSE SIGN..ARABIC SIGN MISRA",                                                                  ],
  0x0610..0x061A        => [ "Arabic",  "Mn",   " [11]",        "ARABIC SIGN SALLALLAHOU ALAYHE WASSALLAM..ARABIC SMALL KASRA",                                                 ],
  0x061E                => [ "Arabic",  "Po",   "     ",        "ARABIC TRIPLE DOT PUNCTUATION MARK",                                                                           ],
  0x0621..0x063F        => [ "Arabic",  "Lo",   " [31]",        "ARABIC LETTER HAMZA..ARABIC LETTER FARSI YEH WITH THREE DOTS ABOVE",                                           ],
  0x0641..0x064A        => [ "Arabic",  "Lo",   " [10]",        "ARABIC LETTER FEH..ARABIC LETTER YEH",                                                                         ],
  0x0656..0x065E        => [ "Arabic",  "Mn",   "  [9]",        "ARABIC SUBSCRIPT ALEF..ARABIC FATHA WITH TWO DOTS",                                                            ],
  0x066A..0x066D        => [ "Arabic",  "Po",   "  [4]",        "ARABIC PERCENT SIGN..ARABIC FIVE POINTED STAR",                                                                ],
  0x066E..0x066F        => [ "Arabic",  "Lo",   "  [2]",        "ARABIC LETTER DOTLESS BEH..ARABIC LETTER DOTLESS QAF",                                                         ],
  0x0671..0x06D3        => [ "Arabic",  "Lo",   " [99]",        "ARABIC LETTER ALEF WASLA..ARABIC LETTER YEH BARREE WITH HAMZA ABOVE",                                          ],
  0x06D4                => [ "Arabic",  "Po",   "     ",        "ARABIC FULL STOP",                                                                                             ],
  0x06D5                => [ "Arabic",  "Lo",   "     ",        "ARABIC LETTER AE",                                                                                             ],
  0x06D6..0x06DC        => [ "Arabic",  "Mn",   "  [7]",        "ARABIC SMALL HIGH LIGATURE SAD WITH LAM WITH ALEF MAKSURA..ARABIC SMALL HIGH SEEN",                            ],
  0x06DE                => [ "Arabic",  "Me",   "     ",        "ARABIC START OF RUB EL HIZB",                                                                                  ],
  0x06DF..0x06E4        => [ "Arabic",  "Mn",   "  [6]",        "ARABIC SMALL HIGH ROUNDED ZERO..ARABIC SMALL HIGH MADDA",                                                      ],
  0x06E5..0x06E6        => [ "Arabic",  "Lm",   "  [2]",        "ARABIC SMALL WAW..ARABIC SMALL YEH",                                                                           ],
  0x06E7..0x06E8        => [ "Arabic",  "Mn",   "  [2]",        "ARABIC SMALL HIGH YEH..ARABIC SMALL HIGH NOON",                                                                ],
  0x06E9                => [ "Arabic",  "So",   "     ",        "ARABIC PLACE OF SAJDAH",                                                                                       ],
  0x06EA..0x06ED        => [ "Arabic",  "Mn",   "  [4]",        "ARABIC EMPTY CENTRE LOW STOP..ARABIC SMALL LOW MEEM",                                                          ],
  0x06EE..0x06EF        => [ "Arabic",  "Lo",   "  [2]",        "ARABIC LETTER DAL WITH INVERTED V..ARABIC LETTER REH WITH INVERTED V",                                         ],
  0x06F0..0x06F9        => [ "Arabic",  "Nd",   " [10]",        "EXTENDED ARABIC-INDIC DIGIT ZERO..EXTENDED ARABIC-INDIC DIGIT NINE",                                           ],
  0x06FA..0x06FC        => [ "Arabic",  "Lo",   "  [3]",        "ARABIC LETTER SHEEN WITH DOT BELOW..ARABIC LETTER GHAIN WITH DOT BELOW",                                       ],
  0x06FD..0x06FE        => [ "Arabic",  "So",   "  [2]",        "ARABIC SIGN SINDHI AMPERSAND..ARABIC SIGN SINDHI POSTPOSITION MEN",                                            ],
  0x06FF                => [ "Arabic",  "Lo",   "     ",        "ARABIC LETTER HEH WITH INVERTED V",                                                                            ],
  0x0750..0x077F        => [ "Arabic",  "Lo",   " [48]",        "ARABIC LETTER BEH WITH THREE DOTS HORIZONTALLY BELOW..ARABIC LETTER KAF WITH TWO DOTS ABOVE",                                          ],
  0xFB50..0xFBB1        => [ "Arabic",  "Lo",   " [98]",        "ARABIC LETTER ALEF WASLA ISOLATED FORM..ARABIC LETTER YEH BARREE WITH HAMZA ABOVE FINAL FORM",                                         ],
  0xFBD3..0xFD3D        => [ "Arabic",  "Lo",   "[363]",        "ARABIC LETTER NG ISOLATED FORM..ARABIC LIGATURE ALEF WITH FATHATAN ISOLATED FORM",                                                     ],
  0xFD50..0xFD8F        => [ "Arabic",  "Lo",   " [64]",        "ARABIC LIGATURE TEH WITH JEEM WITH MEEM INITIAL FORM..ARABIC LIGATURE MEEM WITH KHAH WITH MEEM INITIAL FORM",                          ],
  0xFD92..0xFDC7        => [ "Arabic",  "Lo",   " [54]",        "ARABIC LIGATURE MEEM WITH JEEM WITH KHAH INITIAL FORM..ARABIC LIGATURE NOON WITH JEEM WITH YEH FINAL FORM",                            ],
  0xFDF0..0xFDFB        => [ "Arabic",  "Lo",   " [12]",        "ARABIC LIGATURE SALLA USED AS KORANIC STOP SIGN ISOLATED FORM..ARABIC LIGATURE JALLAJALALOUHOU",                                       ],
  0xFDFC                => [ "Arabic",  "Sc",   "     ",        "RIAL SIGN",                                                                                                    ],
  0xFE70..0xFE74        => [ "Arabic",  "Lo",   "  [5]",        "ARABIC FATHATAN ISOLATED FORM..ARABIC KASRATAN ISOLATED FORM",                                                 ],
  0xFE76..0xFEFC        => [ "Arabic",  "Lo",   "[135]",        "ARABIC FATHA ISOLATED FORM..ARABIC LIGATURE LAM WITH ALEF FINAL FORM",                                         ],

  # Total code points: 999

  # ================================================

  0x0700..0x070D        => [ "Syriac",  "Po",   " [14]",        "SYRIAC END OF PARAGRAPH..SYRIAC HARKLEAN ASTERISCUS",                                                          ],
  0x070F                => [ "Syriac",  "Cf",   "     ",        "SYRIAC ABBREVIATION MARK",                                                                                     ],
  0x0710                => [ "Syriac",  "Lo",   "     ",        "SYRIAC LETTER ALAPH",                                                                                          ],
  0x0711                => [ "Syriac",  "Mn",   "     ",        "SYRIAC LETTER SUPERSCRIPT ALAPH",                                                                              ],
  0x0712..0x072F        => [ "Syriac",  "Lo",   " [30]",        "SYRIAC LETTER BETH..SYRIAC LETTER PERSIAN DHALATH",                                                            ],
  0x0730..0x074A        => [ "Syriac",  "Mn",   " [27]",        "SYRIAC PTHAHA ABOVE..SYRIAC BARREKH",                                                                          ],
  0x074D..0x074F        => [ "Syriac",  "Lo",   "  [3]",        "SYRIAC LETTER SOGDIAN ZHAIN..SYRIAC LETTER SOGDIAN FE",                                                        ],

  # Total code points: 77

  # ================================================

  0x0780..0x07A5        => [ "Thaana",  "Lo",   " [38]",        "THAANA LETTER HAA..THAANA LETTER WAAVU",                                                                       ],
  0x07A6..0x07B0        => [ "Thaana",  "Mn",   " [11]",        "THAANA ABAFILI..THAANA SUKUN",                                                                                 ],
  0x07B1                => [ "Thaana",  "Lo",   "     ",        "THAANA LETTER NAA",                                                                                            ],

  # Total code points: 50

  # ================================================

  0x0901..0x0902        => [ "Devanagari",      "Mn",   "  [2]",        "DEVANAGARI SIGN CANDRABINDU..DEVANAGARI SIGN ANUSVARA",                                                ],
  0x0903                => [ "Devanagari",      "Mc",   "     ",        "DEVANAGARI SIGN VISARGA",                                                                              ],
  0x0904..0x0939        => [ "Devanagari",      "Lo",   " [54]",        "DEVANAGARI LETTER SHORT A..DEVANAGARI LETTER HA",                                                      ],
  0x093C                => [ "Devanagari",      "Mn",   "     ",        "DEVANAGARI SIGN NUKTA",                                                                                ],
  0x093D                => [ "Devanagari",      "Lo",   "     ",        "DEVANAGARI SIGN AVAGRAHA",                                                                             ],
  0x093E..0x0940        => [ "Devanagari",      "Mc",   "  [3]",        "DEVANAGARI VOWEL SIGN AA..DEVANAGARI VOWEL SIGN II",                                                   ],
  0x0941..0x0948        => [ "Devanagari",      "Mn",   "  [8]",        "DEVANAGARI VOWEL SIGN U..DEVANAGARI VOWEL SIGN AI",                                                    ],
  0x0949..0x094C        => [ "Devanagari",      "Mc",   "  [4]",        "DEVANAGARI VOWEL SIGN CANDRA O..DEVANAGARI VOWEL SIGN AU",                                             ],
  0x094D                => [ "Devanagari",      "Mn",   "     ",        "DEVANAGARI SIGN VIRAMA",                                                                               ],
  0x0950                => [ "Devanagari",      "Lo",   "     ",        "DEVANAGARI OM",                                                                                        ],
  0x0953..0x0954        => [ "Devanagari",      "Mn",   "  [2]",        "DEVANAGARI GRAVE ACCENT..DEVANAGARI ACUTE ACCENT",                                                     ],
  0x0958..0x0961        => [ "Devanagari",      "Lo",   " [10]",        "DEVANAGARI LETTER QA..DEVANAGARI LETTER VOCALIC LL",                                                   ],
  0x0962..0x0963        => [ "Devanagari",      "Mn",   "  [2]",        "DEVANAGARI VOWEL SIGN VOCALIC L..DEVANAGARI VOWEL SIGN VOCALIC LL",                                    ],
  0x0966..0x096F        => [ "Devanagari",      "Nd",   " [10]",        "DEVANAGARI DIGIT ZERO..DEVANAGARI DIGIT NINE",                                                         ],
  0x0971                => [ "Devanagari",      "Lm",   "     ",        "DEVANAGARI SIGN HIGH SPACING DOT",                                                                     ],
  0x0972                => [ "Devanagari",      "Lo",   "     ",        "DEVANAGARI LETTER CANDRA A",                                                                           ],
  0x097B..0x097F        => [ "Devanagari",      "Lo",   "  [5]",        "DEVANAGARI LETTER GGA..DEVANAGARI LETTER BBA",                                                         ],

  # Total code points: 107

  # ================================================

  0x0981                => [ "Bengali", "Mn",   "     ",        "BENGALI SIGN CANDRABINDU",                                                                                     ],
  0x0982..0x0983        => [ "Bengali", "Mc",   "  [2]",        "BENGALI SIGN ANUSVARA..BENGALI SIGN VISARGA",                                                                  ],
  0x0985..0x098C        => [ "Bengali", "Lo",   "  [8]",        "BENGALI LETTER A..BENGALI LETTER VOCALIC L",                                                                   ],
  0x098F..0x0990        => [ "Bengali", "Lo",   "  [2]",        "BENGALI LETTER E..BENGALI LETTER AI",                                                                          ],
  0x0993..0x09A8        => [ "Bengali", "Lo",   " [22]",        "BENGALI LETTER O..BENGALI LETTER NA",                                                                          ],
  0x09AA..0x09B0        => [ "Bengali", "Lo",   "  [7]",        "BENGALI LETTER PA..BENGALI LETTER RA",                                                                         ],
  0x09B2                => [ "Bengali", "Lo",   "     ",        "BENGALI LETTER LA",                                                                                            ],
  0x09B6..0x09B9        => [ "Bengali", "Lo",   "  [4]",        "BENGALI LETTER SHA..BENGALI LETTER HA",                                                                        ],
  0x09BC                => [ "Bengali", "Mn",   "     ",        "BENGALI SIGN NUKTA",                                                                                           ],
  0x09BD                => [ "Bengali", "Lo",   "     ",        "BENGALI SIGN AVAGRAHA",                                                                                        ],
  0x09BE..0x09C0        => [ "Bengali", "Mc",   "  [3]",        "BENGALI VOWEL SIGN AA..BENGALI VOWEL SIGN II",                                                                 ],
  0x09C1..0x09C4        => [ "Bengali", "Mn",   "  [4]",        "BENGALI VOWEL SIGN U..BENGALI VOWEL SIGN VOCALIC RR",                                                          ],
  0x09C7..0x09C8        => [ "Bengali", "Mc",   "  [2]",        "BENGALI VOWEL SIGN E..BENGALI VOWEL SIGN AI",                                                                  ],
  0x09CB..0x09CC        => [ "Bengali", "Mc",   "  [2]",        "BENGALI VOWEL SIGN O..BENGALI VOWEL SIGN AU",                                                                  ],
  0x09CD                => [ "Bengali", "Mn",   "     ",        "BENGALI SIGN VIRAMA",                                                                                          ],
  0x09CE                => [ "Bengali", "Lo",   "     ",        "BENGALI LETTER KHANDA TA",                                                                                     ],
  0x09D7                => [ "Bengali", "Mc",   "     ",        "BENGALI AU LENGTH MARK",                                                                                       ],
  0x09DC..0x09DD        => [ "Bengali", "Lo",   "  [2]",        "BENGALI LETTER RRA..BENGALI LETTER RHA",                                                                       ],
  0x09DF..0x09E1        => [ "Bengali", "Lo",   "  [3]",        "BENGALI LETTER YYA..BENGALI LETTER VOCALIC LL",                                                                ],
  0x09E2..0x09E3        => [ "Bengali", "Mn",   "  [2]",        "BENGALI VOWEL SIGN VOCALIC L..BENGALI VOWEL SIGN VOCALIC LL",                                                  ],
  0x09E6..0x09EF        => [ "Bengali", "Nd",   " [10]",        "BENGALI DIGIT ZERO..BENGALI DIGIT NINE",                                                                       ],
  0x09F0..0x09F1        => [ "Bengali", "Lo",   "  [2]",        "BENGALI LETTER RA WITH MIDDLE DIAGONAL..BENGALI LETTER RA WITH LOWER DIAGONAL",                                ],
  0x09F2..0x09F3        => [ "Bengali", "Sc",   "  [2]",        "BENGALI RUPEE MARK..BENGALI RUPEE SIGN",                                                                       ],
  0x09F4..0x09F9        => [ "Bengali", "No",   "  [6]",        "BENGALI CURRENCY NUMERATOR ONE..BENGALI CURRENCY DENOMINATOR SIXTEEN",                                         ],
  0x09FA                => [ "Bengali", "So",   "     ",        "BENGALI ISSHAR",                                                                                               ],

  # Total code points: 91

  # ================================================

  0x0A01..0x0A02        => [ "Gurmukhi",        "Mn",   "  [2]",        "GURMUKHI SIGN ADAK BINDI..GURMUKHI SIGN BINDI",                                                        ],
  0x0A03                => [ "Gurmukhi",        "Mc",   "     ",        "GURMUKHI SIGN VISARGA",                                                                                ],
  0x0A05..0x0A0A        => [ "Gurmukhi",        "Lo",   "  [6]",        "GURMUKHI LETTER A..GURMUKHI LETTER UU",                                                                ],
  0x0A0F..0x0A10        => [ "Gurmukhi",        "Lo",   "  [2]",        "GURMUKHI LETTER EE..GURMUKHI LETTER AI",                                                               ],
  0x0A13..0x0A28        => [ "Gurmukhi",        "Lo",   " [22]",        "GURMUKHI LETTER OO..GURMUKHI LETTER NA",                                                               ],
  0x0A2A..0x0A30        => [ "Gurmukhi",        "Lo",   "  [7]",        "GURMUKHI LETTER PA..GURMUKHI LETTER RA",                                                               ],
  0x0A32..0x0A33        => [ "Gurmukhi",        "Lo",   "  [2]",        "GURMUKHI LETTER LA..GURMUKHI LETTER LLA",                                                              ],
  0x0A35..0x0A36        => [ "Gurmukhi",        "Lo",   "  [2]",        "GURMUKHI LETTER VA..GURMUKHI LETTER SHA",                                                              ],
  0x0A38..0x0A39        => [ "Gurmukhi",        "Lo",   "  [2]",        "GURMUKHI LETTER SA..GURMUKHI LETTER HA",                                                               ],
  0x0A3C                => [ "Gurmukhi",        "Mn",   "     ",        "GURMUKHI SIGN NUKTA",                                                                                  ],
  0x0A3E..0x0A40        => [ "Gurmukhi",        "Mc",   "  [3]",        "GURMUKHI VOWEL SIGN AA..GURMUKHI VOWEL SIGN II",                                                       ],
  0x0A41..0x0A42        => [ "Gurmukhi",        "Mn",   "  [2]",        "GURMUKHI VOWEL SIGN U..GURMUKHI VOWEL SIGN UU",                                                        ],
  0x0A47..0x0A48        => [ "Gurmukhi",        "Mn",   "  [2]",        "GURMUKHI VOWEL SIGN EE..GURMUKHI VOWEL SIGN AI",                                                       ],
  0x0A4B..0x0A4D        => [ "Gurmukhi",        "Mn",   "  [3]",        "GURMUKHI VOWEL SIGN OO..GURMUKHI SIGN VIRAMA",                                                         ],
  0x0A51                => [ "Gurmukhi",        "Mn",   "     ",        "GURMUKHI SIGN UDAAT",                                                                                  ],
  0x0A59..0x0A5C        => [ "Gurmukhi",        "Lo",   "  [4]",        "GURMUKHI LETTER KHHA..GURMUKHI LETTER RRA",                                                            ],
  0x0A5E                => [ "Gurmukhi",        "Lo",   "     ",        "GURMUKHI LETTER FA",                                                                                   ],
  0x0A66..0x0A6F        => [ "Gurmukhi",        "Nd",   " [10]",        "GURMUKHI DIGIT ZERO..GURMUKHI DIGIT NINE",                                                             ],
  0x0A70..0x0A71        => [ "Gurmukhi",        "Mn",   "  [2]",        "GURMUKHI TIPPI..GURMUKHI ADDAK",                                                                       ],
  0x0A72..0x0A74        => [ "Gurmukhi",        "Lo",   "  [3]",        "GURMUKHI IRI..GURMUKHI EK ONKAR",                                                                      ],
  0x0A75                => [ "Gurmukhi",        "Mn",   "     ",        "GURMUKHI SIGN YAKASH",                                                                                 ],

  # Total code points: 79

  # ================================================

  0x0A81..0x0A82        => [ "Gujarati",        "Mn",   "  [2]",        "GUJARATI SIGN CANDRABINDU..GUJARATI SIGN ANUSVARA",                                                    ],
  0x0A83                => [ "Gujarati",        "Mc",   "     ",        "GUJARATI SIGN VISARGA",                                                                                ],
  0x0A85..0x0A8D        => [ "Gujarati",        "Lo",   "  [9]",        "GUJARATI LETTER A..GUJARATI VOWEL CANDRA E",                                                           ],
  0x0A8F..0x0A91        => [ "Gujarati",        "Lo",   "  [3]",        "GUJARATI LETTER E..GUJARATI VOWEL CANDRA O",                                                           ],
  0x0A93..0x0AA8        => [ "Gujarati",        "Lo",   " [22]",        "GUJARATI LETTER O..GUJARATI LETTER NA",                                                                ],
  0x0AAA..0x0AB0        => [ "Gujarati",        "Lo",   "  [7]",        "GUJARATI LETTER PA..GUJARATI LETTER RA",                                                               ],
  0x0AB2..0x0AB3        => [ "Gujarati",        "Lo",   "  [2]",        "GUJARATI LETTER LA..GUJARATI LETTER LLA",                                                              ],
  0x0AB5..0x0AB9        => [ "Gujarati",        "Lo",   "  [5]",        "GUJARATI LETTER VA..GUJARATI LETTER HA",                                                               ],
  0x0ABC                => [ "Gujarati",        "Mn",   "     ",        "GUJARATI SIGN NUKTA",                                                                                  ],
  0x0ABD                => [ "Gujarati",        "Lo",   "     ",        "GUJARATI SIGN AVAGRAHA",                                                                               ],
  0x0ABE..0x0AC0        => [ "Gujarati",        "Mc",   "  [3]",        "GUJARATI VOWEL SIGN AA..GUJARATI VOWEL SIGN II",                                                       ],
  0x0AC1..0x0AC5        => [ "Gujarati",        "Mn",   "  [5]",        "GUJARATI VOWEL SIGN U..GUJARATI VOWEL SIGN CANDRA E",                                                  ],
  0x0AC7..0x0AC8        => [ "Gujarati",        "Mn",   "  [2]",        "GUJARATI VOWEL SIGN E..GUJARATI VOWEL SIGN AI",                                                        ],
  0x0AC9                => [ "Gujarati",        "Mc",   "     ",        "GUJARATI VOWEL SIGN CANDRA O",                                                                         ],
  0x0ACB..0x0ACC        => [ "Gujarati",        "Mc",   "  [2]",        "GUJARATI VOWEL SIGN O..GUJARATI VOWEL SIGN AU",                                                        ],
  0x0ACD                => [ "Gujarati",        "Mn",   "     ",        "GUJARATI SIGN VIRAMA",                                                                                 ],
  0x0AD0                => [ "Gujarati",        "Lo",   "     ",        "GUJARATI OM",                                                                                          ],
  0x0AE0..0x0AE1        => [ "Gujarati",        "Lo",   "  [2]",        "GUJARATI LETTER VOCALIC RR..GUJARATI LETTER VOCALIC LL",                                               ],
  0x0AE2..0x0AE3        => [ "Gujarati",        "Mn",   "  [2]",        "GUJARATI VOWEL SIGN VOCALIC L..GUJARATI VOWEL SIGN VOCALIC LL",                                        ],
  0x0AE6..0x0AEF        => [ "Gujarati",        "Nd",   " [10]",        "GUJARATI DIGIT ZERO..GUJARATI DIGIT NINE",                                                             ],
  0x0AF1                => [ "Gujarati",        "Sc",   "     ",        "GUJARATI RUPEE SIGN",                                                                                  ],

  # Total code points: 83

  # ================================================

  0x0B01                => [ "Oriya",   "Mn",   "     ",        "ORIYA SIGN CANDRABINDU",                                                                                       ],
  0x0B02..0x0B03        => [ "Oriya",   "Mc",   "  [2]",        "ORIYA SIGN ANUSVARA..ORIYA SIGN VISARGA",                                                                      ],
  0x0B05..0x0B0C        => [ "Oriya",   "Lo",   "  [8]",        "ORIYA LETTER A..ORIYA LETTER VOCALIC L",                                                                       ],
  0x0B0F..0x0B10        => [ "Oriya",   "Lo",   "  [2]",        "ORIYA LETTER E..ORIYA LETTER AI",                                                                              ],
  0x0B13..0x0B28        => [ "Oriya",   "Lo",   " [22]",        "ORIYA LETTER O..ORIYA LETTER NA",                                                                              ],
  0x0B2A..0x0B30        => [ "Oriya",   "Lo",   "  [7]",        "ORIYA LETTER PA..ORIYA LETTER RA",                                                                             ],
  0x0B32..0x0B33        => [ "Oriya",   "Lo",   "  [2]",        "ORIYA LETTER LA..ORIYA LETTER LLA",                                                                            ],
  0x0B35..0x0B39        => [ "Oriya",   "Lo",   "  [5]",        "ORIYA LETTER VA..ORIYA LETTER HA",                                                                             ],
  0x0B3C                => [ "Oriya",   "Mn",   "     ",        "ORIYA SIGN NUKTA",                                                                                             ],
  0x0B3D                => [ "Oriya",   "Lo",   "     ",        "ORIYA SIGN AVAGRAHA",                                                                                          ],
  0x0B3E                => [ "Oriya",   "Mc",   "     ",        "ORIYA VOWEL SIGN AA",                                                                                          ],
  0x0B3F                => [ "Oriya",   "Mn",   "     ",        "ORIYA VOWEL SIGN I",                                                                                           ],
  0x0B40                => [ "Oriya",   "Mc",   "     ",        "ORIYA VOWEL SIGN II",                                                                                          ],
  0x0B41..0x0B44        => [ "Oriya",   "Mn",   "  [4]",        "ORIYA VOWEL SIGN U..ORIYA VOWEL SIGN VOCALIC RR",                                                              ],
  0x0B47..0x0B48        => [ "Oriya",   "Mc",   "  [2]",        "ORIYA VOWEL SIGN E..ORIYA VOWEL SIGN AI",                                                                      ],
  0x0B4B..0x0B4C        => [ "Oriya",   "Mc",   "  [2]",        "ORIYA VOWEL SIGN O..ORIYA VOWEL SIGN AU",                                                                      ],
  0x0B4D                => [ "Oriya",   "Mn",   "     ",        "ORIYA SIGN VIRAMA",                                                                                            ],
  0x0B56                => [ "Oriya",   "Mn",   "     ",        "ORIYA AI LENGTH MARK",                                                                                         ],
  0x0B57                => [ "Oriya",   "Mc",   "     ",        "ORIYA AU LENGTH MARK",                                                                                         ],
  0x0B5C..0x0B5D        => [ "Oriya",   "Lo",   "  [2]",        "ORIYA LETTER RRA..ORIYA LETTER RHA",                                                                           ],
  0x0B5F..0x0B61        => [ "Oriya",   "Lo",   "  [3]",        "ORIYA LETTER YYA..ORIYA LETTER VOCALIC LL",                                                                    ],
  0x0B62..0x0B63        => [ "Oriya",   "Mn",   "  [2]",        "ORIYA VOWEL SIGN VOCALIC L..ORIYA VOWEL SIGN VOCALIC LL",                                                      ],
  0x0B66..0x0B6F        => [ "Oriya",   "Nd",   " [10]",        "ORIYA DIGIT ZERO..ORIYA DIGIT NINE",                                                                           ],
  0x0B70                => [ "Oriya",   "So",   "     ",        "ORIYA ISSHAR",                                                                                                 ],
  0x0B71                => [ "Oriya",   "Lo",   "     ",        "ORIYA LETTER WA",                                                                                              ],

  # Total code points: 84

  # ================================================

  0x0B82                => [ "Tamil",   "Mn",   "     ",        "TAMIL SIGN ANUSVARA",                                                                                          ],
  0x0B83                => [ "Tamil",   "Lo",   "     ",        "TAMIL SIGN VISARGA",                                                                                           ],
  0x0B85..0x0B8A        => [ "Tamil",   "Lo",   "  [6]",        "TAMIL LETTER A..TAMIL LETTER UU",                                                                              ],
  0x0B8E..0x0B90        => [ "Tamil",   "Lo",   "  [3]",        "TAMIL LETTER E..TAMIL LETTER AI",                                                                              ],
  0x0B92..0x0B95        => [ "Tamil",   "Lo",   "  [4]",        "TAMIL LETTER O..TAMIL LETTER KA",                                                                              ],
  0x0B99..0x0B9A        => [ "Tamil",   "Lo",   "  [2]",        "TAMIL LETTER NGA..TAMIL LETTER CA",                                                                            ],
  0x0B9C                => [ "Tamil",   "Lo",   "     ",        "TAMIL LETTER JA",                                                                                              ],
  0x0B9E..0x0B9F        => [ "Tamil",   "Lo",   "  [2]",        "TAMIL LETTER NYA..TAMIL LETTER TTA",                                                                           ],
  0x0BA3..0x0BA4        => [ "Tamil",   "Lo",   "  [2]",        "TAMIL LETTER NNA..TAMIL LETTER TA",                                                                            ],
  0x0BA8..0x0BAA        => [ "Tamil",   "Lo",   "  [3]",        "TAMIL LETTER NA..TAMIL LETTER PA",                                                                             ],
  0x0BAE..0x0BB9        => [ "Tamil",   "Lo",   " [12]",        "TAMIL LETTER MA..TAMIL LETTER HA",                                                                             ],
  0x0BBE..0x0BBF        => [ "Tamil",   "Mc",   "  [2]",        "TAMIL VOWEL SIGN AA..TAMIL VOWEL SIGN I",                                                                      ],
  0x0BC0                => [ "Tamil",   "Mn",   "     ",        "TAMIL VOWEL SIGN II",                                                                                          ],
  0x0BC1..0x0BC2        => [ "Tamil",   "Mc",   "  [2]",        "TAMIL VOWEL SIGN U..TAMIL VOWEL SIGN UU",                                                                      ],
  0x0BC6..0x0BC8        => [ "Tamil",   "Mc",   "  [3]",        "TAMIL VOWEL SIGN E..TAMIL VOWEL SIGN AI",                                                                      ],
  0x0BCA..0x0BCC        => [ "Tamil",   "Mc",   "  [3]",        "TAMIL VOWEL SIGN O..TAMIL VOWEL SIGN AU",                                                                      ],
  0x0BCD                => [ "Tamil",   "Mn",   "     ",        "TAMIL SIGN VIRAMA",                                                                                            ],
  0x0BD0                => [ "Tamil",   "Lo",   "     ",        "TAMIL OM",                                                                                                     ],
  0x0BD7                => [ "Tamil",   "Mc",   "     ",        "TAMIL AU LENGTH MARK",                                                                                         ],
  0x0BE6..0x0BEF        => [ "Tamil",   "Nd",   " [10]",        "TAMIL DIGIT ZERO..TAMIL DIGIT NINE",                                                                           ],
  0x0BF0..0x0BF2        => [ "Tamil",   "No",   "  [3]",        "TAMIL NUMBER TEN..TAMIL NUMBER ONE THOUSAND",                                                                  ],
  0x0BF3..0x0BF8        => [ "Tamil",   "So",   "  [6]",        "TAMIL DAY SIGN..TAMIL AS ABOVE SIGN",                                                                          ],
  0x0BF9                => [ "Tamil",   "Sc",   "     ",        "TAMIL RUPEE SIGN",                                                                                             ],
  0x0BFA                => [ "Tamil",   "So",   "     ",        "TAMIL NUMBER SIGN",                                                                                            ],

  # Total code points: 72

  # ================================================

  0x0C01..0x0C03        => [ "Telugu",  "Mc",   "  [3]",        "TELUGU SIGN CANDRABINDU..TELUGU SIGN VISARGA",                                                                 ],
  0x0C05..0x0C0C        => [ "Telugu",  "Lo",   "  [8]",        "TELUGU LETTER A..TELUGU LETTER VOCALIC L",                                                                     ],
  0x0C0E..0x0C10        => [ "Telugu",  "Lo",   "  [3]",        "TELUGU LETTER E..TELUGU LETTER AI",                                                                            ],
  0x0C12..0x0C28        => [ "Telugu",  "Lo",   " [23]",        "TELUGU LETTER O..TELUGU LETTER NA",                                                                            ],
  0x0C2A..0x0C33        => [ "Telugu",  "Lo",   " [10]",        "TELUGU LETTER PA..TELUGU LETTER LLA",                                                                          ],
  0x0C35..0x0C39        => [ "Telugu",  "Lo",   "  [5]",        "TELUGU LETTER VA..TELUGU LETTER HA",                                                                           ],
  0x0C3D                => [ "Telugu",  "Lo",   "     ",        "TELUGU SIGN AVAGRAHA",                                                                                         ],
  0x0C3E..0x0C40        => [ "Telugu",  "Mn",   "  [3]",        "TELUGU VOWEL SIGN AA..TELUGU VOWEL SIGN II",                                                                   ],
  0x0C41..0x0C44        => [ "Telugu",  "Mc",   "  [4]",        "TELUGU VOWEL SIGN U..TELUGU VOWEL SIGN VOCALIC RR",                                                            ],
  0x0C46..0x0C48        => [ "Telugu",  "Mn",   "  [3]",        "TELUGU VOWEL SIGN E..TELUGU VOWEL SIGN AI",                                                                    ],
  0x0C4A..0x0C4D        => [ "Telugu",  "Mn",   "  [4]",        "TELUGU VOWEL SIGN O..TELUGU SIGN VIRAMA",                                                                      ],
  0x0C55..0x0C56        => [ "Telugu",  "Mn",   "  [2]",        "TELUGU LENGTH MARK..TELUGU AI LENGTH MARK",                                                                    ],
  0x0C58..0x0C59        => [ "Telugu",  "Lo",   "  [2]",        "TELUGU LETTER TSA..TELUGU LETTER DZA",                                                                         ],
  0x0C60..0x0C61        => [ "Telugu",  "Lo",   "  [2]",        "TELUGU LETTER VOCALIC RR..TELUGU LETTER VOCALIC LL",                                                           ],
  0x0C62..0x0C63        => [ "Telugu",  "Mn",   "  [2]",        "TELUGU VOWEL SIGN VOCALIC L..TELUGU VOWEL SIGN VOCALIC LL",                                                    ],
  0x0C66..0x0C6F        => [ "Telugu",  "Nd",   " [10]",        "TELUGU DIGIT ZERO..TELUGU DIGIT NINE",                                                                         ],
  0x0C78..0x0C7E        => [ "Telugu",  "No",   "  [7]",        "TELUGU FRACTION DIGIT ZERO FOR ODD POWERS OF FOUR..TELUGU FRACTION DIGIT THREE FOR EVEN POWERS OF FOUR",       ],
  0x0C7F                => [ "Telugu",  "So",   "     ",        "TELUGU SIGN TUUMU",                                                                                            ],

  # Total code points: 93

  # ================================================

  0x0C82..0x0C83        => [ "Kannada", "Mc",   "  [2]",        "KANNADA SIGN ANUSVARA..KANNADA SIGN VISARGA",                                                                  ],
  0x0C85..0x0C8C        => [ "Kannada", "Lo",   "  [8]",        "KANNADA LETTER A..KANNADA LETTER VOCALIC L",                                                                   ],
  0x0C8E..0x0C90        => [ "Kannada", "Lo",   "  [3]",        "KANNADA LETTER E..KANNADA LETTER AI",                                                                          ],
  0x0C92..0x0CA8        => [ "Kannada", "Lo",   " [23]",        "KANNADA LETTER O..KANNADA LETTER NA",                                                                          ],
  0x0CAA..0x0CB3        => [ "Kannada", "Lo",   " [10]",        "KANNADA LETTER PA..KANNADA LETTER LLA",                                                                        ],
  0x0CB5..0x0CB9        => [ "Kannada", "Lo",   "  [5]",        "KANNADA LETTER VA..KANNADA LETTER HA",                                                                         ],
  0x0CBC                => [ "Kannada", "Mn",   "     ",        "KANNADA SIGN NUKTA",                                                                                           ],
  0x0CBD                => [ "Kannada", "Lo",   "     ",        "KANNADA SIGN AVAGRAHA",                                                                                        ],
  0x0CBE                => [ "Kannada", "Mc",   "     ",        "KANNADA VOWEL SIGN AA",                                                                                        ],
  0x0CBF                => [ "Kannada", "Mn",   "     ",        "KANNADA VOWEL SIGN I",                                                                                         ],
  0x0CC0..0x0CC4        => [ "Kannada", "Mc",   "  [5]",        "KANNADA VOWEL SIGN II..KANNADA VOWEL SIGN VOCALIC RR",                                                         ],
  0x0CC6                => [ "Kannada", "Mn",   "     ",        "KANNADA VOWEL SIGN E",                                                                                         ],
  0x0CC7..0x0CC8        => [ "Kannada", "Mc",   "  [2]",        "KANNADA VOWEL SIGN EE..KANNADA VOWEL SIGN AI",                                                                 ],
  0x0CCA..0x0CCB        => [ "Kannada", "Mc",   "  [2]",        "KANNADA VOWEL SIGN O..KANNADA VOWEL SIGN OO",                                                                  ],
  0x0CCC..0x0CCD        => [ "Kannada", "Mn",   "  [2]",        "KANNADA VOWEL SIGN AU..KANNADA SIGN VIRAMA",                                                                   ],
  0x0CD5..0x0CD6        => [ "Kannada", "Mc",   "  [2]",        "KANNADA LENGTH MARK..KANNADA AI LENGTH MARK",                                                                  ],
  0x0CDE                => [ "Kannada", "Lo",   "     ",        "KANNADA LETTER FA",                                                                                            ],
  0x0CE0..0x0CE1        => [ "Kannada", "Lo",   "  [2]",        "KANNADA LETTER VOCALIC RR..KANNADA LETTER VOCALIC LL",                                                         ],
  0x0CE2..0x0CE3        => [ "Kannada", "Mn",   "  [2]",        "KANNADA VOWEL SIGN VOCALIC L..KANNADA VOWEL SIGN VOCALIC LL",                                                  ],
  0x0CE6..0x0CEF        => [ "Kannada", "Nd",   " [10]",        "KANNADA DIGIT ZERO..KANNADA DIGIT NINE",                                                                       ],

  # Total code points: 84

  # ================================================

  0x0D02..0x0D03        => [ "Malayalam",       "Mc",   "  [2]",        "MALAYALAM SIGN ANUSVARA..MALAYALAM SIGN VISARGA",                                                      ],
  0x0D05..0x0D0C        => [ "Malayalam",       "Lo",   "  [8]",        "MALAYALAM LETTER A..MALAYALAM LETTER VOCALIC L",                                                       ],
  0x0D0E..0x0D10        => [ "Malayalam",       "Lo",   "  [3]",        "MALAYALAM LETTER E..MALAYALAM LETTER AI",                                                              ],
  0x0D12..0x0D28        => [ "Malayalam",       "Lo",   " [23]",        "MALAYALAM LETTER O..MALAYALAM LETTER NA",                                                              ],
  0x0D2A..0x0D39        => [ "Malayalam",       "Lo",   " [16]",        "MALAYALAM LETTER PA..MALAYALAM LETTER HA",                                                             ],
  0x0D3D                => [ "Malayalam",       "Lo",   "     ",        "MALAYALAM SIGN AVAGRAHA",                                                                              ],
  0x0D3E..0x0D40        => [ "Malayalam",       "Mc",   "  [3]",        "MALAYALAM VOWEL SIGN AA..MALAYALAM VOWEL SIGN II",                                                     ],
  0x0D41..0x0D44        => [ "Malayalam",       "Mn",   "  [4]",        "MALAYALAM VOWEL SIGN U..MALAYALAM VOWEL SIGN VOCALIC RR",                                              ],
  0x0D46..0x0D48        => [ "Malayalam",       "Mc",   "  [3]",        "MALAYALAM VOWEL SIGN E..MALAYALAM VOWEL SIGN AI",                                                      ],
  0x0D4A..0x0D4C        => [ "Malayalam",       "Mc",   "  [3]",        "MALAYALAM VOWEL SIGN O..MALAYALAM VOWEL SIGN AU",                                                      ],
  0x0D4D                => [ "Malayalam",       "Mn",   "     ",        "MALAYALAM SIGN VIRAMA",                                                                                ],
  0x0D57                => [ "Malayalam",       "Mc",   "     ",        "MALAYALAM AU LENGTH MARK",                                                                             ],
  0x0D60..0x0D61        => [ "Malayalam",       "Lo",   "  [2]",        "MALAYALAM LETTER VOCALIC RR..MALAYALAM LETTER VOCALIC LL",                                             ],
  0x0D62..0x0D63        => [ "Malayalam",       "Mn",   "  [2]",        "MALAYALAM VOWEL SIGN VOCALIC L..MALAYALAM VOWEL SIGN VOCALIC LL",                                      ],
  0x0D66..0x0D6F        => [ "Malayalam",       "Nd",   " [10]",        "MALAYALAM DIGIT ZERO..MALAYALAM DIGIT NINE",                                                           ],
  0x0D70..0x0D75        => [ "Malayalam",       "No",   "  [6]",        "MALAYALAM NUMBER TEN..MALAYALAM FRACTION THREE QUARTERS",                                              ],
  0x0D79                => [ "Malayalam",       "So",   "     ",        "MALAYALAM DATE MARK",                                                                                  ],
  0x0D7A..0x0D7F        => [ "Malayalam",       "Lo",   "  [6]",        "MALAYALAM LETTER CHILLU NN..MALAYALAM LETTER CHILLU K",                                                ],

  # Total code points: 95

  # ================================================

  0x0D82..0x0D83        => [ "Sinhala", "Mc",   "  [2]",        "SINHALA SIGN ANUSVARAYA..SINHALA SIGN VISARGAYA",                                                              ],
  0x0D85..0x0D96        => [ "Sinhala", "Lo",   " [18]",        "SINHALA LETTER AYANNA..SINHALA LETTER AUYANNA",                                                                ],
  0x0D9A..0x0DB1        => [ "Sinhala", "Lo",   " [24]",        "SINHALA LETTER ALPAPRAANA KAYANNA..SINHALA LETTER DANTAJA NAYANNA",                                            ],
  0x0DB3..0x0DBB        => [ "Sinhala", "Lo",   "  [9]",        "SINHALA LETTER SANYAKA DAYANNA..SINHALA LETTER RAYANNA",                                                       ],
  0x0DBD                => [ "Sinhala", "Lo",   "     ",        "SINHALA LETTER DANTAJA LAYANNA",                                                                               ],
  0x0DC0..0x0DC6        => [ "Sinhala", "Lo",   "  [7]",        "SINHALA LETTER VAYANNA..SINHALA LETTER FAYANNA",                                                               ],
  0x0DCA                => [ "Sinhala", "Mn",   "     ",        "SINHALA SIGN AL-LAKUNA",                                                                                       ],
  0x0DCF..0x0DD1        => [ "Sinhala", "Mc",   "  [3]",        "SINHALA VOWEL SIGN AELA-PILLA..SINHALA VOWEL SIGN DIGA AEDA-PILLA",                                            ],
  0x0DD2..0x0DD4        => [ "Sinhala", "Mn",   "  [3]",        "SINHALA VOWEL SIGN KETTI IS-PILLA..SINHALA VOWEL SIGN KETTI PAA-PILLA",                                        ],
  0x0DD6                => [ "Sinhala", "Mn",   "     ",        "SINHALA VOWEL SIGN DIGA PAA-PILLA",                                                                            ],
  0x0DD8..0x0DDF        => [ "Sinhala", "Mc",   "  [8]",        "SINHALA VOWEL SIGN GAETTA-PILLA..SINHALA VOWEL SIGN GAYANUKITTA",                                              ],
  0x0DF2..0x0DF3        => [ "Sinhala", "Mc",   "  [2]",        "SINHALA VOWEL SIGN DIGA GAETTA-PILLA..SINHALA VOWEL SIGN DIGA GAYANUKITTA",                                    ],
  0x0DF4                => [ "Sinhala", "Po",   "     ",        "SINHALA PUNCTUATION KUNDDALIYA",                                                                               ],

  # Total code points: 80

  # ================================================

  0x0E01..0x0E30        => [ "Thai",    "Lo",   " [48]",        "THAI CHARACTER KO KAI..THAI CHARACTER SARA A",                                                                 ],
  0x0E31                => [ "Thai",    "Mn",   "     ",        "THAI CHARACTER MAI HAN-AKAT",                                                                                  ],
  0x0E32..0x0E33        => [ "Thai",    "Lo",   "  [2]",        "THAI CHARACTER SARA AA..THAI CHARACTER SARA AM",                                                               ],
  0x0E34..0x0E3A        => [ "Thai",    "Mn",   "  [7]",        "THAI CHARACTER SARA I..THAI CHARACTER PHINTHU",                                                                ],
  0x0E40..0x0E45        => [ "Thai",    "Lo",   "  [6]",        "THAI CHARACTER SARA E..THAI CHARACTER LAKKHANGYAO",                                                            ],
  0x0E46                => [ "Thai",    "Lm",   "     ",        "THAI CHARACTER MAIYAMOK",                                                                                      ],
  0x0E47..0x0E4E        => [ "Thai",    "Mn",   "  [8]",        "THAI CHARACTER MAITAIKHU..THAI CHARACTER YAMAKKAN",                                                            ],
  0x0E4F                => [ "Thai",    "Po",   "     ",        "THAI CHARACTER FONGMAN",                                                                                       ],
  0x0E50..0x0E59        => [ "Thai",    "Nd",   " [10]",        "THAI DIGIT ZERO..THAI DIGIT NINE",                                                                             ],
  0x0E5A..0x0E5B        => [ "Thai",    "Po",   "  [2]",        "THAI CHARACTER ANGKHANKHU..THAI CHARACTER KHOMUT",                                                             ],

  # Total code points: 86

  # ================================================

  0x0E81..0x0E82        => [ "Lao",     "Lo",   "  [2]",        "LAO LETTER KO..LAO LETTER KHO SUNG",                                                                           ],
  0x0E84                => [ "Lao",     "Lo",   "     ",        "LAO LETTER KHO TAM",                                                                                           ],
  0x0E87..0x0E88        => [ "Lao",     "Lo",   "  [2]",        "LAO LETTER NGO..LAO LETTER CO",                                                                                ],
  0x0E8A                => [ "Lao",     "Lo",   "     ",        "LAO LETTER SO TAM",                                                                                            ],
  0x0E8D                => [ "Lao",     "Lo",   "     ",        "LAO LETTER NYO",                                                                                               ],
  0x0E94..0x0E97        => [ "Lao",     "Lo",   "  [4]",        "LAO LETTER DO..LAO LETTER THO TAM",                                                                            ],
  0x0E99..0x0E9F        => [ "Lao",     "Lo",   "  [7]",        "LAO LETTER NO..LAO LETTER FO SUNG",                                                                            ],
  0x0EA1..0x0EA3        => [ "Lao",     "Lo",   "  [3]",        "LAO LETTER MO..LAO LETTER LO LING",                                                                            ],
  0x0EA5                => [ "Lao",     "Lo",   "     ",        "LAO LETTER LO LOOT",                                                                                           ],
  0x0EA7                => [ "Lao",     "Lo",   "     ",        "LAO LETTER WO",                                                                                                ],
  0x0EAA..0x0EAB        => [ "Lao",     "Lo",   "  [2]",        "LAO LETTER SO SUNG..LAO LETTER HO SUNG",                                                                       ],
  0x0EAD..0x0EB0        => [ "Lao",     "Lo",   "  [4]",        "LAO LETTER O..LAO VOWEL SIGN A",                                                                               ],
  0x0EB1                => [ "Lao",     "Mn",   "     ",        "LAO VOWEL SIGN MAI KAN",                                                                                       ],
  0x0EB2..0x0EB3        => [ "Lao",     "Lo",   "  [2]",        "LAO VOWEL SIGN AA..LAO VOWEL SIGN AM",                                                                         ],
  0x0EB4..0x0EB9        => [ "Lao",     "Mn",   "  [6]",        "LAO VOWEL SIGN I..LAO VOWEL SIGN UU",                                                                          ],
  0x0EBB..0x0EBC        => [ "Lao",     "Mn",   "  [2]",        "LAO VOWEL SIGN MAI KON..LAO SEMIVOWEL SIGN LO",                                                                ],
  0x0EBD                => [ "Lao",     "Lo",   "     ",        "LAO SEMIVOWEL SIGN NYO",                                                                                       ],
  0x0EC0..0x0EC4        => [ "Lao",     "Lo",   "  [5]",        "LAO VOWEL SIGN E..LAO VOWEL SIGN AI",                                                                          ],
  0x0EC6                => [ "Lao",     "Lm",   "     ",        "LAO KO LA",                                                                                                    ],
  0x0EC8..0x0ECD        => [ "Lao",     "Mn",   "  [6]",        "LAO TONE MAI EK..LAO NIGGAHITA",                                                                               ],
  0x0ED0..0x0ED9        => [ "Lao",     "Nd",   " [10]",        "LAO DIGIT ZERO..LAO DIGIT NINE",                                                                               ],
  0x0EDC..0x0EDD        => [ "Lao",     "Lo",   "  [2]",        "LAO HO NO..LAO HO MO",                                                                                         ],

  # Total code points: 65

  # ================================================

  0x0F00                => [ "Tibetan", "Lo",   "     ",        "TIBETAN SYLLABLE OM",                                                                                          ],
  0x0F01..0x0F03        => [ "Tibetan", "So",   "  [3]",        "TIBETAN MARK GTER YIG MGO TRUNCATED A..TIBETAN MARK GTER YIG MGO -UM GTER TSHEG MA",                           ],
  0x0F04..0x0F12        => [ "Tibetan", "Po",   " [15]",        "TIBETAN MARK INITIAL YIG MGO MDUN MA..TIBETAN MARK RGYA GRAM SHAD",                                            ],
  0x0F13..0x0F17        => [ "Tibetan", "So",   "  [5]",        "TIBETAN MARK CARET -DZUD RTAGS ME LONG CAN..TIBETAN ASTROLOGICAL SIGN SGRA GCAN -CHAR RTAGS",                  ],
  0x0F18..0x0F19        => [ "Tibetan", "Mn",   "  [2]",        "TIBETAN ASTROLOGICAL SIGN -KHYUD PA..TIBETAN ASTROLOGICAL SIGN SDONG TSHUGS",                                  ],
  0x0F1A..0x0F1F        => [ "Tibetan", "So",   "  [6]",        "TIBETAN SIGN RDEL DKAR GCIG..TIBETAN SIGN RDEL DKAR RDEL NAG",                                                 ],
  0x0F20..0x0F29        => [ "Tibetan", "Nd",   " [10]",        "TIBETAN DIGIT ZERO..TIBETAN DIGIT NINE",                                                                       ],
  0x0F2A..0x0F33        => [ "Tibetan", "No",   " [10]",        "TIBETAN DIGIT HALF ONE..TIBETAN DIGIT HALF ZERO",                                                              ],
  0x0F34                => [ "Tibetan", "So",   "     ",        "TIBETAN MARK BSDUS RTAGS",                                                                                     ],
  0x0F35                => [ "Tibetan", "Mn",   "     ",        "TIBETAN MARK NGAS BZUNG NYI ZLA",                                                                              ],
  0x0F36                => [ "Tibetan", "So",   "     ",        "TIBETAN MARK CARET -DZUD RTAGS BZHI MIG CAN",                                                                  ],
  0x0F37                => [ "Tibetan", "Mn",   "     ",        "TIBETAN MARK NGAS BZUNG SGOR RTAGS",                                                                           ],
  0x0F38                => [ "Tibetan", "So",   "     ",        "TIBETAN MARK CHE MGO",                                                                                         ],
  0x0F39                => [ "Tibetan", "Mn",   "     ",        "TIBETAN MARK TSA -PHRU",                                                                                       ],
  0x0F3A                => [ "Tibetan", "Ps",   "     ",        "TIBETAN MARK GUG RTAGS GYON",                                                                                  ],
  0x0F3B                => [ "Tibetan", "Pe",   "     ",        "TIBETAN MARK GUG RTAGS GYAS",                                                                                  ],
  0x0F3C                => [ "Tibetan", "Ps",   "     ",        "TIBETAN MARK ANG KHANG GYON",                                                                                  ],
  0x0F3D                => [ "Tibetan", "Pe",   "     ",        "TIBETAN MARK ANG KHANG GYAS",                                                                                  ],
  0x0F3E..0x0F3F        => [ "Tibetan", "Mc",   "  [2]",        "TIBETAN SIGN YAR TSHES..TIBETAN SIGN MAR TSHES",                                                               ],
  0x0F40..0x0F47        => [ "Tibetan", "Lo",   "  [8]",        "TIBETAN LETTER KA..TIBETAN LETTER JA",                                                                         ],
  0x0F49..0x0F6C        => [ "Tibetan", "Lo",   " [36]",        "TIBETAN LETTER NYA..TIBETAN LETTER RRA",                                                                       ],
  0x0F71..0x0F7E        => [ "Tibetan", "Mn",   " [14]",        "TIBETAN VOWEL SIGN AA..TIBETAN SIGN RJES SU NGA RO",                                                           ],
  0x0F7F                => [ "Tibetan", "Mc",   "     ",        "TIBETAN SIGN RNAM BCAD",                                                                                       ],
  0x0F80..0x0F84        => [ "Tibetan", "Mn",   "  [5]",        "TIBETAN VOWEL SIGN REVERSED I..TIBETAN MARK HALANTA",                                                          ],
  0x0F85                => [ "Tibetan", "Po",   "     ",        "TIBETAN MARK PALUTA",                                                                                          ],
  0x0F86..0x0F87        => [ "Tibetan", "Mn",   "  [2]",        "TIBETAN SIGN LCI RTAGS..TIBETAN SIGN YANG RTAGS",                                                              ],
  0x0F88..0x0F8B        => [ "Tibetan", "Lo",   "  [4]",        "TIBETAN SIGN LCE TSA CAN..TIBETAN SIGN GRU MED RGYINGS",                                                       ],
  0x0F90..0x0F97        => [ "Tibetan", "Mn",   "  [8]",        "TIBETAN SUBJOINED LETTER KA..TIBETAN SUBJOINED LETTER JA",                                                     ],
  0x0F99..0x0FBC        => [ "Tibetan", "Mn",   " [36]",        "TIBETAN SUBJOINED LETTER NYA..TIBETAN SUBJOINED LETTER FIXED-FORM RA",                                         ],
  0x0FBE..0x0FC5        => [ "Tibetan", "So",   "  [8]",        "TIBETAN KU RU KHA..TIBETAN SYMBOL RDO RJE",                                                                    ],
  0x0FC6                => [ "Tibetan", "Mn",   "     ",        "TIBETAN SYMBOL PADMA GDAN",                                                                                    ],
  0x0FC7..0x0FCC        => [ "Tibetan", "So",   "  [6]",        "TIBETAN SYMBOL RDO RJE RGYA GRAM..TIBETAN SYMBOL NOR BU BZHI -KHYIL",                                          ],
  0x0FCE..0x0FCF        => [ "Tibetan", "So",   "  [2]",        "TIBETAN SIGN RDEL NAG RDEL DKAR..TIBETAN SIGN RDEL NAG GSUM",                                                  ],
  0x0FD0..0x0FD4        => [ "Tibetan", "Po",   "  [5]",        "TIBETAN MARK BSKA- SHOG GI MGO RGYAN..TIBETAN MARK CLOSING BRDA RNYING YIG MGO SGAB MA"                        ],

  # Total code points: 201

  # ================================================

  0x1000..0x102A        => [ "Myanmar", "Lo",   " [43]",        "MYANMAR LETTER KA..MYANMAR LETTER AU",                                                                         ],
  0x102B..0x102C        => [ "Myanmar", "Mc",   "  [2]",        "MYANMAR VOWEL SIGN TALL AA..MYANMAR VOWEL SIGN AA",                                                            ],
  0x102D..0x1030        => [ "Myanmar", "Mn",   "  [4]",        "MYANMAR VOWEL SIGN I..MYANMAR VOWEL SIGN UU",                                                                  ],
  0x1031                => [ "Myanmar", "Mc",   "     ",        "MYANMAR VOWEL SIGN E",                                                                                         ],
  0x1032..0x1037        => [ "Myanmar", "Mn",   "  [6]",        "MYANMAR VOWEL SIGN AI..MYANMAR SIGN DOT BELOW",                                                                ],
  0x1038                => [ "Myanmar", "Mc",   "     ",        "MYANMAR SIGN VISARGA",                                                                                         ],
  0x1039..0x103A        => [ "Myanmar", "Mn",   "  [2]",        "MYANMAR SIGN VIRAMA..MYANMAR SIGN ASAT",                                                                       ],
  0x103B..0x103C        => [ "Myanmar", "Mc",   "  [2]",        "MYANMAR CONSONANT SIGN MEDIAL YA..MYANMAR CONSONANT SIGN MEDIAL RA",                                           ],
  0x103D..0x103E        => [ "Myanmar", "Mn",   "  [2]",        "MYANMAR CONSONANT SIGN MEDIAL WA..MYANMAR CONSONANT SIGN MEDIAL HA",                                           ],
  0x103F                => [ "Myanmar", "Lo",   "     ",        "MYANMAR LETTER GREAT SA",                                                                                      ],
  0x1040..0x1049        => [ "Myanmar", "Nd",   " [10]",        "MYANMAR DIGIT ZERO..MYANMAR DIGIT NINE",                                                                       ],
  0x104A..0x104F        => [ "Myanmar", "Po",   "  [6]",        "MYANMAR SIGN LITTLE SECTION..MYANMAR SYMBOL GENITIVE",                                                         ],
  0x1050..0x1055        => [ "Myanmar", "Lo",   "  [6]",        "MYANMAR LETTER SHA..MYANMAR LETTER VOCALIC LL",                                                                ],
  0x1056..0x1057        => [ "Myanmar", "Mc",   "  [2]",        "MYANMAR VOWEL SIGN VOCALIC R..MYANMAR VOWEL SIGN VOCALIC RR",                                                  ],
  0x1058..0x1059        => [ "Myanmar", "Mn",   "  [2]",        "MYANMAR VOWEL SIGN VOCALIC L..MYANMAR VOWEL SIGN VOCALIC LL",                                                  ],
  0x105A..0x105D        => [ "Myanmar", "Lo",   "  [4]",        "MYANMAR LETTER MON NGA..MYANMAR LETTER MON BBE",                                                               ],
  0x105E..0x1060        => [ "Myanmar", "Mn",   "  [3]",        "MYANMAR CONSONANT SIGN MON MEDIAL NA..MYANMAR CONSONANT SIGN MON MEDIAL LA",                                   ],
  0x1061                => [ "Myanmar", "Lo",   "     ",        "MYANMAR LETTER SGAW KAREN SHA",                                                                                ],
  0x1062..0x1064        => [ "Myanmar", "Mc",   "  [3]",        "MYANMAR VOWEL SIGN SGAW KAREN EU..MYANMAR TONE MARK SGAW KAREN KE PHO",                                        ],
  0x1065..0x1066        => [ "Myanmar", "Lo",   "  [2]",        "MYANMAR LETTER WESTERN PWO KAREN THA..MYANMAR LETTER WESTERN PWO KAREN PWA",                                   ],
  0x1067..0x106D        => [ "Myanmar", "Mc",   "  [7]",        "MYANMAR VOWEL SIGN WESTERN PWO KAREN EU..MYANMAR SIGN WESTERN PWO KAREN TONE-5",                               ],
  0x106E..0x1070        => [ "Myanmar", "Lo",   "  [3]",        "MYANMAR LETTER EASTERN PWO KAREN NNA..MYANMAR LETTER EASTERN PWO KAREN GHWA",                                  ],
  0x1071..0x1074        => [ "Myanmar", "Mn",   "  [4]",        "MYANMAR VOWEL SIGN GEBA KAREN I..MYANMAR VOWEL SIGN KAYAH EE",                                                 ],
  0x1075..0x1081        => [ "Myanmar", "Lo",   " [13]",        "MYANMAR LETTER SHAN KA..MYANMAR LETTER SHAN HA",                                                               ],
  0x1082                => [ "Myanmar", "Mn",   "     ",        "MYANMAR CONSONANT SIGN SHAN MEDIAL WA",                                                                        ],
  0x1083..0x1084        => [ "Myanmar", "Mc",   "  [2]",        "MYANMAR VOWEL SIGN SHAN AA..MYANMAR VOWEL SIGN SHAN E",                                                        ],
  0x1085..0x1086        => [ "Myanmar", "Mn",   "  [2]",        "MYANMAR VOWEL SIGN SHAN E ABOVE..MYANMAR VOWEL SIGN SHAN FINAL Y",                                             ],
  0x1087..0x108C        => [ "Myanmar", "Mc",   "  [6]",        "MYANMAR SIGN SHAN TONE-2..MYANMAR SIGN SHAN COUNCIL TONE-3",                                                   ],
  0x108D                => [ "Myanmar", "Mn",   "     ",        "MYANMAR SIGN SHAN COUNCIL EMPHATIC TONE",                                                                      ],
  0x108E                => [ "Myanmar", "Lo",   "     ",        "MYANMAR LETTER RUMAI PALAUNG FA",                                                                              ],
  0x108F                => [ "Myanmar", "Mc",   "     ",        "MYANMAR SIGN RUMAI PALAUNG TONE-5",                                                                            ],
  0x1090..0x1099        => [ "Myanmar", "Nd",   " [10]",        "MYANMAR SHAN DIGIT ZERO..MYANMAR SHAN DIGIT NINE",                                                             ],
  0x109E..0x109F        => [ "Myanmar", "So",   "  [2]",        "MYANMAR SYMBOL SHAN ONE..MYANMAR SYMBOL SHAN EXCLAMATION",                                                     ],

  # Total code points: 156

  # ================================================

  0x10A0..0x10C5        => [ "Georgian",        "L&",   " [38]",        "GEORGIAN CAPITAL LETTER AN..GEORGIAN CAPITAL LETTER HOE",                                              ],
  0x10D0..0x10FA        => [ "Georgian",        "Lo",   " [43]",        "GEORGIAN LETTER AN..GEORGIAN LETTER AIN",                                                              ],
  0x10FC                => [ "Georgian",        "Lm",   "     ",        "MODIFIER LETTER GEORGIAN NAR",                                                                         ],
  0x2D00..0x2D25        => [ "Georgian",        "L&",   " [38]",        "GEORGIAN SMALL LETTER AN..GEORGIAN SMALL LETTER HOE",                                                  ],

  # Total code points: 120

  # ================================================

  0x1100..0x1159        => [ "Hangul",  "Lo",   " [90]",        "HANGUL CHOSEONG KIYEOK..HANGUL CHOSEONG YEORINHIEUH",                                                          ],
  0x115F..0x11A2        => [ "Hangul",  "Lo",   " [68]",        "HANGUL CHOSEONG FILLER..HANGUL JUNGSEONG SSANGARAEA",                                                          ],
  0x11A8..0x11F9        => [ "Hangul",  "Lo",   " [82]",        "HANGUL JONGSEONG KIYEOK..HANGUL JONGSEONG YEORINHIEUH",                                                        ],
  0x3131..0x318E        => [ "Hangul",  "Lo",   " [94]",        "HANGUL LETTER KIYEOK..HANGUL LETTER ARAEAE",                                                                   ],
  0x3200..0x321E        => [ "Hangul",  "So",   " [31]",        "PARENTHESIZED HANGUL KIYEOK..PARENTHESIZED KOREAN CHARACTER O HU",                                             ],
  0x3260..0x327E        => [ "Hangul",  "So",   " [31]",        "CIRCLED HANGUL KIYEOK..CIRCLED HANGUL IEUNG U",                                                                ],
  0xAC00..0xD7A3        => [ "Hangul",  "Lo", "[11172]",        "HANGUL SYLLABLE GA..HANGUL SYLLABLE HIH",                                                                      ],
  0xFFA0..0xFFBE        => [ "Hangul",  "Lo",   " [31]",        "HALFWIDTH HANGUL FILLER..HALFWIDTH HANGUL LETTER HIEUH",                                                       ],
  0xFFC2..0xFFC7        => [ "Hangul",  "Lo",   "  [6]",        "HALFWIDTH HANGUL LETTER A..HALFWIDTH HANGUL LETTER E",                                                         ],
  0xFFCA..0xFFCF        => [ "Hangul",  "Lo",   "  [6]",        "HALFWIDTH HANGUL LETTER YEO..HALFWIDTH HANGUL LETTER OE",                                                      ],
  0xFFD2..0xFFD7        => [ "Hangul",  "Lo",   "  [6]",        "HALFWIDTH HANGUL LETTER YO..HALFWIDTH HANGUL LETTER YU",                                                       ],
  0xFFDA..0xFFDC        => [ "Hangul",  "Lo",   "  [3]",        "HALFWIDTH HANGUL LETTER EU..HALFWIDTH HANGUL LETTER I",                                                        ],

  # Total code points: 11620

  # ================================================

  0x1200..0x1248        => [ "Ethiopic",        "Lo",   " [73]",        "ETHIOPIC SYLLABLE HA..ETHIOPIC SYLLABLE QWA",                                                          ],
  0x124A..0x124D        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE QWI..ETHIOPIC SYLLABLE QWE",                                                         ],
  0x1250..0x1256        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE QHA..ETHIOPIC SYLLABLE QHO",                                                         ],
  0x1258                => [ "Ethiopic",        "Lo",   "     ",        "ETHIOPIC SYLLABLE QHWA",                                                                               ],
  0x125A..0x125D        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE QHWI..ETHIOPIC SYLLABLE QHWE",                                                       ],
  0x1260..0x1288        => [ "Ethiopic",        "Lo",   " [41]",        "ETHIOPIC SYLLABLE BA..ETHIOPIC SYLLABLE XWA",                                                          ],
  0x128A..0x128D        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE XWI..ETHIOPIC SYLLABLE XWE",                                                         ],
  0x1290..0x12B0        => [ "Ethiopic",        "Lo",   " [33]",        "ETHIOPIC SYLLABLE NA..ETHIOPIC SYLLABLE KWA",                                                          ],
  0x12B2..0x12B5        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE KWI..ETHIOPIC SYLLABLE KWE",                                                         ],
  0x12B8..0x12BE        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE KXA..ETHIOPIC SYLLABLE KXO",                                                         ],
  0x12C0                => [ "Ethiopic",        "Lo",   "     ",        "ETHIOPIC SYLLABLE KXWA",                                                                               ],
  0x12C2..0x12C5        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE KXWI..ETHIOPIC SYLLABLE KXWE",                                                       ],
  0x12C8..0x12D6        => [ "Ethiopic",        "Lo",   " [15]",        "ETHIOPIC SYLLABLE WA..ETHIOPIC SYLLABLE PHARYNGEAL O",                                                 ],
  0x12D8..0x1310        => [ "Ethiopic",        "Lo",   " [57]",        "ETHIOPIC SYLLABLE ZA..ETHIOPIC SYLLABLE GWA",                                                          ],
  0x1312..0x1315        => [ "Ethiopic",        "Lo",   "  [4]",        "ETHIOPIC SYLLABLE GWI..ETHIOPIC SYLLABLE GWE",                                                         ],
  0x1318..0x135A        => [ "Ethiopic",        "Lo",   " [67]",        "ETHIOPIC SYLLABLE GGA..ETHIOPIC SYLLABLE FYA",                                                         ],
  0x135F                => [ "Ethiopic",        "Mn",   "     ",        "ETHIOPIC COMBINING GEMINATION MARK",                                                                   ],
  0x1360                => [ "Ethiopic",        "So",   "     ",        "ETHIOPIC SECTION MARK",                                                                                ],
  0x1361..0x1368        => [ "Ethiopic",        "Po",   "  [8]",        "ETHIOPIC WORDSPACE..ETHIOPIC PARAGRAPH SEPARATOR",                                                     ],
  0x1369..0x137C        => [ "Ethiopic",        "No",   " [20]",        "ETHIOPIC DIGIT ONE..ETHIOPIC NUMBER TEN THOUSAND",                                                     ],
  0x1380..0x138F        => [ "Ethiopic",        "Lo",   " [16]",        "ETHIOPIC SYLLABLE SEBATBEIT MWA..ETHIOPIC SYLLABLE PWE",                                               ],
  0x1390..0x1399        => [ "Ethiopic",        "So",   " [10]",        "ETHIOPIC TONAL MARK YIZET..ETHIOPIC TONAL MARK KURT",                                                  ],
  0x2D80..0x2D96        => [ "Ethiopic",        "Lo",   " [23]",        "ETHIOPIC SYLLABLE LOA..ETHIOPIC SYLLABLE GGWE",                                                        ],
  0x2DA0..0x2DA6        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE SSA..ETHIOPIC SYLLABLE SSO",                                                         ],
  0x2DA8..0x2DAE        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE CCA..ETHIOPIC SYLLABLE CCO",                                                         ],
  0x2DB0..0x2DB6        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE ZZA..ETHIOPIC SYLLABLE ZZO",                                                         ],
  0x2DB8..0x2DBE        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE CCHA..ETHIOPIC SYLLABLE CCHO",                                                       ],
  0x2DC0..0x2DC6        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE QYA..ETHIOPIC SYLLABLE QYO",                                                         ],
  0x2DC8..0x2DCE        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE KYA..ETHIOPIC SYLLABLE KYO",                                                         ],
  0x2DD0..0x2DD6        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE XYA..ETHIOPIC SYLLABLE XYO",                                                         ],
  0x2DD8..0x2DDE        => [ "Ethiopic",        "Lo",   "  [7]",        "ETHIOPIC SYLLABLE GYA..ETHIOPIC SYLLABLE GYO",                                                         ],

  # Total code points: 461

  # ================================================

  0x13A0..0x13F4        => [ "Cherokee",        "Lo",   " [85]",        "CHEROKEE LETTER A..CHEROKEE LETTER YV",                                                                ],

  # Total code points: 85

  # ================================================

  0x1401..0x166C        => [ "Canadian_Aboriginal",     "Lo",   "[620]",        "CANADIAN SYLLABICS E..CANADIAN SYLLABICS CARRIER TTSA",                                        ],
  0x166D..0x166E        => [ "Canadian_Aboriginal",     "Po",   "  [2]",        "CANADIAN SYLLABICS CHI SIGN..CANADIAN SYLLABICS FULL STOP",                                    ],
  0x166F..0x1676        => [ "Canadian_Aboriginal",     "Lo",   "  [8]",        "CANADIAN SYLLABICS QAI..CANADIAN SYLLABICS NNGAA",                                             ],

  # Total code points: 630

  # ================================================

  0x1680                => [ "Ogham",   "Zs",   "     ",        "OGHAM SPACE MARK",                                                                                             ],
  0x1681..0x169A        => [ "Ogham",   "Lo",   " [26]",        "OGHAM LETTER BEITH..OGHAM LETTER PEITH",                                                                       ],
  0x169B                => [ "Ogham",   "Ps",   "     ",        "OGHAM FEATHER MARK",                                                                                           ],
  0x169C                => [ "Ogham",   "Pe",   "     ",        "OGHAM REVERSED FEATHER MARK",                                                                                  ],

  # Total code points: 29

  # ================================================

  0x16A0..0x16EA        => [ "Runic",   "Lo",   " [75]",        "RUNIC LETTER FEHU FEOH FE F..RUNIC LETTER X",                                                                  ],
  0x16EE..0x16F0        => [ "Runic",   "Nl",   "  [3]",        "RUNIC ARLAUG SYMBOL..RUNIC BELGTHOR SYMBOL",                                                                   ],

  # Total code points: 78

  # ================================================

  0x1780..0x17B3        => [ "Khmer",   "Lo",   " [52]",        "KHMER LETTER KA..KHMER INDEPENDENT VOWEL QAU",                                                                 ],
  0x17B4..0x17B5        => [ "Khmer",   "Cf",   "  [2]",        "KHMER VOWEL INHERENT AQ..KHMER VOWEL INHERENT AA",                                                             ],
  0x17B6                => [ "Khmer",   "Mc",   "     ",        "KHMER VOWEL SIGN AA",                                                                                          ],
  0x17B7..0x17BD        => [ "Khmer",   "Mn",   "  [7]",        "KHMER VOWEL SIGN I..KHMER VOWEL SIGN UA",                                                                      ],
  0x17BE..0x17C5        => [ "Khmer",   "Mc",   "  [8]",        "KHMER VOWEL SIGN OE..KHMER VOWEL SIGN AU",                                                                     ],
  0x17C6                => [ "Khmer",   "Mn",   "     ",        "KHMER SIGN NIKAHIT",                                                                                           ],
  0x17C7..0x17C8        => [ "Khmer",   "Mc",   "  [2]",        "KHMER SIGN REAHMUK..KHMER SIGN YUUKALEAPINTU",                                                                 ],
  0x17C9..0x17D3        => [ "Khmer",   "Mn",   " [11]",        "KHMER SIGN MUUSIKATOAN..KHMER SIGN BATHAMASAT",                                                                ],
  0x17D4..0x17D6        => [ "Khmer",   "Po",   "  [3]",        "KHMER SIGN KHAN..KHMER SIGN CAMNUC PII KUUH",                                                                  ],
  0x17D7                => [ "Khmer",   "Lm",   "     ",        "KHMER SIGN LEK TOO",                                                                                           ],
  0x17D8..0x17DA        => [ "Khmer",   "Po",   "  [3]",        "KHMER SIGN BEYYAL..KHMER SIGN KOOMUUT",                                                                        ],
  0x17DB                => [ "Khmer",   "Sc",   "     ",        "KHMER CURRENCY SYMBOL RIEL",                                                                                   ],
  0x17DC                => [ "Khmer",   "Lo",   "     ",        "KHMER SIGN AVAKRAHASANYA",                                                                                     ],
  0x17DD                => [ "Khmer",   "Mn",   "     ",        "KHMER SIGN ATTHACAN",                                                                                          ],
  0x17E0..0x17E9        => [ "Khmer",   "Nd",   " [10]",        "KHMER DIGIT ZERO..KHMER DIGIT NINE",                                                                           ],
  0x17F0..0x17F9        => [ "Khmer",   "No",   " [10]",        "KHMER SYMBOL LEK ATTAK SON..KHMER SYMBOL LEK ATTAK PRAM-BUON",                                                 ],
  0x19E0..0x19FF        => [ "Khmer",   "So",   " [32]",        "KHMER SYMBOL PATHAMASAT..KHMER SYMBOL DAP-PRAM ROC",                                                           ],

  # Total code points: 146

  # ================================================

  0x1800..0x1801        => [ "Mongolian",       "Po",   "  [2]",        "MONGOLIAN BIRGA..MONGOLIAN ELLIPSIS",                                                                  ],
  0x1804                => [ "Mongolian",       "Po",   "     ",        "MONGOLIAN COLON",                                                                                      ],
  0x1806                => [ "Mongolian",       "Pd",   "     ",        "MONGOLIAN TODO SOFT HYPHEN",                                                                           ],
  0x1807..0x180A        => [ "Mongolian",       "Po",   "  [4]",        "MONGOLIAN SIBE SYLLABLE BOUNDARY MARKER..MONGOLIAN NIRUGU",                                            ],
  0x180B..0x180D        => [ "Mongolian",       "Mn",   "  [3]",        "MONGOLIAN FREE VARIATION SELECTOR ONE..MONGOLIAN FREE VARIATION SELECTOR THREE"                        ],
  0x180E                => [ "Mongolian",       "Zs",   "     ",        "MONGOLIAN VOWEL SEPARATOR",                                                                            ],
  0x1810..0x1819        => [ "Mongolian",       "Nd",   " [10]",        "MONGOLIAN DIGIT ZERO..MONGOLIAN DIGIT NINE",                                                           ],
  0x1820..0x1842        => [ "Mongolian",       "Lo",   " [35]",        "MONGOLIAN LETTER A..MONGOLIAN LETTER CHI",                                                             ],
  0x1843                => [ "Mongolian",       "Lm",   "     ",        "MONGOLIAN LETTER TODO LONG VOWEL SIGN",                                                                ],
  0x1844..0x1877        => [ "Mongolian",       "Lo",   " [52]",        "MONGOLIAN LETTER TODO E..MONGOLIAN LETTER MANCHU ZHA",                                                 ],
  0x1880..0x18A8        => [ "Mongolian",       "Lo",   " [41]",        "MONGOLIAN LETTER ALI GALI ANUSVARA ONE..MONGOLIAN LETTER MANCHU ALI GALI BHA",                         ],
  0x18A9                => [ "Mongolian",       "Mn",   "     ",        "MONGOLIAN LETTER ALI GALI DAGALGA",                                                                    ],
  0x18AA                => [ "Mongolian",       "Lo",   "     ",        "MONGOLIAN LETTER MANCHU ALI GALI LHA",                                                                 ],

  # Total code points: 153

  # ================================================

  0x3041..0x3096        => [ "Hiragana",        "Lo",   " [86]",        "HIRAGANA LETTER SMALL A..HIRAGANA LETTER SMALL KE",                                                    ],
  0x309D..0x309E        => [ "Hiragana",        "Lm",   "  [2]",        "HIRAGANA ITERATION MARK..HIRAGANA VOICED ITERATION MARK",                                              ],
  0x309F                => [ "Hiragana",        "Lo",   "     ",        "HIRAGANA DIGRAPH YORI",                                                                                ],

  # Total code points: 89

  # ================================================

  0x30A1..0x30FA        => [ "Katakana",        "Lo",   " [90]",        "KATAKANA LETTER SMALL A..KATAKANA LETTER VO",                                                          ],
  0x30FD..0x30FE        => [ "Katakana",        "Lm",   "  [2]",        "KATAKANA ITERATION MARK..KATAKANA VOICED ITERATION MARK",                                              ],
  0x30FF                => [ "Katakana",        "Lo",   "     ",        "KATAKANA DIGRAPH KOTO",                                                                                ],
  0x31F0..0x31FF        => [ "Katakana",        "Lo",   " [16]",        "KATAKANA LETTER SMALL KU..KATAKANA LETTER SMALL RO",                                                   ],
  0x32D0..0x32FE        => [ "Katakana",        "So",   " [47]",        "CIRCLED KATAKANA A..CIRCLED KATAKANA WO",                                                              ],
  0x3300..0x3357        => [ "Katakana",        "So",   " [88]",        "SQUARE APAATO..SQUARE WATTO",                                                                          ],
  0xFF66..0xFF6F        => [ "Katakana",        "Lo",   " [10]",        "HALFWIDTH KATAKANA LETTER WO..HALFWIDTH KATAKANA LETTER SMALL TU",                                     ],
  0xFF71..0xFF9D        => [ "Katakana",        "Lo",   " [45]",        "HALFWIDTH KATAKANA LETTER A..HALFWIDTH KATAKANA LETTER N",                                             ],

  # Total code points: 299

  # ================================================

  0x3105..0x312D        => [ "Bopomofo",        "Lo",   " [41]",        "BOPOMOFO LETTER B..BOPOMOFO LETTER IH",                                                                ],
  0x31A0..0x31B7        => [ "Bopomofo",        "Lo",   " [24]",        "BOPOMOFO LETTER BU..BOPOMOFO FINAL LETTER H",                                                          ],

  # Total code points: 65

  # ================================================

  0x2E80..0x2E99        => [ "Han",     "So",   " [26]",        "CJK RADICAL REPEAT..CJK RADICAL RAP",                                                                          ],
  0x2E9B..0x2EF3        => [ "Han",     "So",   " [89]",        "CJK RADICAL CHOKE..CJK RADICAL C-SIMPLIFIED TURTLE",                                                           ],
  0x2F00..0x2FD5        => [ "Han",     "So",   "[214]",        "KANGXI RADICAL ONE..KANGXI RADICAL FLUTE",                                                                     ],
  0x3005                => [ "Han",     "Lm",   "     ",        "IDEOGRAPHIC ITERATION MARK",                                                                                   ],
  0x3007                => [ "Han",     "Nl",   "     ",        "IDEOGRAPHIC NUMBER ZERO",                                                                                      ],
  0x3021..0x3029        => [ "Han",     "Nl",   "  [9]",        "HANGZHOU NUMERAL ONE..HANGZHOU NUMERAL NINE",                                                                  ],
  0x3038..0x303A        => [ "Han",     "Nl",   "  [3]",        "HANGZHOU NUMERAL TEN..HANGZHOU NUMERAL THIRTY",                                                                ],
  0x303B                => [ "Han",     "Lm",   "     ",        "VERTICAL IDEOGRAPHIC ITERATION MARK",                                                                          ],
  0x3400..0x4DB5        => [ "Han",     "Lo",   "[6582]",       "CJK UNIFIED IDEOGRAPH-3400..CJK UNIFIED IDEOGRAPH-4DB5",                                                       ],
  0x4E00..0x9FC3        => [ "Han",     "Lo",   "[20932]",      "CJK UNIFIED IDEOGRAPH-4E00..CJK UNIFIED IDEOGRAPH-9FC3",                                                       ],
  0xF900..0xFA2D        => [ "Han",     "Lo",   "[302]",        "CJK COMPATIBILITY IDEOGRAPH-F900..CJK COMPATIBILITY IDEOGRAPH-FA2D",                                           ],
  0xFA30..0xFA6A        => [ "Han",     "Lo",   "[59]",         "CJK COMPATIBILITY IDEOGRAPH-FA30..CJK COMPATIBILITY IDEOGRAPH-FA6A",                                           ],
  0xFA70..0xFAD9        => [ "Han",     "Lo",   "[106]",        "CJK COMPATIBILITY IDEOGRAPH-FA70..CJK COMPATIBILITY IDEOGRAPH-FAD9",                                           ],
  0x20000..0x2A6D6      => [ "Han",     "Lo",   "[42711]",      "CJK UNIFIED IDEOGRAPH-20000..CJK UNIFIED IDEOGRAPH-2A6D6",                                                     ],
  0x2F800..0x2FA1D      => [ "Han",     "Lo",   "[542]",        "CJK COMPATIBILITY IDEOGRAPH-2F800..CJK COMPATIBILITY IDEOGRAPH-2FA1D",                                         ],

  # Total code points: 71578

  # ================================================

  0xA000..0xA014        => [ "Yi",      "Lo",   " [21]",        "YI SYLLABLE IT..YI SYLLABLE E",                                                                                ],
  0xA015                => [ "Yi",      "Lm",   "     ",        "YI SYLLABLE WU",                                                                                               ],
  0xA016..0xA48C        => [ "Yi",      "Lo",   "[1143]",       "YI SYLLABLE BIT..YI SYLLABLE YYR",                                                                             ],
  0xA490..0xA4C6        => [ "Yi",      "So",   " [55]",        "YI RADICAL QOT..YI RADICAL KE",                                                                                ],

  # Total code points: 1220

  # ================================================

  0x10300..0x1031E      => [ "Old_Italic",      "Lo",   " [31]",        "OLD ITALIC LETTER A..OLD ITALIC LETTER UU",                                                            ],
  0x10320..0x10323      => [ "Old_Italic",      "No",   "  [4]",        "OLD ITALIC NUMERAL ONE..OLD ITALIC NUMERAL FIFTY",                                                     ],

  # Total code points: 35

  # ================================================

  0x10330..0x10340      => [ "Gothic",  "Lo",   " [17]",        "GOTHIC LETTER AHSA..GOTHIC LETTER PAIRTHRA",                                                                   ],
  0x10341               => [ "Gothic",  "Nl",   "     ",        "GOTHIC LETTER NINETY",                                                                                         ],
  0x10342..0x10349      => [ "Gothic",  "Lo",   "  [8]",        "GOTHIC LETTER RAIDA..GOTHIC LETTER OTHAL",                                                                     ],
  0x1034A               => [ "Gothic",  "Nl",   "     ",        "GOTHIC LETTER NINE HUNDRED",                                                                                   ],

  # Total code points: 27

  # ================================================

  0x10400..0x1044F      => [ "Deseret", "L&",   " [80]",        "DESERET CAPITAL LETTER LONG I..DESERET SMALL LETTER EW",                                                       ],

  # Total code points: 80

  # ================================================

  0x0300..0x036F        => [ "Inherited",       "Mn",   "[112]",        "COMBINING GRAVE ACCENT..COMBINING LATIN SMALL LETTER X",                                               ],
  0x064B..0x0655        => [ "Inherited",       "Mn",   " [11]",        "ARABIC FATHATAN..ARABIC HAMZA BELOW",                                                                  ],
  0x0670                => [ "Inherited",       "Mn",   "     ",        "ARABIC LETTER SUPERSCRIPT ALEF",                                                                       ],
  0x0951..0x0952        => [ "Inherited",       "Mn",   "  [2]",        "DEVANAGARI STRESS SIGN UDATTA..DEVANAGARI STRESS SIGN ANUDATTA",                                       ],
  0x1DC0..0x1DE6        => [ "Inherited",       "Mn",   " [39]",        "COMBINING DOTTED GRAVE ACCENT..COMBINING LATIN SMALL LETTER Z",                                        ],
  0x1DFE..0x1DFF        => [ "Inherited",       "Mn",   "  [2]",        "COMBINING LEFT ARROWHEAD ABOVE..COMBINING RIGHT ARROWHEAD AND DOWN ARROWHEAD BELOW",                   ],
  0x200C..0x200D        => [ "Inherited",       "Cf",   "  [2]",        "ZERO WIDTH NON-JOINER..ZERO WIDTH JOINER",                                                             ],
  0x20D0..0x20DC        => [ "Inherited",       "Mn",   " [13]",        "COMBINING LEFT HARPOON ABOVE..COMBINING FOUR DOTS ABOVE",                                              ],
  0x20DD..0x20E0        => [ "Inherited",       "Me",   "  [4]",        "COMBINING ENCLOSING CIRCLE..COMBINING ENCLOSING CIRCLE BACKSLASH",                                     ],
  0x20E1                => [ "Inherited",       "Mn",   "     ",        "COMBINING LEFT RIGHT ARROW ABOVE",                                                                     ],
  0x20E2..0x20E4        => [ "Inherited",       "Me",   "  [3]",        "COMBINING ENCLOSING SCREEN..COMBINING ENCLOSING UPWARD POINTING TRIANGLE",                             ],
  0x20E5..0x20F0        => [ "Inherited",       "Mn",   " [12]",        "COMBINING REVERSE SOLIDUS OVERLAY..COMBINING ASTERISK ABOVE",                                          ],
  0x302A..0x302F        => [ "Inherited",       "Mn",   "  [6]",        "IDEOGRAPHIC LEVEL TONE MARK..HANGUL DOUBLE DOT TONE MARK",                                             ],
  0x3099..0x309A        => [ "Inherited",       "Mn",   "  [2]",        "COMBINING KATAKANA-HIRAGANA VOICED SOUND MARK..COMBINING KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK"     ],
  0xFE00..0xFE0F        => [ "Inherited",       "Mn",   " [16]",        "VARIATION SELECTOR-1..VARIATION SELECTOR-16",                                                          ],
  0xFE20..0xFE26        => [ "Inherited",       "Mn",   "  [7]",        "COMBINING LIGATURE LEFT HALF..COMBINING CONJOINING MACRON",                                            ],
  0x101FD               => [ "Inherited",       "Mn",   "     ",        "PHAISTOS DISC SIGN COMBINING OBLIQUE STROKE",                                                          ],
  0x1D167..0x1D169      => [ "Inherited",       "Mn",   "  [3]",        "MUSICAL SYMBOL COMBINING TREMOLO-1..MUSICAL SYMBOL COMBINING TREMOLO-3",                               ],
  0x1D17B..0x1D182      => [ "Inherited",       "Mn",   "  [8]",        "MUSICAL SYMBOL COMBINING ACCENT..MUSICAL SYMBOL COMBINING LOURE",                                      ],
  0x1D185..0x1D18B      => [ "Inherited",       "Mn",   "  [7]",        "MUSICAL SYMBOL COMBINING DOIT..MUSICAL SYMBOL COMBINING TRIPLE TONGUE",                                ],
  0x1D1AA..0x1D1AD      => [ "Inherited",       "Mn",   "  [4]",        "MUSICAL SYMBOL COMBINING DOWN BOW..MUSICAL SYMBOL COMBINING SNAP PIZZICATO",                           ],
  0xE0100..0xE01EF      => [ "Inherited",       "Mn",   "[240]",        "VARIATION SELECTOR-17..VARIATION SELECTOR-256",                                                        ],

  # Total code points: 496

  # ================================================

  0x1700..0x170C        => [ "Tagalog", "Lo",   " [13]",        "TAGALOG LETTER A..TAGALOG LETTER YA",                                                                          ],
  0x170E..0x1711        => [ "Tagalog", "Lo",   "  [4]",        "TAGALOG LETTER LA..TAGALOG LETTER HA",                                                                         ],
  0x1712..0x1714        => [ "Tagalog", "Mn",   "  [3]",        "TAGALOG VOWEL SIGN I..TAGALOG SIGN VIRAMA",                                                                    ],

  # Total code points: 20

  # ================================================

  0x1720..0x1731        => [ "Hanunoo", "Lo",   " [18]",        "HANUNOO LETTER A..HANUNOO LETTER HA",                                                                          ],
  0x1732..0x1734        => [ "Hanunoo", "Mn",   "  [3]",        "HANUNOO VOWEL SIGN I..HANUNOO SIGN PAMUDPOD",                                                                  ],

  # Total code points: 21

  # ================================================

  0x1740..0x1751        => [ "Buhid",   "Lo",   " [18]",        "BUHID LETTER A..BUHID LETTER HA",                                                                              ],
  0x1752..0x1753        => [ "Buhid",   "Mn",   "  [2]",        "BUHID VOWEL SIGN I..BUHID VOWEL SIGN U",                                                                       ],

  # Total code points: 20

  # ================================================

  0x1760..0x176C        => [ "Tagbanwa",        "Lo",   " [13]",        "TAGBANWA LETTER A..TAGBANWA LETTER YA",                                                                ],
  0x176E..0x1770        => [ "Tagbanwa",        "Lo",   "  [3]",        "TAGBANWA LETTER LA..TAGBANWA LETTER SA",                                                               ],
  0x1772..0x1773        => [ "Tagbanwa",        "Mn",   "  [2]",        "TAGBANWA VOWEL SIGN I..TAGBANWA VOWEL SIGN U",                                                         ],

  # Total code points: 18

  # ================================================

  0x1900..0x191C        => [ "Limbu",   "Lo",   " [29]",        "LIMBU VOWEL-CARRIER LETTER..LIMBU LETTER HA",                                                                  ],
  0x1920..0x1922        => [ "Limbu",   "Mn",   "  [3]",        "LIMBU VOWEL SIGN A..LIMBU VOWEL SIGN U",                                                                       ],
  0x1923..0x1926        => [ "Limbu",   "Mc",   "  [4]",        "LIMBU VOWEL SIGN EE..LIMBU VOWEL SIGN AU",                                                                     ],
  0x1927..0x1928        => [ "Limbu",   "Mn",   "  [2]",        "LIMBU VOWEL SIGN E..LIMBU VOWEL SIGN O",                                                                       ],
  0x1929..0x192B        => [ "Limbu",   "Mc",   "  [3]",        "LIMBU SUBJOINED LETTER YA..LIMBU SUBJOINED LETTER WA",                                                         ],
  0x1930..0x1931        => [ "Limbu",   "Mc",   "  [2]",        "LIMBU SMALL LETTER KA..LIMBU SMALL LETTER NGA",                                                                ],
  0x1932                => [ "Limbu",   "Mn",   "     ",        "LIMBU SMALL LETTER ANUSVARA",                                                                                  ],
  0x1933..0x1938        => [ "Limbu",   "Mc",   "  [6]",        "LIMBU SMALL LETTER TA..LIMBU SMALL LETTER LA",                                                                 ],
  0x1939..0x193B        => [ "Limbu",   "Mn",   "  [3]",        "LIMBU SIGN MUKPHRENG..LIMBU SIGN SA-I",                                                                        ],
  0x1940                => [ "Limbu",   "So",   "     ",        "LIMBU SIGN LOO",                                                                                               ],
  0x1944..0x1945        => [ "Limbu",   "Po",   "  [2]",        "LIMBU EXCLAMATION MARK..LIMBU QUESTION MARK",                                                                  ],
  0x1946..0x194F        => [ "Limbu",   "Nd",   " [10]",        "LIMBU DIGIT ZERO..LIMBU DIGIT NINE",                                                                           ],

  # Total code points: 66

  # ================================================

  0x1950..0x196D        => [ "Tai_Le",  "Lo",   " [30]",        "TAI LE LETTER KA..TAI LE LETTER AI",                                                                           ],
  0x1970..0x1974        => [ "Tai_Le",  "Lo",   "  [5]",        "TAI LE LETTER TONE-2..TAI LE LETTER TONE-6",                                                                   ],

  # Total code points: 35

  # ================================================

  0x10000..0x1000B      => [ "Linear_B",        "Lo",   " [12]",        "LINEAR B SYLLABLE B008 A..LINEAR B SYLLABLE B046 JE",                                                  ],
  0x1000D..0x10026      => [ "Linear_B",        "Lo",   " [26]",        "LINEAR B SYLLABLE B036 JO..LINEAR B SYLLABLE B032 QO",                                                 ],
  0x10028..0x1003A      => [ "Linear_B",        "Lo",   " [19]",        "LINEAR B SYLLABLE B060 RA..LINEAR B SYLLABLE B042 WO",                                                 ],
  0x1003C..0x1003D      => [ "Linear_B",        "Lo",   "  [2]",        "LINEAR B SYLLABLE B017 ZA..LINEAR B SYLLABLE B074 ZE",                                                 ],
  0x1003F..0x1004D      => [ "Linear_B",        "Lo",   " [15]",        "LINEAR B SYLLABLE B020 ZO..LINEAR B SYLLABLE B091 TWO",                                                ],
  0x10050..0x1005D      => [ "Linear_B",        "Lo",   " [14]",        "LINEAR B SYMBOL B018..LINEAR B SYMBOL B089",                                                           ],
  0x10080..0x100FA      => [ "Linear_B",        "Lo",   "[123]",        "LINEAR B IDEOGRAM B100 MAN..LINEAR B IDEOGRAM VESSEL B305",                                            ],

  # Total code points: 211

  # ================================================

  0x10380..0x1039D      => [ "Ugaritic",        "Lo",   " [30]",        "UGARITIC LETTER ALPA..UGARITIC LETTER SSU",                                                            ],
  0x1039F               => [ "Ugaritic",        "Po",   "     ",        "UGARITIC WORD DIVIDER",                                                                                ],

  # Total code points: 31

  # ================================================

  0x10450..0x1047F      => [ "Shavian", "Lo",   " [48]",        "SHAVIAN LETTER PEEP..SHAVIAN LETTER YEW",                                                                      ],

  # Total code points: 48

  # ================================================

  0x10480..0x1049D      => [ "Osmanya", "Lo",   " [30]",        "OSMANYA LETTER ALEF..OSMANYA LETTER OO",                                                                       ],
  0x104A0..0x104A9      => [ "Osmanya", "Nd",   " [10]",        "OSMANYA DIGIT ZERO..OSMANYA DIGIT NINE",                                                                       ],

  # Total code points: 40

  # ================================================

  0x10800..0x10805      => [ "Cypriot", "Lo",   "  [6]",        "CYPRIOT SYLLABLE A..CYPRIOT SYLLABLE JA",                                                                      ],
  0x10808               => [ "Cypriot", "Lo",   "     ",        "CYPRIOT SYLLABLE JO",                                                                                          ],
  0x1080A..0x10835      => [ "Cypriot", "Lo",   " [44]",        "CYPRIOT SYLLABLE KA..CYPRIOT SYLLABLE WO",                                                                     ],
  0x10837..0x10838      => [ "Cypriot", "Lo",   "  [2]",        "CYPRIOT SYLLABLE XA..CYPRIOT SYLLABLE XE",                                                                     ],
  0x1083C               => [ "Cypriot", "Lo",   "     ",        "CYPRIOT SYLLABLE ZA",                                                                                          ],
  0x1083F               => [ "Cypriot", "Lo",   "     ",        "CYPRIOT SYLLABLE ZO",                                                                                          ],

  # Total code points: 55

  # ================================================

  0x2800..0x28FF        => [ "Braille", "So",   "[256]",        "BRAILLE PATTERN BLANK..BRAILLE PATTERN DOTS-12345678",                                                         ],

  # Total code points: 256

  # ================================================

  0x1A00..0x1A16        => [ "Buginese",        "Lo",   " [23]",        "BUGINESE LETTER KA..BUGINESE LETTER HA",                                                               ],
  0x1A17..0x1A18        => [ "Buginese",        "Mn",   "  [2]",        "BUGINESE VOWEL SIGN I..BUGINESE VOWEL SIGN U",                                                         ],
  0x1A19..0x1A1B        => [ "Buginese",        "Mc",   "  [3]",        "BUGINESE VOWEL SIGN E..BUGINESE VOWEL SIGN AE",                                                        ],
  0x1A1E..0x1A1F        => [ "Buginese",        "Po",   "  [2]",        "BUGINESE PALLAWA..BUGINESE END OF SECTION",                                                            ],

  # Total code points: 30

  # ================================================

  0x03E2..0x03EF        => [ "Coptic",  "L&",   " [14]",        "COPTIC CAPITAL LETTER SHEI..COPTIC SMALL LETTER DEI",                                                          ],
  0x2C80..0x2CE4        => [ "Coptic",  "L&",   "[101]",        "COPTIC CAPITAL LETTER ALFA..COPTIC SYMBOL KAI",                                                                ],
  0x2CE5..0x2CEA        => [ "Coptic",  "So",   "  [6]",        "COPTIC SYMBOL MI RO..COPTIC SYMBOL SHIMA SIMA",                                                                ],
  0x2CF9..0x2CFC        => [ "Coptic",  "Po",   "  [4]",        "COPTIC OLD NUBIAN FULL STOP..COPTIC OLD NUBIAN VERSE DIVIDER",                                                 ],
  0x2CFD                => [ "Coptic",  "No",   "     ",        "COPTIC FRACTION ONE HALF",                                                                                     ],
  0x2CFE..0x2CFF        => [ "Coptic",  "Po",   "  [2]",        "COPTIC FULL STOP..COPTIC MORPHOLOGICAL DIVIDER",                                                               ],

  # Total code points: 128

  # ================================================

  0x1980..0x19A9        => [ "New_Tai_Lue",     "Lo",   " [42]",        "NEW TAI LUE LETTER HIGH QA..NEW TAI LUE LETTER LOW XVA",                                               ],
  0x19B0..0x19C0        => [ "New_Tai_Lue",     "Mc",   " [17]",        "NEW TAI LUE VOWEL SIGN VOWEL SHORTENER..NEW TAI LUE VOWEL SIGN IY",                                    ],
  0x19C1..0x19C7        => [ "New_Tai_Lue",     "Lo",   "  [7]",        "NEW TAI LUE LETTER FINAL V..NEW TAI LUE LETTER FINAL B",                                               ],
  0x19C8..0x19C9        => [ "New_Tai_Lue",     "Mc",   "  [2]",        "NEW TAI LUE TONE MARK-1..NEW TAI LUE TONE MARK-2",                                                     ],
  0x19D0..0x19D9        => [ "New_Tai_Lue",     "Nd",   " [10]",        "NEW TAI LUE DIGIT ZERO..NEW TAI LUE DIGIT NINE",                                                       ],
  0x19DE..0x19DF        => [ "New_Tai_Lue",     "Po",   "  [2]",        "NEW TAI LUE SIGN LAE..NEW TAI LUE SIGN LAEV",                                                          ],

  # Total code points: 80

  # ================================================

  0x2C00..0x2C2E        => [ "Glagolitic",      "L&",   " [47]",        "GLAGOLITIC CAPITAL LETTER AZU..GLAGOLITIC CAPITAL LETTER LATINATE MYSLITE",                            ],
  0x2C30..0x2C5E        => [ "Glagolitic",      "L&",   " [47]",        "GLAGOLITIC SMALL LETTER AZU..GLAGOLITIC SMALL LETTER LATINATE MYSLITE",                                ],

  # Total code points: 94

  # ================================================

  0x2D30..0x2D65        => [ "Tifinagh",        "Lo",   " [54]",        "TIFINAGH LETTER YA..TIFINAGH LETTER YAZZ",                                                             ],
  0x2D6F                => [ "Tifinagh",        "Lm",   "     ",        "TIFINAGH MODIFIER LETTER LABIALIZATION MARK",                                                          ],

  # Total code points: 55

  # ================================================

  0xA800..0xA801        => [ "Syloti_Nagri",    "Lo",   "  [2]",        "SYLOTI NAGRI LETTER A..SYLOTI NAGRI LETTER I",                                                         ],
  0xA802                => [ "Syloti_Nagri",    "Mn",   "     ",        "SYLOTI NAGRI SIGN DVISVARA",                                                                           ],
  0xA803..0xA805        => [ "Syloti_Nagri",    "Lo",   "  [3]",        "SYLOTI NAGRI LETTER U..SYLOTI NAGRI LETTER O",                                                         ],
  0xA806                => [ "Syloti_Nagri",    "Mn",   "     ",        "SYLOTI NAGRI SIGN HASANTA",                                                                            ],
  0xA807..0xA80A        => [ "Syloti_Nagri",    "Lo",   "  [4]",        "SYLOTI NAGRI LETTER KO..SYLOTI NAGRI LETTER GHO",                                                      ],
  0xA80B                => [ "Syloti_Nagri",    "Mn",   "     ",        "SYLOTI NAGRI SIGN ANUSVARA",                                                                           ],
  0xA80C..0xA822        => [ "Syloti_Nagri",    "Lo",   " [23]",        "SYLOTI NAGRI LETTER CO..SYLOTI NAGRI LETTER HO",                                                       ],
  0xA823..0xA824        => [ "Syloti_Nagri",    "Mc",   "  [2]",        "SYLOTI NAGRI VOWEL SIGN A..SYLOTI NAGRI VOWEL SIGN I",                                                 ],
  0xA825..0xA826        => [ "Syloti_Nagri",    "Mn",   "  [2]",        "SYLOTI NAGRI VOWEL SIGN U..SYLOTI NAGRI VOWEL SIGN E",                                                 ],
  0xA827                => [ "Syloti_Nagri",    "Mc",   "     ",        "SYLOTI NAGRI VOWEL SIGN OO",                                                                           ],
  0xA828..0xA82B        => [ "Syloti_Nagri",    "So",   "  [4]",        "SYLOTI NAGRI POETRY MARK-1..SYLOTI NAGRI POETRY MARK-4",                                               ],

  # Total code points: 44

  # ================================================

  0x103A0..0x103C3      => [ "Old_Persian",     "Lo",   " [36]",        "OLD PERSIAN SIGN A..OLD PERSIAN SIGN HA",                                                              ],
  0x103C8..0x103CF      => [ "Old_Persian",     "Lo",   "  [8]",        "OLD PERSIAN SIGN AURAMAZDAA..OLD PERSIAN SIGN BUUMISH",                                                ],
  0x103D0               => [ "Old_Persian",     "Po",   "     ",        "OLD PERSIAN WORD DIVIDER",                                                                             ],
  0x103D1..0x103D5      => [ "Old_Persian",     "Nl",   "  [5]",        "OLD PERSIAN NUMBER ONE..OLD PERSIAN NUMBER HUNDRED",                                                   ],

  # Total code points: 50

  # ================================================

  0x10A00               => [ "Kharoshthi",      "Lo",   "     ",        "KHAROSHTHI LETTER A",                                                                                  ],
  0x10A01..0x10A03      => [ "Kharoshthi",      "Mn",   "  [3]",        "KHAROSHTHI VOWEL SIGN I..KHAROSHTHI VOWEL SIGN VOCALIC R",                                             ],
  0x10A05..0x10A06      => [ "Kharoshthi",      "Mn",   "  [2]",        "KHAROSHTHI VOWEL SIGN E..KHAROSHTHI VOWEL SIGN O",                                                     ],
  0x10A0C..0x10A0F      => [ "Kharoshthi",      "Mn",   "  [4]",        "KHAROSHTHI VOWEL LENGTH MARK..KHAROSHTHI SIGN VISARGA",                                                ],
  0x10A10..0x10A13      => [ "Kharoshthi",      "Lo",   "  [4]",        "KHAROSHTHI LETTER KA..KHAROSHTHI LETTER GHA",                                                          ],
  0x10A15..0x10A17      => [ "Kharoshthi",      "Lo",   "  [3]",        "KHAROSHTHI LETTER CA..KHAROSHTHI LETTER JA",                                                           ],
  0x10A19..0x10A33      => [ "Kharoshthi",      "Lo",   " [27]",        "KHAROSHTHI LETTER NYA..KHAROSHTHI LETTER TTTHA",                                                       ],
  0x10A38..0x10A3A      => [ "Kharoshthi",      "Mn",   "  [3]",        "KHAROSHTHI SIGN BAR ABOVE..KHAROSHTHI SIGN DOT BELOW",                                                 ],
  0x10A3F               => [ "Kharoshthi",      "Mn",   "     ",        "KHAROSHTHI VIRAMA",                                                                                    ],
  0x10A40..0x10A47      => [ "Kharoshthi",      "No",   "  [8]",        "KHAROSHTHI DIGIT ONE..KHAROSHTHI NUMBER ONE THOUSAND",                                                 ],
  0x10A50..0x10A58      => [ "Kharoshthi",      "Po",   "  [9]",        "KHAROSHTHI PUNCTUATION DOT..KHAROSHTHI PUNCTUATION LINES",                                             ],

  # Total code points: 65

  # ================================================

  0x1B00..0x1B03        => [ "Balinese",        "Mn",   "  [4]",        "BALINESE SIGN ULU RICEM..BALINESE SIGN SURANG",                                                        ],
  0x1B04                => [ "Balinese",        "Mc",   "     ",        "BALINESE SIGN BISAH",                                                                                  ],
  0x1B05..0x1B33        => [ "Balinese",        "Lo",   " [47]",        "BALINESE LETTER AKARA..BALINESE LETTER HA",                                                            ],
  0x1B34                => [ "Balinese",        "Mn",   "     ",        "BALINESE SIGN REREKAN",                                                                                ],
  0x1B35                => [ "Balinese",        "Mc",   "     ",        "BALINESE VOWEL SIGN TEDUNG",                                                                           ],
  0x1B36..0x1B3A        => [ "Balinese",        "Mn",   "  [5]",        "BALINESE VOWEL SIGN ULU..BALINESE VOWEL SIGN RA REPA",                                                 ],
  0x1B3B                => [ "Balinese",        "Mc",   "     ",        "BALINESE VOWEL SIGN RA REPA TEDUNG",                                                                   ],
  0x1B3C                => [ "Balinese",        "Mn",   "     ",        "BALINESE VOWEL SIGN LA LENGA",                                                                         ],
  0x1B3D..0x1B41        => [ "Balinese",        "Mc",   "  [5]",        "BALINESE VOWEL SIGN LA LENGA TEDUNG..BALINESE VOWEL SIGN TALING REPA TEDUNG",                          ],
  0x1B42                => [ "Balinese",        "Mn",   "     ",        "BALINESE VOWEL SIGN PEPET",                                                                            ],
  0x1B43..0x1B44        => [ "Balinese",        "Mc",   "  [2]",        "BALINESE VOWEL SIGN PEPET TEDUNG..BALINESE ADEG ADEG",                                                 ],
  0x1B45..0x1B4B        => [ "Balinese",        "Lo",   "  [7]",        "BALINESE LETTER KAF SASAK..BALINESE LETTER ASYURA SASAK",                                              ],
  0x1B50..0x1B59        => [ "Balinese",        "Nd",   " [10]",        "BALINESE DIGIT ZERO..BALINESE DIGIT NINE",                                                             ],
  0x1B5A..0x1B60        => [ "Balinese",        "Po",   "  [7]",        "BALINESE PANTI..BALINESE PAMENENG",                                                                    ],
  0x1B61..0x1B6A        => [ "Balinese",        "So",   " [10]",        "BALINESE MUSICAL SYMBOL DONG..BALINESE MUSICAL SYMBOL DANG GEDE",                                      ],
  0x1B6B..0x1B73        => [ "Balinese",        "Mn",   "  [9]",        "BALINESE MUSICAL SYMBOL COMBINING TEGEH..BALINESE MUSICAL SYMBOL COMBINING GONG",                      ],
  0x1B74..0x1B7C        => [ "Balinese",        "So",   "  [9]",        "BALINESE MUSICAL SYMBOL RIGHT-HAND OPEN DUG..BALINESE MUSICAL SYMBOL LEFT-HAND PING",                  ],

  # Total code points: 121

  # ================================================

  0x12000..0x1236E      => [ "Cuneiform",       "Lo",   "[879]",        "CUNEIFORM SIGN A..CUNEIFORM SIGN ZUM",                                                                 ],
  0x12400..0x12462      => [ "Cuneiform",       "Nl",   " [99]",        "CUNEIFORM NUMERIC SIGN TWO ASH..CUNEIFORM NUMERIC SIGN OLD ASSYRIAN ONE QUARTER",                      ],
  0x12470..0x12473      => [ "Cuneiform",       "Po",   "  [4]",        "CUNEIFORM PUNCTUATION SIGN OLD ASSYRIAN WORD DIVIDER..CUNEIFORM PUNCTUATION SIGN DIAGONAL TRICOLON"    ],


  # Total code points: 982

  # ================================================

  0x10900..0x10915      => [ "Phoenician",      "Lo",   " [22]",        "PHOENICIAN LETTER ALF..PHOENICIAN LETTER TAU",                                                         ],
  0x10916..0x10919      => [ "Phoenician",      "No",   "  [4]",        "PHOENICIAN NUMBER ONE..PHOENICIAN NUMBER ONE HUNDRED",                                                 ],
  0x1091F               => [ "Phoenician",      "Po",   "     ",        "PHOENICIAN WORD SEPARATOR",                                                                            ],

  # Total code points: 27

  # ================================================

  0xA840..0xA873        => [ "Phags_Pa",        "Lo",   " [52]",        "PHAGS-PA LETTER KA..PHAGS-PA LETTER CANDRABINDU",                                                      ],
  0xA874..0xA877        => [ "Phags_Pa",        "Po",   "  [4]",        "PHAGS-PA SINGLE HEAD MARK..PHAGS-PA MARK DOUBLE SHAD",                                                 ],

  # Total code points: 56

  # ================================================

  0x07C0..0x07C9        => [ "Nko",     "Nd",   " [10]",        "NKO DIGIT ZERO..NKO DIGIT NINE",                                                                               ],
  0x07CA..0x07EA        => [ "Nko",     "Lo",   " [33]",        "NKO LETTER A..NKO LETTER JONA RA",                                                                             ],
  0x07EB..0x07F3        => [ "Nko",     "Mn",   "  [9]",        "NKO COMBINING SHORT HIGH TONE..NKO COMBINING DOUBLE DOT ABOVE",                                                ],
  0x07F4..0x07F5        => [ "Nko",     "Lm",   "  [2]",        "NKO HIGH TONE APOSTROPHE..NKO LOW TONE APOSTROPHE",                                                            ],
  0x07F6                => [ "Nko",     "So",   "     ",        "NKO SYMBOL OO DENNEN",                                                                                         ],
  0x07F7..0x07F9        => [ "Nko",     "Po",   "  [3]",        "NKO SYMBOL GBAKURUNEN..NKO EXCLAMATION MARK",                                                                  ],
  0x07FA                => [ "Nko",     "Lm",   "     ",        "NKO LAJANYALAN",                                                                                               ],

  # Total code points: 59

  # ================================================

  0x1B80..0x1B81        => [ "Sundanese",       "Mn",   "  [2]",        "SUNDANESE SIGN PANYECEK..SUNDANESE SIGN PANGLAYAR",                                                    ],
  0x1B82                => [ "Sundanese",       "Mc",   "     ",        "SUNDANESE SIGN PANGWISAD",                                                                             ],
  0x1B83..0x1BA0        => [ "Sundanese",       "Lo",   " [30]",        "SUNDANESE LETTER A..SUNDANESE LETTER HA",                                                              ],
  0x1BA1                => [ "Sundanese",       "Mc",   "     ",        "SUNDANESE CONSONANT SIGN PAMINGKAL",                                                                   ],
  0x1BA2..0x1BA5        => [ "Sundanese",       "Mn",   "  [4]",        "SUNDANESE CONSONANT SIGN PANYAKRA..SUNDANESE VOWEL SIGN PANYUKU",                                      ],
  0x1BA6..0x1BA7        => [ "Sundanese",       "Mc",   "  [2]",        "SUNDANESE VOWEL SIGN PANAELAENG..SUNDANESE VOWEL SIGN PANOLONG",                                       ],
  0x1BA8..0x1BA9        => [ "Sundanese",       "Mn",   "  [2]",        "SUNDANESE VOWEL SIGN PAMEPET..SUNDANESE VOWEL SIGN PANEULEUNG",                                        ],
  0x1BAA                => [ "Sundanese",       "Mc",   "     ",        "SUNDANESE SIGN PAMAAEH",                                                                               ],
  0x1BAE..0x1BAF        => [ "Sundanese",       "Lo",   "  [2]",        "SUNDANESE LETTER KHA..SUNDANESE LETTER SYA",                                                           ],
  0x1BB0..0x1BB9        => [ "Sundanese",       "Nd",   " [10]",        "SUNDANESE DIGIT ZERO..SUNDANESE DIGIT NINE",                                                           ],

  # Total code points: 55

  # ================================================

  0x1C00..0x1C23        => [ "Lepcha",  "Lo",   " [36]",        "LEPCHA LETTER KA..LEPCHA LETTER A",                                                                            ],
  0x1C24..0x1C2B        => [ "Lepcha",  "Mc",   "  [8]",        "LEPCHA SUBJOINED LETTER YA..LEPCHA VOWEL SIGN UU",                                                             ],
  0x1C2C..0x1C33        => [ "Lepcha",  "Mn",   "  [8]",        "LEPCHA VOWEL SIGN E..LEPCHA CONSONANT SIGN T",                                                                 ],
  0x1C34..0x1C35        => [ "Lepcha",  "Mc",   "  [2]",        "LEPCHA CONSONANT SIGN NYIN-DO..LEPCHA CONSONANT SIGN KANG",                                                    ],
  0x1C36..0x1C37        => [ "Lepcha",  "Mn",   "  [2]",        "LEPCHA SIGN RAN..LEPCHA SIGN NUKTA",                                                                           ],
  0x1C3B..0x1C3F        => [ "Lepcha",  "Po",   "  [5]",        "LEPCHA PUNCTUATION TA-ROL..LEPCHA PUNCTUATION TSHOOK",                                                         ],
  0x1C40..0x1C49        => [ "Lepcha",  "Nd",   " [10]",        "LEPCHA DIGIT ZERO..LEPCHA DIGIT NINE",                                                                         ],
  0x1C4D..0x1C4F        => [ "Lepcha",  "Lo",   "  [3]",        "LEPCHA LETTER TTA..LEPCHA LETTER DDA",                                                                         ],

  # Total code points: 74

  # ================================================

  0x1C50..0x1C59        => [ "Ol_Chiki",        "Nd",   " [10]",        "OL CHIKI DIGIT ZERO..OL CHIKI DIGIT NINE",                                                             ],
  0x1C5A..0x1C77        => [ "Ol_Chiki",        "Lo",   " [30]",        "OL CHIKI LETTER LA..OL CHIKI LETTER OH",                                                               ],
  0x1C78..0x1C7D        => [ "Ol_Chiki",        "Lm",   "  [6]",        "OL CHIKI MU TTUDDAG..OL CHIKI AHAD",                                                                   ],
  0x1C7E..0x1C7F        => [ "Ol_Chiki",        "Po",   "  [2]",        "OL CHIKI PUNCTUATION MUCAAD..OL CHIKI PUNCTUATION DOUBLE MUCAAD",                                      ],

  # Total code points: 48

  # ================================================

  0xA500..0xA60B        => [ "Vai",     "Lo",   "[268]",        "VAI SYLLABLE EE..VAI SYLLABLE NG",                                                                             ],
  0xA60C                => [ "Vai",     "Lm",   "     ",        "VAI SYLLABLE LENGTHENER",                                                                                      ],
  0xA60D..0xA60F        => [ "Vai",     "Po",   "  [3]",        "VAI COMMA..VAI QUESTION MARK",                                                                                 ],
  0xA610..0xA61F        => [ "Vai",     "Lo",   " [16]",        "VAI SYLLABLE NDOLE FA..VAI SYMBOL JONG",                                                                       ],
  0xA620..0xA629        => [ "Vai",     "Nd",   " [10]",        "VAI DIGIT ZERO..VAI DIGIT NINE",                                                                               ],
  0xA62A..0xA62B        => [ "Vai",     "Lo",   "  [2]",        "VAI SYLLABLE NDOLE MA..VAI SYLLABLE NDOLE DO",                                                                 ],

  # Total code points: 300

  # ================================================

  0xA880..0xA881        => [ "Saurashtra",      "Mc",   "  [2]",        "SAURASHTRA SIGN ANUSVARA..SAURASHTRA SIGN VISARGA",                                                    ],
  0xA882..0xA8B3        => [ "Saurashtra",      "Lo",   " [50]",        "SAURASHTRA LETTER A..SAURASHTRA LETTER LLA",                                                           ],
  0xA8B4..0xA8C3        => [ "Saurashtra",      "Mc",   " [16]",        "SAURASHTRA CONSONANT SIGN HAARU..SAURASHTRA VOWEL SIGN AU",                                            ],
  0xA8C4                => [ "Saurashtra",      "Mn",   "     ",        "SAURASHTRA SIGN VIRAMA",                                                                               ],
  0xA8CE..0xA8CF        => [ "Saurashtra",      "Po",   "  [2]",        "SAURASHTRA DANDA..SAURASHTRA DOUBLE DANDA",                                                            ],
  0xA8D0..0xA8D9        => [ "Saurashtra",      "Nd",   " [10]",        "SAURASHTRA DIGIT ZERO..SAURASHTRA DIGIT NINE",                                                         ],

  # Total code points: 81

  # ================================================

  0xA900..0xA909        => [ "Kayah_Li",        "Nd",   " [10]",        "KAYAH LI DIGIT ZERO..KAYAH LI DIGIT NINE",                                                             ],
  0xA90A..0xA925        => [ "Kayah_Li",        "Lo",   " [28]",        "KAYAH LI LETTER KA..KAYAH LI LETTER OO",                                                               ],
  0xA926..0xA92D        => [ "Kayah_Li",        "Mn",   "  [8]",        "KAYAH LI VOWEL UE..KAYAH LI TONE CALYA PLOPHU",                                                        ],
  0xA92E..0xA92F        => [ "Kayah_Li",        "Po",   "  [2]",        "KAYAH LI SIGN CWI..KAYAH LI SIGN SHYA",                                                                ],

  # Total code points: 48

  # ================================================

  0xA930..0xA946        => [ "Rejang",  "Lo",   " [23]",        "REJANG LETTER KA..REJANG LETTER A",                                                                            ],
  0xA947..0xA951        => [ "Rejang",  "Mn",   " [11]",        "REJANG VOWEL SIGN I..REJANG CONSONANT SIGN R",                                                                 ],
  0xA952..0xA953        => [ "Rejang",  "Mc",   "  [2]",        "REJANG CONSONANT SIGN H..REJANG VIRAMA",                                                                       ],
  0xA95F                => [ "Rejang",  "Po",   "     ",        "REJANG SECTION MARK",                                                                                          ],

  # Total code points: 37

  # ================================================

  0x10280..0x1029C      => [ "Lycian",  "Lo",   " [29]",        "LYCIAN LETTER A..LYCIAN LETTER X",                                                                             ],

  # Total code points: 29

  # ================================================

  0x102A0..0x102D0      => [ "Carian",  "Lo",   " [49]",        "CARIAN LETTER A..CARIAN LETTER UUU3",                                                                          ],

  # Total code points: 49

  # ================================================

  0x10920..0x10939      => [ "Lydian",  "Lo",   " [26]",        "LYDIAN LETTER A..LYDIAN LETTER C",                                                                             ],
  0x1093F               => [ "Lydian",  "Po",   "     ",        "LYDIAN TRIANGULAR MARK",                                                                                       ],

  # Total code points: 27

  # ================================================

  0xAA00..0xAA28        => [ "Cham",    "Lo",   " [41]",        "CHAM LETTER A..CHAM LETTER HA",                                                                                ],
  0xAA29..0xAA2E        => [ "Cham",    "Mn",   "  [6]",        "CHAM VOWEL SIGN AA..CHAM VOWEL SIGN OE",                                                                       ],
  0xAA2F..0xAA30        => [ "Cham",    "Mc",   "  [2]",        "CHAM VOWEL SIGN O..CHAM VOWEL SIGN AI",                                                                        ],
  0xAA31..0xAA32        => [ "Cham",    "Mn",   "  [2]",        "CHAM VOWEL SIGN AU..CHAM VOWEL SIGN UE",                                                                       ],
  0xAA33..0xAA34        => [ "Cham",    "Mc",   "  [2]",        "CHAM CONSONANT SIGN YA..CHAM CONSONANT SIGN RA",                                                               ],
  0xAA35..0xAA36        => [ "Cham",    "Mn",   "  [2]",        "CHAM CONSONANT SIGN LA..CHAM CONSONANT SIGN WA",                                                               ],
  0xAA40..0xAA42        => [ "Cham",    "Lo",   "  [3]",        "CHAM LETTER FINAL K..CHAM LETTER FINAL NG",                                                                    ],
  0xAA43                => [ "Cham",    "Mn",   "     ",        "CHAM CONSONANT SIGN FINAL NG",                                                                                 ],
  0xAA44..0xAA4B        => [ "Cham",    "Lo",   "  [8]",        "CHAM LETTER FINAL CH..CHAM LETTER FINAL SS",                                                                   ],
  0xAA4C                => [ "Cham",    "Mn",   "     ",        "CHAM CONSONANT SIGN FINAL M",                                                                                  ],
  0xAA4D                => [ "Cham",    "Mc",   "     ",        "CHAM CONSONANT SIGN FINAL H",                                                                                  ],
  0xAA50..0xAA59        => [ "Cham",    "Nd",   " [10]",        "CHAM DIGIT ZERO..CHAM DIGIT NINE",                                                                             ],
  0xAA5C..0xAA5F        => [ "Cham",    "Po",   "  [4]",        "CHAM PUNCTUATION SPIRAL..CHAM PUNCTUATION TRIPLE DANDA",                                                       ],

  # Total code points: 83
}
# EOF

#
# Classify character
#
# entity  name            cl rng  type    script   rgsz  range name               planerg script  sccode  script2
# 54      Digit Six       48..57  Common  Nd       [10]   DIGIT ZERO..DIGIT NINE  0..127  Latin   Latn    Basic Latin
#
def find_entity_classification(entity_num, freq, entity_name)
  classification_info = UNICODE_CLASSIFICATION_MAPPING.find{|plane, info| plane.include?(entity_num) }
  if !classification_info
    warn_missing_info :classification, entity_num, freq, entity_name
    classification_info = ['', '', '', '', ]
  end
  classification_info
end
