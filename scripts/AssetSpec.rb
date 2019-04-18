#
#  AssetSpec.rb
#
#  Created by Michael Verges on 4/17/19.
#

require 'json'

def lastdir file, ext; return File.basename dir(file).split('/')[-1], ext end
def dir file; return File.dirname file end
def ext file; return File.extname file end
def base file, ext; return File.basename file, ext end
def parse json; return JSON.parse File.read json end
def run cmd; return `#{cmd}`.to_s end
def sizeof image; return  run("sips " + image + " -g pixelWidth").split(' ').last.to_i end

def large_image filename, json
  index = -1
  maxsize = 0
  json["images"].each_with_index do |image, i|
    unless image["filename"].nil?
      size = (sizeof "#{dir filename}/#{image['filename']}")
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
  return ["#{dir filename}/#{json['images'][index]['filename']}", json['images'][index]['scale']]
end

# Find all image assets
for json in Dir["**/*.imageset/*.json"] do
  file   = parse json
  larget = large_image json, file
  large  = larget.first
  factor = larget.last
  size   = sizeof(large).to_f / factor.to_f
  
  for image in file["images"] do
    scale = image["scale"].to_f
    newsize = (size * scale).to_i.to_s
    out  = "#{dir large}/#{lastdir json, '.*'}@#{scale.to_s}#{ext large}"
    system "sips #{large} --resampleWidth #{newsize} --out #{out}"
    image["filename"] = File.basename(out)
  end
  
  File.write(json, file.to_json)
end

# Find all AppIcon assets
for json in Dir["**/*.appiconset/*.json"] do
  file   = parse json
  large  = (large_image json, file).first
  
  for image in file["images"] do
    scale = image["scale"].to_f
    size  = ((image["size"]).to_s.split 'x').first
    newsize = (size.to_f * scale).to_i.to_s
    out  = "#{dir large}/#{lastdir json, '.*'}@#{newsize}#{ext large}"
    system "sips #{large} --resampleWidth #{newsize} --out #{out}"
    image["filename"] = File.basename(out)
  end
  
  File.write(json, file.to_json)
end
