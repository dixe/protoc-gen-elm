module Internal.Google.Protobuf.Compiler exposing
    ( CodeGeneratorResponseFeature(..), Version, CodeGeneratorRequest, CodeGeneratorResponse, CodeGeneratorResponseFile
    , versionDecoder, codeGeneratorRequestDecoder, codeGeneratorResponseDecoder
    , toVersionEncoder, toCodeGeneratorRequestEncoder, toCodeGeneratorResponseEncoder
    )

{-| ProtoBuf module: `Internal.Google.Protobuf.Compiler`

This module was generated automatically using

  - [`protoc-gen-elm`](https://www.npmjs.com/package/protoc-gen-elm) 1.0.0-beta-2
  - `protoc` 3.14.0
  - the following specification file: `google/protobuf/compiler/plugin.proto`

To run it use [`elm-protocol-buffers`](https://package.elm-lang.org/packages/eriktim/elm-protocol-buffers/1.1.0) version 1.1.0 or higher.



# Model

@docs CodeGeneratorResponseFeature, Version, CodeGeneratorRequest, CodeGeneratorResponse, CodeGeneratorResponseFile


# Decoder

@docs versionDecoder, codeGeneratorRequestDecoder, codeGeneratorResponseDecoder


# Encoder

@docs toVersionEncoder, toCodeGeneratorRequestEncoder, toCodeGeneratorResponseEncoder

-}

import Http
import Internal.Google.Protobuf
import Protobuf.Decode as Decode
import Protobuf.Encode as Encode


-- RPCS

generatedBaseRequest : String -> (a -> Encode.Encoder) -> a -> (Result Http.Error b -> msg) -> Decode.Decoder b -> Cmd msg
generatedBaseRequest url encoder payload toMsg decoder =
    let

        bytes = Encode.encode (encoder payload)
    in
    Http.post
        { url = url
        , expect = Decode.expectBytes toMsg decoder
        , body = Http.bytesBody "application/x-protobuf" bytes
        }





-- MODEL


{-| `CodeGeneratorResponseFeature` enumeration
-}
type CodeGeneratorResponseFeature
    = FeatureNone
    | FeatureProto3Optional


{-| `Version` message
-}
type alias Version =
    { major : Int
    , minor : Int
    , patch : Int
    , suffix : String
    }


{-| `CodeGeneratorRequest` message
-}
type alias CodeGeneratorRequest =
    { fileToGenerate : List String
    , parameter : String
    , protoFile : List Internal.Google.Protobuf.FileDescriptorProto
    , compilerVersion : Maybe Version
    }


{-| `CodeGeneratorResponse` message
-}
type alias CodeGeneratorResponse =
    { error : String
    , supportedFeatures : Int
    , file : List CodeGeneratorResponseFile
    }


{-| `CodeGeneratorResponseFile` message
-}
type alias CodeGeneratorResponseFile =
    { name : String
    , insertionPoint : String
    , content : String
    , generatedCodeInfo : Maybe Internal.Google.Protobuf.GeneratedCodeInfo
    }



-- DECODER


codeGeneratorResponseFeatureDecoder : Decode.Decoder CodeGeneratorResponseFeature
codeGeneratorResponseFeatureDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    0 ->
                        FeatureNone

                    1 ->
                        FeatureProto3Optional

                    _ ->
                        FeatureNone
            )


{-| `Version` decoder
-}
versionDecoder : Decode.Decoder Version
versionDecoder =
    Decode.message (Version 0 0 0 "")
        [ Decode.optional 1 Decode.int32 setMajor
        , Decode.optional 2 Decode.int32 setMinor
        , Decode.optional 3 Decode.int32 setPatch
        , Decode.optional 4 Decode.string setSuffix
        ]


{-| `CodeGeneratorRequest` decoder
-}
codeGeneratorRequestDecoder : Decode.Decoder CodeGeneratorRequest
codeGeneratorRequestDecoder =
    Decode.message (CodeGeneratorRequest [] "" [] Nothing)
        [ Decode.repeated 1 Decode.string .fileToGenerate setFileToGenerate
        , Decode.optional 2 Decode.string setParameter
        , Decode.repeated 15 Internal.Google.Protobuf.fileDescriptorProtoDecoder .protoFile setProtoFile
        , Decode.optional 3 (Decode.map Just versionDecoder) setCompilerVersion
        ]


{-| `CodeGeneratorResponse` decoder
-}
codeGeneratorResponseDecoder : Decode.Decoder CodeGeneratorResponse
codeGeneratorResponseDecoder =
    Decode.message (CodeGeneratorResponse "" 0 [])
        [ Decode.optional 1 Decode.string setError
        , Decode.optional 2 Decode.uint32 setSupportedFeatures
        , Decode.repeated 15 codeGeneratorResponseFileDecoder .file setFile
        ]


codeGeneratorResponseFileDecoder : Decode.Decoder CodeGeneratorResponseFile
codeGeneratorResponseFileDecoder =
    Decode.message (CodeGeneratorResponseFile "" "" "" Nothing)
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 2 Decode.string setInsertionPoint
        , Decode.optional 15 Decode.string setContent
        , Decode.optional 16 (Decode.map Just Internal.Google.Protobuf.generatedCodeInfoDecoder) setGeneratedCodeInfo
        ]



