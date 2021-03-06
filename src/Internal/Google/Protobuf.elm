module Internal.Google.Protobuf exposing
    ( FieldDescriptorProtoType(..), FieldDescriptorProtoLabel(..), FileOptionsOptimizeMode(..), FieldOptionsCType(..), FieldOptionsJSType(..), MethodOptionsIdempotencyLevel(..), FileDescriptorSet, FileDescriptorProto, DescriptorProtoNestedType(..), DescriptorProto, DescriptorProtoExtensionRange, DescriptorProtoReservedRange, ExtensionRangeOptions, FieldDescriptorProto, OneofDescriptorProto, EnumDescriptorProto, EnumDescriptorProtoEnumReservedRange, EnumValueDescriptorProto, ServiceDescriptorProto, MethodDescriptorProto, FileOptions, MessageOptions, FieldOptions, OneofOptions, EnumOptions, EnumValueOptions, ServiceOptions, MethodOptions, UninterpretedOption, UninterpretedOptionNamePart, SourceCodeInfo, SourceCodeInfoLocation, GeneratedCodeInfo, GeneratedCodeInfoAnnotation
    , fileDescriptorSetDecoder, fileDescriptorProtoDecoder, descriptorProtoDecoder, extensionRangeOptionsDecoder, fieldDescriptorProtoDecoder, oneofDescriptorProtoDecoder, enumDescriptorProtoDecoder, enumValueDescriptorProtoDecoder, serviceDescriptorProtoDecoder, methodDescriptorProtoDecoder, fileOptionsDecoder, messageOptionsDecoder, fieldOptionsDecoder, oneofOptionsDecoder, enumOptionsDecoder, enumValueOptionsDecoder, serviceOptionsDecoder, methodOptionsDecoder, uninterpretedOptionDecoder, sourceCodeInfoDecoder, generatedCodeInfoDecoder
    , toFileDescriptorSetEncoder, toFileDescriptorProtoEncoder, toDescriptorProtoEncoder, toExtensionRangeOptionsEncoder, toFieldDescriptorProtoEncoder, toOneofDescriptorProtoEncoder, toEnumDescriptorProtoEncoder, toEnumValueDescriptorProtoEncoder, toServiceDescriptorProtoEncoder, toMethodDescriptorProtoEncoder, toFileOptionsEncoder, toMessageOptionsEncoder, toFieldOptionsEncoder, toOneofOptionsEncoder, toEnumOptionsEncoder, toEnumValueOptionsEncoder, toServiceOptionsEncoder, toMethodOptionsEncoder, toUninterpretedOptionEncoder, toSourceCodeInfoEncoder, toGeneratedCodeInfoEncoder
    )

