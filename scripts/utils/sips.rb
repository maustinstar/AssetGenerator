#
#  sips.rb
#  Ruby function wrapper for sips CLI
#
#  Created by Michael Verges on 4/18/19.
#

# evaluates shell function and returns output string
def run cmd; return `#{cmd}`.to_s end

# returns width of image (integer)
def width_of image; return run("sips #{image} -g pixelWidth").split(' ').last.to_i end

# resizes image
def scale_to_width sourcename, new_width, outname
  run "sips #{sourcename} --resampleWidth #{new_width} --out #{outname}"
end
