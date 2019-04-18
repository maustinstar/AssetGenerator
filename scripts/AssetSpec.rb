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
def sizeof image; return  run ("identify -format '%wx%h' " + image) end

def large_image filename, json
  index = -1
  maxsize = 0
  json["images"].each_with_index do |image, i|
    unless image["filename"].nil?
      size = (sizeof "#{dir filename}/#{image['filename']}").split('x').first.to_f
      if size > maxsize
        maxsize = size
        index = i
      end
    end
  end
  # Warn users if upscaling assets
  unless json['images'][index] == json['images'][-1]
    puts sizeof "#{dir filename}/#{json['images'][-1]['filename']}"
    image = lastdir filename, '.*'
    puts "warning: Upscaling from #{maxsize}px occured in asset '#{image}'"
  end
  return ["#{dir filename}/#{json['images'][index]['filename']}", json['images'][index]['scale']]
end

# Find all image assets
Dir["**/*.imageset/*.json"].each do |json|
  file   = parse json
  larget = large_image json, file
  large  = larget.first
  factor = larget.last
  size   = (sizeof large).to_s.split('x').map { |s| s.to_f / factor.to_f }
  
  puts "starting at " + (sizeof large).to_s
  file["images"].each_with_index do |image, i|
    scale = image["scale"].to_f
    newsize = (size.first * scale).to_i.to_s + 'x' + (size.last * scale).to_i.to_s
    puts "newsize " + newsize
    out  = "#{dir large}/#{lastdir json, '.*'}@#{scale.to_s}#{ext large}"
    system "convert #{large} -resize #{newsize} #{out}"
    file["images"][i]["filename"] = File.basename(out)
  end
  
  File.write(json, file.to_json)
end

# Find all AppIcon assets
Dir["**/*.appiconset/*.json"].each do |json|
  file   = parse json
  large  = (large_image json, file).first
  
  puts "starting at " + (sizeof large).to_s
  file["images"].each_with_index do |image, i|
    scale = image["scale"].to_f
    size  = (image["size"]).to_s.split 'x'
    newsize = (size.first.to_f * scale).to_i.to_s + 'x' + (size.last.to_f * scale).to_i.to_s
    puts "newsize " + newsize
    out  = "#{dir large}/#{lastdir json, '.*'}@#{newsize}#{ext large}"
    system "convert #{large} -resize #{newsize} #{out}"
    file["images"][i]["filename"] = File.basename(out)
  end
  
  File.write(json, file.to_json)
end