{-| ProtoBuf module: `Internal.Google.Protobuf`

This module was generated automatically using

  - [`protoc-gen-elm`](https://www.npmjs.com/package/protoc-gen-elm) 1.0.0-beta-2
  - `protoc` 3.14.0
  - the following specification file: `google/protobuf/descriptor.proto`

To run it use [`elm-protocol-buffers`](https://package.elm-lang.org/packages/eriktim/elm-protocol-buffers/1.1.0) version 1.1.0 or higher.



# Model

@docs FieldDescriptorProtoType, FieldDescriptorProtoLabel, FileOptionsOptimizeMode, FieldOptionsCType, FieldOptionsJSType, MethodOptionsIdempotencyLevel, FileDescriptorSet, FileDescriptorProto, DescriptorProtoNestedType, DescriptorProto, DescriptorProtoExtensionRange, DescriptorProtoReservedRange, ExtensionRangeOptions, FieldDescriptorProto, OneofDescriptorProto, EnumDescriptorProto, EnumDescriptorProtoEnumReservedRange, EnumValueDescriptorProto, ServiceDescriptorProto, MethodDescriptorProto, FileOptions, MessageOptions, FieldOptions, OneofOptions, EnumOptions, EnumValueOptions, ServiceOptions, MethodOptions, UninterpretedOption, UninterpretedOptionNamePart, SourceCodeInfo, SourceCodeInfoLocation, GeneratedCodeInfo, GeneratedCodeInfoAnnotation


# Decoder

@docs fileDescriptorSetDecoder, fileDescriptorProtoDecoder, descriptorProtoDecoder, extensionRangeOptionsDecoder, fieldDescriptorProtoDecoder, oneofDescriptorProtoDecoder, enumDescriptorProtoDecoder, enumValueDescriptorProtoDecoder, serviceDescriptorProtoDecoder, methodDescriptorProtoDecoder, fileOptionsDecoder, messageOptionsDecoder, fieldOptionsDecoder, oneofOptionsDecoder, enumOptionsDecoder, enumValueOptionsDecoder, serviceOptionsDecoder, methodOptionsDecoder, uninterpretedOptionDecoder, sourceCodeInfoDecoder, generatedCodeInfoDecoder


# Encoder

@docs toFileDescriptorSetEncoder, toFileDescriptorProtoEncoder, toDescriptorProtoEncoder, toExtensionRangeOptionsEncoder, toFieldDescriptorProtoEncoder, toOneofDescriptorProtoEncoder, toEnumDescriptorProtoEncoder, toEnumValueDescriptorProtoEncoder, toServiceDescriptorProtoEncoder, toMethodDescriptorProtoEncoder, toFileOptionsEncoder, toMessageOptionsEncoder, toFieldOptionsEncoder, toOneofOptionsEncoder, toEnumOptionsEncoder, toEnumValueOptionsEncoder, toServiceOptionsEncoder, toMethodOptionsEncoder, toUninterpretedOptionEncoder, toSourceCodeInfoEncoder, toGeneratedCodeInfoEncoder

-}

import Bytes
import Http
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


{-| `FieldDescriptorProtoType` enumeration
-}
type FieldDescriptorProtoType
    = TypeDouble
    | TypeFloat
    | TypeInt64
    | TypeUint64
    | TypeInt32
    | TypeFixed64
    | TypeFixed32
    | TypeBool
    | TypeString
    | TypeGroup
    | TypeMessage
    | TypeBytes
    | TypeUint32
    | TypeEnum
    | TypeSfixed32
    | TypeSfixed64
    | TypeSint32
    | TypeSint64


{-| `FieldDescriptorProtoLabel` enumeration
-}
type FieldDescriptorProtoLabel
    = LabelOptional
    | LabelRequired
    | LabelRepeated


{-| `FileOptionsOptimizeMode` enumeration
-}
type FileOptionsOptimizeMode
    = Speed
    | CodeSize
    | LiteRuntime


{-| `FieldOptionsCType` enumeration
-}
type FieldOptionsCType
    = String
    | Cord
    | StringPiece


{-| `FieldOptionsJSType` enumeration
-}
type FieldOptionsJSType
    = JsNormal
    | JsString
    | JsNumber


{-| `MethodOptionsIdempotencyLevel` enumeration
-}
type MethodOptionsIdempotencyLevel
    = IdempotencyUnknown
    | NoSideEffects
    | Idempotent


{-| `FileDescriptorSet` message
-}
type alias FileDescriptorSet =
    { file : List FileDescriptorProto
    }


{-| `FileDescriptorProto` message
-}
type alias FileDescriptorProto =
    { name : String
    , package : String
    , dependency : List String
    , publicDependency : List Int
    , weakDependency : List Int
    , messageType : List DescriptorProto
    , enumType : List EnumDescriptorProto
    , service : List ServiceDescriptorProto
    , extension : List FieldDescriptorProto
    , options : Maybe FileOptions
    , sourceCodeInfo : Maybe SourceCodeInfo
    , syntax : String
    }


{-| DescriptorProtoNestedType
-}
type DescriptorProtoNestedType
    = DescriptorProtoNestedType (List DescriptorProto)


{-| `DescriptorProto` message
-}
type alias DescriptorProto =
    { name : String
    , field : List FieldDescriptorProto
    , extension : List FieldDescriptorProto
    , nestedType : DescriptorProtoNestedType
    , enumType : List EnumDescriptorProto
    , extensionRange : List DescriptorProtoExtensionRange
    , oneofDecl : List OneofDescriptorProto
    , options : Maybe MessageOptions
    , reservedRange : List DescriptorProtoReservedRange
    , reservedName : List String
    }


{-| `DescriptorProtoExtensionRange` message
-}
type alias DescriptorProtoExtensionRange =
    { start : Int
    , end : Int
    , options : Maybe ExtensionRangeOptions
    }


{-| `DescriptorProtoReservedRange` message
-}
type alias DescriptorProtoReservedRange =
    { start : Int
    , end : Int
    }


{-| `ExtensionRangeOptions` message
-}
type alias ExtensionRangeOptions =
    { uninterpretedOption : List UninterpretedOption
    }


{-| `FieldDescriptorProto` message
-}
type alias FieldDescriptorProto =
    { name : String
    , number : Int
    , label : FieldDescriptorProtoLabel
    , type_ : FieldDescriptorProtoType
    , typeName : String
    , extendee : String
    , defaultValue : String
    , oneofIndex : Int
    , jsonName : String
    , options : Maybe FieldOptions
    , proto3Optional : Bool
    }


{-| `OneofDescriptorProto` message
-}
type alias OneofDescriptorProto =
    { name : String
    , options : Maybe OneofOptions
    }


{-| `EnumDescriptorProto` message
-}
type alias EnumDescriptorProto =
    { name : String
    , value : List EnumValueDescriptorProto
    , options : Maybe EnumOptions
    , reservedRange : List EnumDescriptorProtoEnumReservedRange
    , reservedName : List String
    }


{-| `EnumDescriptorProtoEnumReservedRange` message
-}
type alias EnumDescriptorProtoEnumReservedRange =
    { start : Int
    , end : Int
    }


{-| `EnumValueDescriptorProto` message
-}
type alias EnumValueDescriptorProto =
    { name : String
    , number : Int
    , options : Maybe EnumValueOptions
    }


{-| `ServiceDescriptorProto` message
-}
type alias ServiceDescriptorProto =
    { name : String
    , method : List MethodDescriptorProto
    , options : Maybe ServiceOptions
    }


{-| `MethodDescriptorProto` message
-}
type alias MethodDescriptorProto =
    { name : String
    , inputType : String
    , outputType : String
    , options : Maybe MethodOptions
    , clientStreaming : Bool
    , serverStreaming : Bool
    }


{-| `FileOptions` message
-}
type alias FileOptions =
    { javaPackage : String
    , javaOuterClassname : String
    , javaMultipleFiles : Bool
    , javaGenerateEqualsAndHash : Bool
    , javaStringCheckUtf8 : Bool
    , optimizeFor : FileOptionsOptimizeMode
    , goPackage : String
    , ccGenericServices : Bool
    , javaGenericServices : Bool
    , pyGenericServices : Bool
    , phpGenericServices : Bool
    , deprecated : Bool
    , ccEnableArenas : Bool
    , objcClassPrefix : String
    , csharpNamespace : String
    , swiftPrefix : String
    , phpClassPrefix : String
    , phpNamespace : String
    , phpMetadataNamespace : String
    , rubyPackage : String
    , uninterpretedOption : List UninterpretedOption
    }


{-| `MessageOptions` message
-}
type alias MessageOptions =
    { messageSetWireFormat : Bool
    , noStandardDescriptorAccessor : Bool
    , deprecated : Bool
    , mapEntry : Bool
    , uninterpretedOption : List UninterpretedOption
    }


{-| `FieldOptions` message
-}
type alias FieldOptions =
    { ctype : FieldOptionsCType
    , packed : Bool
    , jstype : FieldOptionsJSType
    , lazy : Bool
    , deprecated : Bool
    , weak : Bool
    , uninterpretedOption : List UninterpretedOption
    }


{-| `OneofOptions` message
-}
type alias OneofOptions =
    { uninterpretedOption : List UninterpretedOption
    }


{-| `EnumOptions` message
-}
type alias EnumOptions =
    { allowAlias : Bool
    , deprecated : Bool
    , uninterpretedOption : List UninterpretedOption
    }


{-| `EnumValueOptions` message
-}
type alias EnumValueOptions =
    { deprecated : Bool
    , uninterpretedOption : List UninterpretedOption
    }


{-| `ServiceOptions` message
-}
type alias ServiceOptions =
    { deprecated : Bool
    , uninterpretedOption : List UninterpretedOption
    }


{-| `MethodOptions` message
-}
type alias MethodOptions =
    { deprecated : Bool
    , idempotencyLevel : MethodOptionsIdempotencyLevel
    , uninterpretedOption : List UninterpretedOption
    }


{-| `UninterpretedOption` message
-}
type alias UninterpretedOption =
    { name : List UninterpretedOptionNamePart
    , identifierValue : String
    , positiveIntValue : Int
    , negativeIntValue : Int
    , doubleValue : Float
    , stringValue : Bytes.Bytes
    , aggregateValue : String
    }


{-| `UninterpretedOptionNamePart` message
-}
type alias UninterpretedOptionNamePart =
    { namePart : String
    , isExtension : Bool
    }


{-| `SourceCodeInfo` message
-}
type alias SourceCodeInfo =
    { location : List SourceCodeInfoLocation
    }


{-| `SourceCodeInfoLocation` message
-}
type alias SourceCodeInfoLocation =
    { path : List Int
    , span : List Int
    , leadingComments : String
    , trailingComments : String
    , leadingDetachedComments : List String
    }


{-| `GeneratedCodeInfo` message
-}
type alias GeneratedCodeInfo =
    { annotation : List GeneratedCodeInfoAnnotation
    }


{-| `GeneratedCodeInfoAnnotation` message
-}
type alias GeneratedCodeInfoAnnotation =
    { path : List Int
    , sourceFile : String
    , begin : Int
    , end : Int
    }



-- DECODER


fieldDescriptorProtoTypeDecoder : Decode.Decoder FieldDescriptorProtoType
fieldDescriptorProtoTypeDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    1 ->
                        TypeDouble

                    2 ->
                        TypeFloat

                    3 ->
                        TypeInt64

                    4 ->
                        TypeUint64

                    5 ->
                        TypeInt32

                    6 ->
                        TypeFixed64

                    7 ->
                        TypeFixed32

                    8 ->
                        TypeBool

                    9 ->
                        TypeString

                    10 ->
                        TypeGroup

                    11 ->
                        TypeMessage

                    12 ->
                        TypeBytes

                    13 ->
                        TypeUint32

                    14 ->
                        TypeEnum

                    15 ->
                        TypeSfixed32

                    16 ->
                        TypeSfixed64

                    17 ->
                        TypeSint32

                    18 ->
                        TypeSint64

                    _ ->
                        TypeDouble
            )


fieldDescriptorProtoLabelDecoder : Decode.Decoder FieldDescriptorProtoLabel
fieldDescriptorProtoLabelDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    1 ->
                        LabelOptional

                    2 ->
                        LabelRequired

                    3 ->
                        LabelRepeated

                    _ ->
                        LabelOptional
            )


