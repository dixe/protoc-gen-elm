#!/bin/bash

set -e

INCLUDE=${PROTO_HOME:-/usr/include}

elm make --optimize --output=elm.tmp.js src/Main.elm
uglifyjs elm.tmp.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' |  uglifyjs --mangle --output elm.min.js
rm elm.tmp.js

mkdir -p google/protobuf/compiler
cat $INCLUDE/google/protobuf/descriptor.proto | sed 's/google\.protobuf/internal.google.protobuf/' > google/protobuf/descriptor.proto
cat $INCLUDE/google/protobuf/compiler/plugin.proto | sed 's/google\.protobuf/internal.google.protobuf/' > google/protobuf/compiler/plugin.proto
protoc --plugin="protoc-gen-elmApi=index.js" --elmApi_out=src google/protobuf/compiler/plugin.proto google/protobuf/descriptor.proto
sed -i "s/ setOneofIndex/ (setOneofIndex << (+) 1)/" src/Internal/Google/Protobuf.elm # we cannot distinquish between 0 and the default (0) - upstream bug or proto2 limitation?
