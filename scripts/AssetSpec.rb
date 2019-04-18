#
#  AssetSpec.rb
#
#  Created by Michael Verges on 4/17/19.
#

require 'json'
require_relative 'utils/sips'
require_relative 'utils/files'
require_relative 'utils/find_largest'

# Find all image assets
for filename in Dir["**/*.imageset/*.json"] do
  
  # json object for image set
  json  = parse filename
  # json object for largest image in set
  large = find_largest filename, json
  largename = "#{dir filename}/#{large['filename']}"
  # base @1x asset width
  width = width_of(largename).to_f / large['scale'].to_f
  
  # generate all images
  for image in json["images"] do
    scale = image["scale"].to_f
    newsize = (width * scale).to_i.to_s
    out  = "#{dir filename}/#{lastdir filename, '.*'}@#{scale.to_i.to_s}#{ext large['filename']}"
    scale_to_width largename, newsize, out
    # add json reference to new asset
    image["filename"] = base out, ''
    puts image["filename"]
  end
  
  # update asset json
  write filename, json.to_json
end
  
# Find all AppIcon assets
for filename in Dir["**/*.appiconset/*.json"] do
  # json object for image set
  json  = parse filename
  # json object for largest image in set
  large = find_largest filename, json
  
  # generate all images
  for image in json["images"] do
    newsize = (((image["size"]).to_s.split 'x').first.to_f * image["scale"].to_f).to_i.to_s
    out  = "#{dir filename}/#{lastdir filename, '.*'}@#{newsize}#{ext large['filename']}"
    scale_to_width "#{dir filename}/#{large['filename']}", newsize, out
    # add json reference to new asset
    image["filename"] = base out, ''
  end
  
  # update asset json
  write filename, json.to_json
end