fileOptionsOptimizeModeDecoder : Decode.Decoder FileOptionsOptimizeMode
fileOptionsOptimizeModeDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    1 ->
                        Speed

                    2 ->
                        CodeSize

                    3 ->
                        LiteRuntime

                    _ ->
                        Speed
            )


fieldOptionsCTypeDecoder : Decode.Decoder FieldOptionsCType
fieldOptionsCTypeDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    0 ->
                        String

                    1 ->
                        Cord

                    2 ->
                        StringPiece

                    _ ->
                        String
            )


fieldOptionsJSTypeDecoder : Decode.Decoder FieldOptionsJSType
fieldOptionsJSTypeDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    0 ->
                        JsNormal

                    1 ->
                        JsString

                    2 ->
                        JsNumber

                    _ ->
                        JsNormal
            )


methodOptionsIdempotencyLevelDecoder : Decode.Decoder MethodOptionsIdempotencyLevel
methodOptionsIdempotencyLevelDecoder =
    Decode.int32
        |> Decode.map
            (\value ->
                case value of
                    0 ->
                        IdempotencyUnknown

                    1 ->
                        NoSideEffects

                    2 ->
                        Idempotent

                    _ ->
                        IdempotencyUnknown
            )


{-| `FileDescriptorSet` decoder
-}
fileDescriptorSetDecoder : Decode.Decoder FileDescriptorSet
fileDescriptorSetDecoder =
    Decode.message (FileDescriptorSet [])
        [ Decode.repeated 1 fileDescriptorProtoDecoder .file setFile
        ]


{-| `FileDescriptorProto` decoder
-}
fileDescriptorProtoDecoder : Decode.Decoder FileDescriptorProto
fileDescriptorProtoDecoder =
    Decode.message (FileDescriptorProto "" "" [] [] [] [] [] [] [] Nothing Nothing "")
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 2 Decode.string setPackage
        , Decode.repeated 3 Decode.string .dependency setDependency
        , Decode.repeated 10 Decode.int32 .publicDependency setPublicDependency
        , Decode.repeated 11 Decode.int32 .weakDependency setWeakDependency
        , Decode.repeated 4 descriptorProtoDecoder .messageType setMessageType
        , Decode.repeated 5 enumDescriptorProtoDecoder .enumType setEnumType
        , Decode.repeated 6 serviceDescriptorProtoDecoder .service setService
        , Decode.repeated 7 fieldDescriptorProtoDecoder .extension setExtension
        , Decode.optional 8 (Decode.map Just fileOptionsDecoder) setOptions
        , Decode.optional 9 (Decode.map Just sourceCodeInfoDecoder) setSourceCodeInfo
        , Decode.optional 12 Decode.string setSyntax
        ]


unwrapDescriptorProtoNestedType : DescriptorProtoNestedType -> List DescriptorProto
unwrapDescriptorProtoNestedType (DescriptorProtoNestedType value) =
    value


{-| `DescriptorProto` decoder
-}
descriptorProtoDecoder : Decode.Decoder DescriptorProto
descriptorProtoDecoder =
    Decode.message (DescriptorProto "" [] [] (DescriptorProtoNestedType []) [] [] [] Nothing [] [])
        [ Decode.optional 1 Decode.string setName
        , Decode.repeated 2 fieldDescriptorProtoDecoder .field setField
        , Decode.repeated 6 fieldDescriptorProtoDecoder .extension setExtension
        , Decode.repeated 3 (Decode.lazy (\_ -> descriptorProtoDecoder)) (unwrapDescriptorProtoNestedType << .nestedType) (setNestedType << DescriptorProtoNestedType)
        , Decode.repeated 4 enumDescriptorProtoDecoder .enumType setEnumType
        , Decode.repeated 5 descriptorProtoExtensionRangeDecoder .extensionRange setExtensionRange
        , Decode.repeated 8 oneofDescriptorProtoDecoder .oneofDecl setOneofDecl
        , Decode.optional 7 (Decode.map Just messageOptionsDecoder) setOptions
        , Decode.repeated 9 descriptorProtoReservedRangeDecoder .reservedRange setReservedRange
        , Decode.repeated 10 Decode.string .reservedName setReservedName
        ]


descriptorProtoExtensionRangeDecoder : Decode.Decoder DescriptorProtoExtensionRange
descriptorProtoExtensionRangeDecoder =
    Decode.message (DescriptorProtoExtensionRange 0 0 Nothing)
        [ Decode.optional 1 Decode.int32 setStart
        , Decode.optional 2 Decode.int32 setEnd
        , Decode.optional 3 (Decode.map Just extensionRangeOptionsDecoder) setOptions
        ]


descriptorProtoReservedRangeDecoder : Decode.Decoder DescriptorProtoReservedRange
descriptorProtoReservedRangeDecoder =
    Decode.message (DescriptorProtoReservedRange 0 0)
        [ Decode.optional 1 Decode.int32 setStart
        , Decode.optional 2 Decode.int32 setEnd
        ]


{-| `ExtensionRangeOptions` decoder
-}
extensionRangeOptionsDecoder : Decode.Decoder ExtensionRangeOptions
extensionRangeOptionsDecoder =
    Decode.message (ExtensionRangeOptions [])
        [ Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `FieldDescriptorProto` decoder
-}
fieldDescriptorProtoDecoder : Decode.Decoder FieldDescriptorProto
fieldDescriptorProtoDecoder =
    Decode.message (FieldDescriptorProto "" 0 LabelOptional TypeDouble "" "" "" 0 "" Nothing False)
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 3 Decode.int32 setNumber
        , Decode.optional 4 fieldDescriptorProtoLabelDecoder setLabel
        , Decode.optional 5 fieldDescriptorProtoTypeDecoder setType_
        , Decode.optional 6 Decode.string setTypeName
        , Decode.optional 2 Decode.string setExtendee
        , Decode.optional 7 Decode.string setDefaultValue
        , Decode.optional 9 Decode.int32 (setOneofIndex << (+) 1)
        , Decode.optional 10 Decode.string setJsonName
        , Decode.optional 8 (Decode.map Just fieldOptionsDecoder) setOptions
        , Decode.optional 17 Decode.bool setProto3Optional
        ]


{-| `OneofDescriptorProto` decoder
-}
oneofDescriptorProtoDecoder : Decode.Decoder OneofDescriptorProto
oneofDescriptorProtoDecoder =
    Decode.message (OneofDescriptorProto "" Nothing)
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 2 (Decode.map Just oneofOptionsDecoder) setOptions
        ]