-- ENCODER


toCodeGeneratorResponseFeatureEncoder : CodeGeneratorResponseFeature -> Encode.Encoder
toCodeGeneratorResponseFeatureEncoder value =
    Encode.int32 <|
        case value of
            FeatureNone ->
                0

            FeatureProto3Optional ->
                1


{-| `Version` encoder
-}
toVersionEncoder : Version -> Encode.Encoder
toVersionEncoder model =
    Encode.message
        [ ( 1, Encode.int32 model.major )
        , ( 2, Encode.int32 model.minor )
        , ( 3, Encode.int32 model.patch )
        , ( 4, Encode.string model.suffix )
        ]


{-| `CodeGeneratorRequest` encoder
-}
toCodeGeneratorRequestEncoder : CodeGeneratorRequest -> Encode.Encoder
toCodeGeneratorRequestEncoder model =
    Encode.message
        [ ( 1, Encode.list Encode.string model.fileToGenerate )
        , ( 2, Encode.string model.parameter )
        , ( 15, Encode.list Internal.Google.Protobuf.toFileDescriptorProtoEncoder model.protoFile )
        , ( 3, (Maybe.withDefault Encode.none << Maybe.map toVersionEncoder) model.compilerVersion )
        ]


{-| `CodeGeneratorResponse` encoder
-}
toCodeGeneratorResponseEncoder : CodeGeneratorResponse -> Encode.Encoder
toCodeGeneratorResponseEncoder model =
    Encode.message
        [ ( 1, Encode.string model.error )
        , ( 2, Encode.uint32 model.supportedFeatures )
        , ( 15, Encode.list toCodeGeneratorResponseFileEncoder model.file )
        ]


toCodeGeneratorResponseFileEncoder : CodeGeneratorResponseFile -> Encode.Encoder
toCodeGeneratorResponseFileEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.string model.insertionPoint )
        , ( 15, Encode.string model.content )
        , ( 16, (Maybe.withDefault Encode.none << Maybe.map Internal.Google.Protobuf.toGeneratedCodeInfoEncoder) model.generatedCodeInfo )
        ]



-- SETTERS


setMajor : a -> { b | major : a } -> { b | major : a }
setMajor value model =
    { model | major = value }


setMinor : a -> { b | minor : a } -> { b | minor : a }
setMinor value model =
    { model | minor = value }


setPatch : a -> { b | patch : a } -> { b | patch : a }
setPatch value model =
    { model | patch = value }


setSuffix : a -> { b | suffix : a } -> { b | suffix : a }
setSuffix value model =
    { model | suffix = value }


setFileToGenerate : a -> { b | fileToGenerate : a } -> { b | fileToGenerate : a }
setFileToGenerate value model =
    { model | fileToGenerate = value }


setParameter : a -> { b | parameter : a } -> { b | parameter : a }
setParameter value model =
    { model | parameter = value }


setProtoFile : a -> { b | protoFile : a } -> { b | protoFile : a }
setProtoFile value model =
    { model | protoFile = value }


setCompilerVersion : a -> { b | compilerVersion : a } -> { b | compilerVersion : a }
setCompilerVersion value model =
    { model | compilerVersion = value }


setError : a -> { b | error : a } -> { b | error : a }
setError value model =
    { model | error = value }


setSupportedFeatures : a -> { b | supportedFeatures : a } -> { b | supportedFeatures : a }
setSupportedFeatures value model =
    { model | supportedFeatures = value }


setFile : a -> { b | file : a } -> { b | file : a }
setFile value model =
    { model | file = value }


setName : a -> { b | name : a } -> { b | name : a }
setName value model =
    { model | name = value }


setInsertionPoint : a -> { b | insertionPoint : a } -> { b | insertionPoint : a }
setInsertionPoint value model =
    { model | insertionPoint = value }


setContent : a -> { b | content : a } -> { b | content : a }
setContent value model =
    { model | content = value }


setGeneratedCodeInfo : a -> { b | generatedCodeInfo : a } -> { b | generatedCodeInfo : a }
setGeneratedCodeInfo value model =
    { model | generatedCodeInfo = value }
