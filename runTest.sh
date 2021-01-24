#!/bin/bash

elm make --output=elm.min.js src/Main.elm

protoc --plugin="protoc-gen-elmApi=index.js" --elmApi_out=./ ./api.proto

cp Api.elm ../protoTest/src/Api.elm