{-| `EnumDescriptorProto` decoder
-}
enumDescriptorProtoDecoder : Decode.Decoder EnumDescriptorProto
enumDescriptorProtoDecoder =
    Decode.message (EnumDescriptorProto "" [] Nothing [] [])
        [ Decode.optional 1 Decode.string setName
        , Decode.repeated 2 enumValueDescriptorProtoDecoder .value setValue
        , Decode.optional 3 (Decode.map Just enumOptionsDecoder) setOptions
        , Decode.repeated 4 enumDescriptorProtoEnumReservedRangeDecoder .reservedRange setReservedRange
        , Decode.repeated 5 Decode.string .reservedName setReservedName
        ]


enumDescriptorProtoEnumReservedRangeDecoder : Decode.Decoder EnumDescriptorProtoEnumReservedRange
enumDescriptorProtoEnumReservedRangeDecoder =
    Decode.message (EnumDescriptorProtoEnumReservedRange 0 0)
        [ Decode.optional 1 Decode.int32 setStart
        , Decode.optional 2 Decode.int32 setEnd
        ]


{-| `EnumValueDescriptorProto` decoder
-}
enumValueDescriptorProtoDecoder : Decode.Decoder EnumValueDescriptorProto
enumValueDescriptorProtoDecoder =
    Decode.message (EnumValueDescriptorProto "" 0 Nothing)
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 2 Decode.int32 setNumber
        , Decode.optional 3 (Decode.map Just enumValueOptionsDecoder) setOptions
        ]


{-| `ServiceDescriptorProto` decoder
-}
serviceDescriptorProtoDecoder : Decode.Decoder ServiceDescriptorProto
serviceDescriptorProtoDecoder =
    Decode.message (ServiceDescriptorProto "" [] Nothing)
        [ Decode.optional 1 Decode.string setName
        , Decode.repeated 2 methodDescriptorProtoDecoder .method setMethod
        , Decode.optional 3 (Decode.map Just serviceOptionsDecoder) setOptions
        ]


{-| `MethodDescriptorProto` decoder
-}
methodDescriptorProtoDecoder : Decode.Decoder MethodDescriptorProto
methodDescriptorProtoDecoder =
    Decode.message (MethodDescriptorProto "" "" "" Nothing False False)
        [ Decode.optional 1 Decode.string setName
        , Decode.optional 2 Decode.string setInputType
        , Decode.optional 3 Decode.string setOutputType
        , Decode.optional 4 (Decode.map Just methodOptionsDecoder) setOptions
        , Decode.optional 5 Decode.bool setClientStreaming
        , Decode.optional 6 Decode.bool setServerStreaming
        ]


{-| `FileOptions` decoder
-}
fileOptionsDecoder : Decode.Decoder FileOptions
fileOptionsDecoder =
    Decode.message (FileOptions "" "" False False False Speed "" False False False False False True "" "" "" "" "" "" "" [])
        [ Decode.optional 1 Decode.string setJavaPackage
        , Decode.optional 8 Decode.string setJavaOuterClassname
        , Decode.optional 10 Decode.bool setJavaMultipleFiles
        , Decode.optional 20 Decode.bool setJavaGenerateEqualsAndHash
        , Decode.optional 27 Decode.bool setJavaStringCheckUtf8
        , Decode.optional 9 fileOptionsOptimizeModeDecoder setOptimizeFor
        , Decode.optional 11 Decode.string setGoPackage
        , Decode.optional 16 Decode.bool setCcGenericServices
        , Decode.optional 17 Decode.bool setJavaGenericServices
        , Decode.optional 18 Decode.bool setPyGenericServices
        , Decode.optional 42 Decode.bool setPhpGenericServices
        , Decode.optional 23 Decode.bool setDeprecated
        , Decode.optional 31 Decode.bool setCcEnableArenas
        , Decode.optional 36 Decode.string setObjcClassPrefix
        , Decode.optional 37 Decode.string setCsharpNamespace
        , Decode.optional 39 Decode.string setSwiftPrefix
        , Decode.optional 40 Decode.string setPhpClassPrefix
        , Decode.optional 41 Decode.string setPhpNamespace
        , Decode.optional 44 Decode.string setPhpMetadataNamespace
        , Decode.optional 45 Decode.string setRubyPackage
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `MessageOptions` decoder
-}
messageOptionsDecoder : Decode.Decoder MessageOptions
messageOptionsDecoder =
    Decode.message (MessageOptions False False False False [])
        [ Decode.optional 1 Decode.bool setMessageSetWireFormat
        , Decode.optional 2 Decode.bool setNoStandardDescriptorAccessor
        , Decode.optional 3 Decode.bool setDeprecated
        , Decode.optional 7 Decode.bool setMapEntry
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `FieldOptions` decoder
-}
fieldOptionsDecoder : Decode.Decoder FieldOptions
fieldOptionsDecoder =
    Decode.message (FieldOptions String False JsNormal False False False [])
        [ Decode.optional 1 fieldOptionsCTypeDecoder setCtype
        , Decode.optional 2 Decode.bool setPacked
        , Decode.optional 6 fieldOptionsJSTypeDecoder setJstype
        , Decode.optional 5 Decode.bool setLazy
        , Decode.optional 3 Decode.bool setDeprecated
        , Decode.optional 10 Decode.bool setWeak
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `OneofOptions` decoder
-}
oneofOptionsDecoder : Decode.Decoder OneofOptions
oneofOptionsDecoder =
    Decode.message (OneofOptions [])
        [ Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `EnumOptions` decoder
-}
enumOptionsDecoder : Decode.Decoder EnumOptions
enumOptionsDecoder =
    Decode.message (EnumOptions False False [])
        [ Decode.optional 2 Decode.bool setAllowAlias
        , Decode.optional 3 Decode.bool setDeprecated
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `EnumValueOptions` decoder
-}
enumValueOptionsDecoder : Decode.Decoder EnumValueOptions
enumValueOptionsDecoder =
    Decode.message (EnumValueOptions False [])
        [ Decode.optional 1 Decode.bool setDeprecated
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `ServiceOptions` decoder
-}
serviceOptionsDecoder : Decode.Decoder ServiceOptions
serviceOptionsDecoder =
    Decode.message (ServiceOptions False [])
        [ Decode.optional 33 Decode.bool setDeprecated
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `MethodOptions` decoder
-}
methodOptionsDecoder : Decode.Decoder MethodOptions
methodOptionsDecoder =
    Decode.message (MethodOptions False IdempotencyUnknown [])
        [ Decode.optional 33 Decode.bool setDeprecated
        , Decode.optional 34 methodOptionsIdempotencyLevelDecoder setIdempotencyLevel
        , Decode.repeated 999 uninterpretedOptionDecoder .uninterpretedOption setUninterpretedOption
        ]


{-| `UninterpretedOption` decoder
-}
uninterpretedOptionDecoder : Decode.Decoder UninterpretedOption
uninterpretedOptionDecoder =
    Decode.message (UninterpretedOption [] "" 0 0 0 (Encode.encode <| Encode.string "") "")
        [ Decode.repeated 2 uninterpretedOptionNamePartDecoder .name setName
        , Decode.optional 3 Decode.string setIdentifierValue
        , Decode.optional 4 Decode.uint32 setPositiveIntValue
        , Decode.optional 5 Decode.int32 setNegativeIntValue
        , Decode.optional 6 Decode.double setDoubleValue
        , Decode.optional 7 Decode.bytes setStringValue
        , Decode.optional 8 Decode.string setAggregateValue
        ]


