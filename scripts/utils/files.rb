#
#  files.rb
#  Wrapper functions for Ruby file methods
#
#  Created by Michael Verges on 4/18/19.
#

require 'json'

# returns the name of the last directory in a filepath
# useful for finding the names of .imageset and .appiconset
def lastdir file, ext; return File.basename dir(file).split('/')[-1], ext end

# returns filepath
def dir file; return File.dirname file end

# returns extension
def ext file; return File.extname file end

# returns basename, removing extension
def base file, ext; return File.basename file, ext end

# returns object contents of json
def parse json; return JSON.parse File.read json end

# writes to file
def write file contents; return File.write file, contents end
