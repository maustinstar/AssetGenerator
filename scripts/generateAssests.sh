#!/bin/sh

#  AssetGenerator.sh
#
#  Created by Michael Verges on 4/17/19.
#  

if ! brew ls --versions imagemagick > /dev/null; then
    echo error: missing dependency imagemagick
    exit 1
fi

if ! gem list json -i; then
    echo error: missing gem json
    exit 1
fi

ruby ${PROJECT_DIR}/SampleProject/AssetSpec.rb