uninterpretedOptionNamePartDecoder : Decode.Decoder UninterpretedOptionNamePart
uninterpretedOptionNamePartDecoder =
    Decode.message (UninterpretedOptionNamePart "" False)
        [ Decode.required 1 Decode.string setNamePart
        , Decode.required 2 Decode.bool setIsExtension
        ]


{-| `SourceCodeInfo` decoder
-}
sourceCodeInfoDecoder : Decode.Decoder SourceCodeInfo
sourceCodeInfoDecoder =
    Decode.message (SourceCodeInfo [])
        [ Decode.repeated 1 sourceCodeInfoLocationDecoder .location setLocation
        ]


sourceCodeInfoLocationDecoder : Decode.Decoder SourceCodeInfoLocation
sourceCodeInfoLocationDecoder =
    Decode.message (SourceCodeInfoLocation [] [] "" "" [])
        [ Decode.repeated 1 Decode.int32 .path setPath
        , Decode.repeated 2 Decode.int32 .span setSpan
        , Decode.optional 3 Decode.string setLeadingComments
        , Decode.optional 4 Decode.string setTrailingComments
        , Decode.repeated 6 Decode.string .leadingDetachedComments setLeadingDetachedComments
        ]


{-| `GeneratedCodeInfo` decoder
-}
generatedCodeInfoDecoder : Decode.Decoder GeneratedCodeInfo
generatedCodeInfoDecoder =
    Decode.message (GeneratedCodeInfo [])
        [ Decode.repeated 1 generatedCodeInfoAnnotationDecoder .annotation setAnnotation
        ]


generatedCodeInfoAnnotationDecoder : Decode.Decoder GeneratedCodeInfoAnnotation
generatedCodeInfoAnnotationDecoder =
    Decode.message (GeneratedCodeInfoAnnotation [] "" 0 0)
        [ Decode.repeated 1 Decode.int32 .path setPath
        , Decode.optional 2 Decode.string setSourceFile
        , Decode.optional 3 Decode.int32 setBegin
        , Decode.optional 4 Decode.int32 setEnd
        ]



-- ENCODER


toFieldDescriptorProtoTypeEncoder : FieldDescriptorProtoType -> Encode.Encoder
toFieldDescriptorProtoTypeEncoder value =
    Encode.int32 <|
        case value of
            TypeDouble ->
                1

            TypeFloat ->
                2

            TypeInt64 ->
                3

            TypeUint64 ->
                4

            TypeInt32 ->
                5

            TypeFixed64 ->
                6

            TypeFixed32 ->
                7

            TypeBool ->
                8

            TypeString ->
                9

            TypeGroup ->
                10

            TypeMessage ->
                11

            TypeBytes ->
                12

            TypeUint32 ->
                13

            TypeEnum ->
                14

            TypeSfixed32 ->
                15

            TypeSfixed64 ->
                16

            TypeSint32 ->
                17

            TypeSint64 ->
                18


toFieldDescriptorProtoLabelEncoder : FieldDescriptorProtoLabel -> Encode.Encoder
toFieldDescriptorProtoLabelEncoder value =
    Encode.int32 <|
        case value of
            LabelOptional ->
                1

            LabelRequired ->
                2

            LabelRepeated ->
                3


toFileOptionsOptimizeModeEncoder : FileOptionsOptimizeMode -> Encode.Encoder
toFileOptionsOptimizeModeEncoder value =
    Encode.int32 <|
        case value of
            Speed ->
                1

            CodeSize ->
                2

            LiteRuntime ->
                3


toFieldOptionsCTypeEncoder : FieldOptionsCType -> Encode.Encoder
toFieldOptionsCTypeEncoder value =
    Encode.int32 <|
        case value of
            String ->
                0

            Cord ->
                1

            StringPiece ->
                2


toFieldOptionsJSTypeEncoder : FieldOptionsJSType -> Encode.Encoder
toFieldOptionsJSTypeEncoder value =
    Encode.int32 <|
        case value of
            JsNormal ->
                0

            JsString ->
                1

            JsNumber ->
                2


toMethodOptionsIdempotencyLevelEncoder : MethodOptionsIdempotencyLevel -> Encode.Encoder
toMethodOptionsIdempotencyLevelEncoder value =
    Encode.int32 <|
        case value of
            IdempotencyUnknown ->
                0

            NoSideEffects ->
                1

            Idempotent ->
                2


{-| `FileDescriptorSet` encoder
-}
toFileDescriptorSetEncoder : FileDescriptorSet -> Encode.Encoder
toFileDescriptorSetEncoder model =
    Encode.message
        [ ( 1, Encode.list toFileDescriptorProtoEncoder model.file )
        ]


{-| `FileDescriptorProto` encoder
-}
toFileDescriptorProtoEncoder : FileDescriptorProto -> Encode.Encoder
toFileDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.string model.package )
        , ( 3, Encode.list Encode.string model.dependency )
        , ( 10, Encode.list Encode.int32 model.publicDependency )
        , ( 11, Encode.list Encode.int32 model.weakDependency )
        , ( 4, Encode.list toDescriptorProtoEncoder model.messageType )
        , ( 5, Encode.list toEnumDescriptorProtoEncoder model.enumType )
        , ( 6, Encode.list toServiceDescriptorProtoEncoder model.service )
        , ( 7, Encode.list toFieldDescriptorProtoEncoder model.extension )
        , ( 8, (Maybe.withDefault Encode.none << Maybe.map toFileOptionsEncoder) model.options )
        , ( 9, (Maybe.withDefault Encode.none << Maybe.map toSourceCodeInfoEncoder) model.sourceCodeInfo )
        , ( 12, Encode.string model.syntax )
        ]


{-| `DescriptorProto` encoder
-}
toDescriptorProtoEncoder : DescriptorProto -> Encode.Encoder
toDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.list toFieldDescriptorProtoEncoder model.field )
        , ( 6, Encode.list toFieldDescriptorProtoEncoder model.extension )
        , ( 3, Encode.list toDescriptorProtoEncoder (unwrapDescriptorProtoNestedType model.nestedType) )
        , ( 4, Encode.list toEnumDescriptorProtoEncoder model.enumType )
        , ( 5, Encode.list toDescriptorProtoExtensionRangeEncoder model.extensionRange )
        , ( 8, Encode.list toOneofDescriptorProtoEncoder model.oneofDecl )
        , ( 7, (Maybe.withDefault Encode.none << Maybe.map toMessageOptionsEncoder) model.options )
        , ( 9, Encode.list toDescriptorProtoReservedRangeEncoder model.reservedRange )
        , ( 10, Encode.list Encode.string model.reservedName )
        ]


toDescriptorProtoExtensionRangeEncoder : DescriptorProtoExtensionRange -> Encode.Encoder
toDescriptorProtoExtensionRangeEncoder model =
    Encode.message
        [ ( 1, Encode.int32 model.start )
        , ( 2, Encode.int32 model.end )
        , ( 3, (Maybe.withDefault Encode.none << Maybe.map toExtensionRangeOptionsEncoder) model.options )
        ]


toDescriptorProtoReservedRangeEncoder : DescriptorProtoReservedRange -> Encode.Encoder
toDescriptorProtoReservedRangeEncoder model =
    Encode.message
        [ ( 1, Encode.int32 model.start )
        , ( 2, Encode.int32 model.end )
        ]


