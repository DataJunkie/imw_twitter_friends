#!/usr/bin/env ruby
require 'rubygems'

# Color::RGB.from_html("fed")
# Color::RGB.from_html("#fed")
# Color::RGB.from_html("#cabbed")
# Color::RGB.from_html("cabbed")

# Following stolen from the 'color-tools' gem


# File lib/color/rgb.rb, line 45
def from_html(html_colour)
  html_colour = html_colour.gsub(%r{[#;]}, '')
  case html_colour.size
  when 3
    colours = html_colour.scan(%r{[0-9A-Fa-f]}).map { |el| (el * 2).to_i(16) }
  when 6
    colours = html_colour.scan(%r<[0-9A-Fa-f]{2}>).map { |el| el.to_i(16) }
  else
    raise ArgumentError
  end
  colours
end


# File lib/color/rgb.rb, line 167
def to_hsl r, g, b
  min   = [ r, g, b ].min
  max   = [ r, g, b ].max
  delta = (max - min).to_f

  lum   = (max + min) / 2.0

  if delta <= 1e-5  # close to 0.0, so it's a grey
    hue = 0
    sat = 0
  else
    if (lum - 0.5) <= 1e-5
      sat = delta / (max + min).to_f
    else
      sat = delta / (2 - max - min).to_f
    end

    if r == max
      hue = (g - b) / delta.to_f
    elsif g == max
      hue = (2.0 + b - r) / delta.to_f
    elsif (b - max) <= 1e-5
      hue = (4.0 + r - g) / delta.to_f
    end
    hue /= 6.0

    hue += 1 if hue < 0
    hue -= 1 if hue > 1
  end
  [ hue, sat, lum ]
end
