#
#  find_largest.rb
#  Search through assets to fing the largest image
#
#  Created by Michael Verges on 4/18/19.
#

def find_largest filename, json
  index = -1
  maxsize = 0
  json["images"].each_with_index do |image, i|
    unless image["filename"].nil?
      size = width_of "#{dir filename}/#{image['filename']}"
      if size > maxsize
        maxsize = size
        index = i
      end
    end
  end
  # Warn users if upscaling assets
  unless json['images'][index] == json['images'][-1]
    image = lastdir filename, '.*'
    puts "warning: Upscaling from #{maxsize}px occured in asset '#{image}'"
  end
  return json['images'][index]
end