{-| `ExtensionRangeOptions` encoder
-}
toExtensionRangeOptionsEncoder : ExtensionRangeOptions -> Encode.Encoder
toExtensionRangeOptionsEncoder model =
    Encode.message
        [ ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `FieldDescriptorProto` encoder
-}
toFieldDescriptorProtoEncoder : FieldDescriptorProto -> Encode.Encoder
toFieldDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 3, Encode.int32 model.number )
        , ( 4, toFieldDescriptorProtoLabelEncoder model.label )
        , ( 5, toFieldDescriptorProtoTypeEncoder model.type_ )
        , ( 6, Encode.string model.typeName )
        , ( 2, Encode.string model.extendee )
        , ( 7, Encode.string model.defaultValue )
        , ( 9, Encode.int32 model.oneofIndex )
        , ( 10, Encode.string model.jsonName )
        , ( 8, (Maybe.withDefault Encode.none << Maybe.map toFieldOptionsEncoder) model.options )
        , ( 17, Encode.bool model.proto3Optional )
        ]


{-| `OneofDescriptorProto` encoder
-}
toOneofDescriptorProtoEncoder : OneofDescriptorProto -> Encode.Encoder
toOneofDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, (Maybe.withDefault Encode.none << Maybe.map toOneofOptionsEncoder) model.options )
        ]


{-| `EnumDescriptorProto` encoder
-}
toEnumDescriptorProtoEncoder : EnumDescriptorProto -> Encode.Encoder
toEnumDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.list toEnumValueDescriptorProtoEncoder model.value )
        , ( 3, (Maybe.withDefault Encode.none << Maybe.map toEnumOptionsEncoder) model.options )
        , ( 4, Encode.list toEnumDescriptorProtoEnumReservedRangeEncoder model.reservedRange )
        , ( 5, Encode.list Encode.string model.reservedName )
        ]


toEnumDescriptorProtoEnumReservedRangeEncoder : EnumDescriptorProtoEnumReservedRange -> Encode.Encoder
toEnumDescriptorProtoEnumReservedRangeEncoder model =
    Encode.message
        [ ( 1, Encode.int32 model.start )
        , ( 2, Encode.int32 model.end )
        ]


{-| `EnumValueDescriptorProto` encoder
-}
toEnumValueDescriptorProtoEncoder : EnumValueDescriptorProto -> Encode.Encoder
toEnumValueDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.int32 model.number )
        , ( 3, (Maybe.withDefault Encode.none << Maybe.map toEnumValueOptionsEncoder) model.options )
        ]


{-| `ServiceDescriptorProto` encoder
-}
toServiceDescriptorProtoEncoder : ServiceDescriptorProto -> Encode.Encoder
toServiceDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.list toMethodDescriptorProtoEncoder model.method )
        , ( 3, (Maybe.withDefault Encode.none << Maybe.map toServiceOptionsEncoder) model.options )
        ]


{-| `MethodDescriptorProto` encoder
-}
toMethodDescriptorProtoEncoder : MethodDescriptorProto -> Encode.Encoder
toMethodDescriptorProtoEncoder model =
    Encode.message
        [ ( 1, Encode.string model.name )
        , ( 2, Encode.string model.inputType )
        , ( 3, Encode.string model.outputType )
        , ( 4, (Maybe.withDefault Encode.none << Maybe.map toMethodOptionsEncoder) model.options )
        , ( 5, Encode.bool model.clientStreaming )
        , ( 6, Encode.bool model.serverStreaming )
        ]


{-| `FileOptions` encoder
-}
toFileOptionsEncoder : FileOptions -> Encode.Encoder
toFileOptionsEncoder model =
    Encode.message
        [ ( 1, Encode.string model.javaPackage )
        , ( 8, Encode.string model.javaOuterClassname )
        , ( 10, Encode.bool model.javaMultipleFiles )
        , ( 20, Encode.bool model.javaGenerateEqualsAndHash )
        , ( 27, Encode.bool model.javaStringCheckUtf8 )
        , ( 9, toFileOptionsOptimizeModeEncoder model.optimizeFor )
        , ( 11, Encode.string model.goPackage )
        , ( 16, Encode.bool model.ccGenericServices )
        , ( 17, Encode.bool model.javaGenericServices )
        , ( 18, Encode.bool model.pyGenericServices )
        , ( 42, Encode.bool model.phpGenericServices )
        , ( 23, Encode.bool model.deprecated )
        , ( 31, Encode.bool model.ccEnableArenas )
        , ( 36, Encode.string model.objcClassPrefix )
        , ( 37, Encode.string model.csharpNamespace )
        , ( 39, Encode.string model.swiftPrefix )
        , ( 40, Encode.string model.phpClassPrefix )
        , ( 41, Encode.string model.phpNamespace )
        , ( 44, Encode.string model.phpMetadataNamespace )
        , ( 45, Encode.string model.rubyPackage )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `MessageOptions` encoder
-}
toMessageOptionsEncoder : MessageOptions -> Encode.Encoder
toMessageOptionsEncoder model =
    Encode.message
        [ ( 1, Encode.bool model.messageSetWireFormat )
        , ( 2, Encode.bool model.noStandardDescriptorAccessor )
        , ( 3, Encode.bool model.deprecated )
        , ( 7, Encode.bool model.mapEntry )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `FieldOptions` encoder
-}
toFieldOptionsEncoder : FieldOptions -> Encode.Encoder
toFieldOptionsEncoder model =
    Encode.message
        [ ( 1, toFieldOptionsCTypeEncoder model.ctype )
        , ( 2, Encode.bool model.packed )
        , ( 6, toFieldOptionsJSTypeEncoder model.jstype )
        , ( 5, Encode.bool model.lazy )
        , ( 3, Encode.bool model.deprecated )
        , ( 10, Encode.bool model.weak )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `OneofOptions` encoder
-}
toOneofOptionsEncoder : OneofOptions -> Encode.Encoder
toOneofOptionsEncoder model =
    Encode.message
        [ ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `EnumOptions` encoder
-}
toEnumOptionsEncoder : EnumOptions -> Encode.Encoder
toEnumOptionsEncoder model =
    Encode.message
        [ ( 2, Encode.bool model.allowAlias )
        , ( 3, Encode.bool model.deprecated )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `EnumValueOptions` encoder
-}
toEnumValueOptionsEncoder : EnumValueOptions -> Encode.Encoder
toEnumValueOptionsEncoder model =
    Encode.message
        [ ( 1, Encode.bool model.deprecated )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `ServiceOptions` encoder
-}
toServiceOptionsEncoder : ServiceOptions -> Encode.Encoder
toServiceOptionsEncoder model =
    Encode.message
        [ ( 33, Encode.bool model.deprecated )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `MethodOptions` encoder
-}
toMethodOptionsEncoder : MethodOptions -> Encode.Encoder
toMethodOptionsEncoder model =
    Encode.message
        [ ( 33, Encode.bool model.deprecated )
        , ( 34, toMethodOptionsIdempotencyLevelEncoder model.idempotencyLevel )
        , ( 999, Encode.list toUninterpretedOptionEncoder model.uninterpretedOption )
        ]


{-| `UninterpretedOption` encoder
-}
toUninterpretedOptionEncoder : UninterpretedOption -> Encode.Encoder
toUninterpretedOptionEncoder model =
    Encode.message
        [ ( 2, Encode.list toUninterpretedOptionNamePartEncoder model.name )
        , ( 3, Encode.string model.identifierValue )
        , ( 4, Encode.uint32 model.positiveIntValue )
        , ( 5, Encode.int32 model.negativeIntValue )
        , ( 6, Encode.double model.doubleValue )
        , ( 7, Encode.bytes model.stringValue )
        , ( 8, Encode.string model.aggregateValue )
        ]


toUninterpretedOptionNamePartEncoder : UninterpretedOptionNamePart -> Encode.Encoder
toUninterpretedOptionNamePartEncoder model =
    Encode.message
        [ ( 1, Encode.string model.namePart )
        , ( 2, Encode.bool model.isExtension )
        ]


{-| `SourceCodeInfo` encoder
-}
toSourceCodeInfoEncoder : SourceCodeInfo -> Encode.Encoder
toSourceCodeInfoEncoder model =
    Encode.message
        [ ( 1, Encode.list toSourceCodeInfoLocationEncoder model.location )
        ]


toSourceCodeInfoLocationEncoder : SourceCodeInfoLocation -> Encode.Encoder
toSourceCodeInfoLocationEncoder model =
    Encode.message
        [ ( 1, Encode.list Encode.int32 model.path )
        , ( 2, Encode.list Encode.int32 model.span )
        , ( 3, Encode.string model.leadingComments )
        , ( 4, Encode.string model.trailingComments )
        , ( 6, Encode.list Encode.string model.leadingDetachedComments )
        ]


{-| `GeneratedCodeInfo` encoder
-}
toGeneratedCodeInfoEncoder : GeneratedCodeInfo -> Encode.Encoder
toGeneratedCodeInfoEncoder model =
    Encode.message
        [ ( 1, Encode.list toGeneratedCodeInfoAnnotationEncoder model.annotation )
        ]


toGeneratedCodeInfoAnnotationEncoder : GeneratedCodeInfoAnnotation -> Encode.Encoder
toGeneratedCodeInfoAnnotationEncoder model =
    Encode.message
        [ ( 1, Encode.list Encode.int32 model.path )
        , ( 2, Encode.string model.sourceFile )
        , ( 3, Encode.int32 model.begin )
        , ( 4, Encode.int32 model.end )
        ]



-- SETTERS


setFile : a -> { b | file : a } -> { b | file : a }
setFile value model =
    { model | file = value }


setName : a -> { b | name : a } -> { b | name : a }
setName value model =
    { model | name = value }


setPackage : a -> { b | package : a } -> { b | package : a }
setPackage value model =
    { model | package = value }


setDependency : a -> { b | dependency : a } -> { b | dependency : a }
setDependency value model =
    { model | dependency = value }


setPublicDependency : a -> { b | publicDependency : a } -> { b | publicDependency : a }
setPublicDependency value model =
    { model | publicDependency = value }


setWeakDependency : a -> { b | weakDependency : a } -> { b | weakDependency : a }
setWeakDependency value model =
    { model | weakDependency = value }


setMessageType : a -> { b | messageType : a } -> { b | messageType : a }
setMessageType value model =
    { model | messageType = value }


setEnumType : a -> { b | enumType : a } -> { b | enumType : a }
setEnumType value model =
    { model | enumType = value }


setService : a -> { b | service : a } -> { b | service : a }
setService value model =
    { model | service = value }


setExtension : a -> { b | extension : a } -> { b | extension : a }
setExtension value model =
    { model | extension = value }


setOptions : a -> { b | options : a } -> { b | options : a }
setOptions value model =
    { model | options = value }


setSourceCodeInfo : a -> { b | sourceCodeInfo : a } -> { b | sourceCodeInfo : a }
setSourceCodeInfo value model =
    { model | sourceCodeInfo = value }


setSyntax : a -> { b | syntax : a } -> { b | syntax : a }
setSyntax value model =
    { model | syntax = value }


setField : a -> { b | field : a } -> { b | field : a }
setField value model =
    { model | field = value }


setNestedType : a -> { b | nestedType : a } -> { b | nestedType : a }
setNestedType value model =
    { model | nestedType = value }


setExtensionRange : a -> { b | extensionRange : a } -> { b | extensionRange : a }
setExtensionRange value model =
    { model | extensionRange = value }


setOneofDecl : a -> { b | oneofDecl : a } -> { b | oneofDecl : a }
setOneofDecl value model =
    { model | oneofDecl = value }


setReservedRange : a -> { b | reservedRange : a } -> { b | reservedRange : a }
setReservedRange value model =
    { model | reservedRange = value }


setReservedName : a -> { b | reservedName : a } -> { b | reservedName : a }
setReservedName value model =
    { model | reservedName = value }


setStart : a -> { b | start : a } -> { b | start : a }
setStart value model =
    { model | start = value }


setEnd : a -> { b | end : a } -> { b | end : a }
setEnd value model =
    { model | end = value }


setUninterpretedOption : a -> { b | uninterpretedOption : a } -> { b | uninterpretedOption : a }
setUninterpretedOption value model =
    { model | uninterpretedOption = value }


setNumber : a -> { b | number : a } -> { b | number : a }
setNumber value model =
    { model | number = value }


setLabel : a -> { b | label : a } -> { b | label : a }
setLabel value model =
    { model | label = value }


setType_ : a -> { b | type_ : a } -> { b | type_ : a }
setType_ value model =
    { model | type_ = value }


setTypeName : a -> { b | typeName : a } -> { b | typeName : a }
setTypeName value model =
    { model | typeName = value }


setExtendee : a -> { b | extendee : a } -> { b | extendee : a }
setExtendee value model =
    { model | extendee = value }


setDefaultValue : a -> { b | defaultValue : a } -> { b | defaultValue : a }
setDefaultValue value model =
    { model | defaultValue = value }


setOneofIndex : a -> { b | oneofIndex : a } -> { b | oneofIndex : a }
setOneofIndex value model =
    { model | oneofIndex = value }


setJsonName : a -> { b | jsonName : a } -> { b | jsonName : a }
setJsonName value model =
    { model | jsonName = value }


setProto3Optional : a -> { b | proto3Optional : a } -> { b | proto3Optional : a }
setProto3Optional value model =
    { model | proto3Optional = value }


setValue : a -> { b | value : a } -> { b | value : a }
setValue value model =
    { model | value = value }


setMethod : a -> { b | method : a } -> { b | method : a }
setMethod value model =
    { model | method = value }


setInputType : a -> { b | inputType : a } -> { b | inputType : a }
setInputType value model =
    { model | inputType = value }


setOutputType : a -> { b | outputType : a } -> { b | outputType : a }
setOutputType value model =
    { model | outputType = value }


setClientStreaming : a -> { b | clientStreaming : a } -> { b | clientStreaming : a }
setClientStreaming value model =
    { model | clientStreaming = value }


setServerStreaming : a -> { b | serverStreaming : a } -> { b | serverStreaming : a }
setServerStreaming value model =
    { model | serverStreaming = value }


setJavaPackage : a -> { b | javaPackage : a } -> { b | javaPackage : a }
setJavaPackage value model =
    { model | javaPackage = value }


setJavaOuterClassname : a -> { b | javaOuterClassname : a } -> { b | javaOuterClassname : a }
setJavaOuterClassname value model =
    { model | javaOuterClassname = value }


setJavaMultipleFiles : a -> { b | javaMultipleFiles : a } -> { b | javaMultipleFiles : a }
setJavaMultipleFiles value model =
    { model | javaMultipleFiles = value }


setJavaGenerateEqualsAndHash : a -> { b | javaGenerateEqualsAndHash : a } -> { b | javaGenerateEqualsAndHash : a }
setJavaGenerateEqualsAndHash value model =
    { model | javaGenerateEqualsAndHash = value }


setJavaStringCheckUtf8 : a -> { b | javaStringCheckUtf8 : a } -> { b | javaStringCheckUtf8 : a }
setJavaStringCheckUtf8 value model =
    { model | javaStringCheckUtf8 = value }


setOptimizeFor : a -> { b | optimizeFor : a } -> { b | optimizeFor : a }
setOptimizeFor value model =
    { model | optimizeFor = value }


setGoPackage : a -> { b | goPackage : a } -> { b | goPackage : a }
setGoPackage value model =
    { model | goPackage = value }


setCcGenericServices : a -> { b | ccGenericServices : a } -> { b | ccGenericServices : a }
setCcGenericServices value model =
    { model | ccGenericServices = value }


setJavaGenericServices : a -> { b | javaGenericServices : a } -> { b | javaGenericServices : a }
setJavaGenericServices value model =
    { model | javaGenericServices = value }


setPyGenericServices : a -> { b | pyGenericServices : a } -> { b | pyGenericServices : a }
setPyGenericServices value model =
    { model | pyGenericServices = value }


setPhpGenericServices : a -> { b | phpGenericServices : a } -> { b | phpGenericServices : a }
setPhpGenericServices value model =
    { model | phpGenericServices = value }


setDeprecated : a -> { b | deprecated : a } -> { b | deprecated : a }
setDeprecated value model =
    { model | deprecated = value }


setCcEnableArenas : a -> { b | ccEnableArenas : a } -> { b | ccEnableArenas : a }
setCcEnableArenas value model =
    { model | ccEnableArenas = value }


setObjcClassPrefix : a -> { b | objcClassPrefix : a } -> { b | objcClassPrefix : a }
setObjcClassPrefix value model =
    { model | objcClassPrefix = value }


setCsharpNamespace : a -> { b | csharpNamespace : a } -> { b | csharpNamespace : a }
setCsharpNamespace value model =
    { model | csharpNamespace = value }


setSwiftPrefix : a -> { b | swiftPrefix : a } -> { b | swiftPrefix : a }
setSwiftPrefix value model =
    { model | swiftPrefix = value }


setPhpClassPrefix : a -> { b | phpClassPrefix : a } -> { b | phpClassPrefix : a }
setPhpClassPrefix value model =
    { model | phpClassPrefix = value }


setPhpNamespace : a -> { b | phpNamespace : a } -> { b | phpNamespace : a }
setPhpNamespace value model =
    { model | phpNamespace = value }


setPhpMetadataNamespace : a -> { b | phpMetadataNamespace : a } -> { b | phpMetadataNamespace : a }
setPhpMetadataNamespace value model =
    { model | phpMetadataNamespace = value }


setRubyPackage : a -> { b | rubyPackage : a } -> { b | rubyPackage : a }
setRubyPackage value model =
    { model | rubyPackage = value }


setMessageSetWireFormat : a -> { b | messageSetWireFormat : a } -> { b | messageSetWireFormat : a }
setMessageSetWireFormat value model =
    { model | messageSetWireFormat = value }


setNoStandardDescriptorAccessor : a -> { b | noStandardDescriptorAccessor : a } -> { b | noStandardDescriptorAccessor : a }
setNoStandardDescriptorAccessor value model =
    { model | noStandardDescriptorAccessor = value }


setMapEntry : a -> { b | mapEntry : a } -> { b | mapEntry : a }
setMapEntry value model =
    { model | mapEntry = value }


setCtype : a -> { b | ctype : a } -> { b | ctype : a }
setCtype value model =
    { model | ctype = value }


setPacked : a -> { b | packed : a } -> { b | packed : a }
setPacked value model =
    { model | packed = value }


setJstype : a -> { b | jstype : a } -> { b | jstype : a }
setJstype value model =
    { model | jstype = value }


setLazy : a -> { b | lazy : a } -> { b | lazy : a }
setLazy value model =
    { model | lazy = value }


setWeak : a -> { b | weak : a } -> { b | weak : a }
setWeak value model =
    { model | weak = value }


setAllowAlias : a -> { b | allowAlias : a } -> { b | allowAlias : a }
setAllowAlias value model =
    { model | allowAlias = value }


setIdempotencyLevel : a -> { b | idempotencyLevel : a } -> { b | idempotencyLevel : a }
setIdempotencyLevel value model =
    { model | idempotencyLevel = value }


setIdentifierValue : a -> { b | identifierValue : a } -> { b | identifierValue : a }
setIdentifierValue value model =
    { model | identifierValue = value }


setPositiveIntValue : a -> { b | positiveIntValue : a } -> { b | positiveIntValue : a }
setPositiveIntValue value model =
    { model | positiveIntValue = value }


setNegativeIntValue : a -> { b | negativeIntValue : a } -> { b | negativeIntValue : a }
setNegativeIntValue value model =
    { model | negativeIntValue = value }


setDoubleValue : a -> { b | doubleValue : a } -> { b | doubleValue : a }
setDoubleValue value model =
    { model | doubleValue = value }


setStringValue : a -> { b | stringValue : a } -> { b | stringValue : a }
setStringValue value model =
    { model | stringValue = value }


setAggregateValue : a -> { b | aggregateValue : a } -> { b | aggregateValue : a }
setAggregateValue value model =
    { model | aggregateValue = value }


setNamePart : a -> { b | namePart : a } -> { b | namePart : a }
setNamePart value model =
    { model | namePart = value }


setIsExtension : a -> { b | isExtension : a } -> { b | isExtension : a }
setIsExtension value model =
    { model | isExtension = value }


setLocation : a -> { b | location : a } -> { b | location : a }
setLocation value model =
    { model | location = value }


setPath : a -> { b | path : a } -> { b | path : a }
setPath value model =
    { model | path = value }


setSpan : a -> { b | span : a } -> { b | span : a }
setSpan value model =
    { model | span = value }


setLeadingComments : a -> { b | leadingComments : a } -> { b | leadingComments : a }
setLeadingComments value model =
    { model | leadingComments = value }


setTrailingComments : a -> { b | trailingComments : a } -> { b | trailingComments : a }
setTrailingComments value model =
    { model | trailingComments = value }


setLeadingDetachedComments : a -> { b | leadingDetachedComments : a } -> { b | leadingDetachedComments : a }
setLeadingDetachedComments value model =
    { model | leadingDetachedComments = value }


setAnnotation : a -> { b | annotation : a } -> { b | annotation : a }
setAnnotation value model =
    { model | annotation = value }


setSourceFile : a -> { b | sourceFile : a } -> { b | sourceFile : a }
setSourceFile value model =
    { model | sourceFile = value }


setBegin : a -> { b | begin : a } -> { b | begin : a }
setBegin value model =
    { model | begin = value }
