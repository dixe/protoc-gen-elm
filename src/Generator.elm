module Generator exposing (generate)

import Dict
import List.Extra
import Model exposing (..)
import Set
import String.Extra


generate : Version -> Model.Package -> String
generate =
    generatePackage



-- MODEL


type alias Version =
    { plugin : String
    , compiler : String
    , library : String
    }


type alias EnumDefaults =
    Dict.Dict String String


type alias Struct =
    { exposedTypes : List String
    , exposedTypesDocs : List String
    , exposedDecoders : List String
    , exposedEncoders : List String
    , models : List String
    , decoders : List String
    , encoders : List String
    , setters : List String
    }


empty : Struct
empty =
    { exposedTypes = []
    , exposedTypesDocs = []
    , exposedDecoders = []
    , exposedEncoders = []
    , models = []
    , decoders = []
    , encoders = []
    , setters = []
    }


append : Struct -> Struct -> Struct
append a b =
    { exposedTypes = b.exposedTypes ++ a.exposedTypes
    , exposedTypesDocs = b.exposedTypesDocs ++ a.exposedTypesDocs
    , exposedDecoders = b.exposedDecoders ++ a.exposedDecoders
    , exposedEncoders = b.exposedEncoders ++ a.exposedEncoders
    , models = b.models ++ a.models
    , decoders = b.decoders ++ a.decoders
    , encoders = b.encoders ++ a.encoders
    , setters = b.setters ++ a.setters
    }


concatMap : (a -> Struct) -> List a -> Struct
concatMap fn xs =
    List.foldl (append << fn) empty xs



-- PACKAGE


generatePackage : Version -> Model.Package -> String
generatePackage version package =
    let
        enumDefaults =
            Dict.fromList <| List.map (\e -> ( e.dataType, Tuple.second <| Tuple.first e.fields )) package.enums

        struct =
            append
                (concatMap (message enumDefaults) package.messages)
                (concatMap enum package.enums)

        imports =
            package.imports
                |> Set.map (String.append "import ")
                |> Set.insert "import Protobuf.Decode as Decode"
                |> Set.insert "import Protobuf.Encode as Encode"
    in
    """
{- !!! DO NOT EDIT THIS FILE MANUALLY !!! -}


module {{ name }} exposing
    ( {{ exposedTypes }}
    , {{ exposedDecoders }}
    , {{ exposedEncoders }}
    )

{-| ProtoBuf module: `{{ name }}`

This module was generated automatically using

  - [`protoc-gen-elm`](https://www.npmjs.com/package/protoc-gen-elm) {{ pluginVersion }}
  - [`elm-protocol-buffers`](https://package.elm-lang.org/packages/eriktim/elm-protocol-buffers/{{ libraryVersion }}) {{ libraryVersion }}
  - `protoc` {{ compilerVersion }}
  - the following specification file{{ filesPlural }}:{{ files }}


# Model

@docs {{ exposedTypesDocs }}


# Decoder

@docs {{ exposedDecoders }}


# Encoder

@docs {{ exposedEncoders }}

-}

{{ imports }}



-- MODEL


{{ models }}



-- DECODER


{{ decoders }}



-- ENCODER


{{ encoders }}



-- SETTERS


{{ setters }}
"""
        |> String.trimLeft
        |> interpolate "name" package.name
        |> interpolate "pluginVersion" version.plugin
        |> interpolate "libraryVersion" version.library
        |> interpolate "compilerVersion" version.compiler
        |> interpolate "filesPlural" (filesPlural package.files)
        |> interpolate "files" (String.join "" <| List.map (\f -> "\n      - `" ++ f ++ "`") package.files)
        |> interpolate "imports" (String.join "\n" <| Set.toList imports)
        |> interpolate "exposedTypes" (String.join ", " struct.exposedTypes)
        |> interpolate "exposedTypesDocs" (String.join ", " struct.exposedTypesDocs)
        |> interpolate "exposedDecoders" (String.join ", " struct.exposedDecoders)
        |> interpolate "exposedEncoders" (String.join ", " struct.exposedEncoders)
        |> interpolate "models" (String.join "\n\n\n" struct.models)
        |> interpolate "decoders" (String.join "\n\n\n" struct.decoders)
        |> interpolate "encoders" (String.join "\n\n\n" struct.encoders)
        |> interpolate "setters" (String.join "\n\n\n" <| List.map setter (List.Extra.unique struct.setters))


filesPlural : List String -> String
filesPlural files =
    if List.length files == 1 then
        ""

    else
        "s"



-- ENUM


enum : Enum -> Struct
enum value =
    let
        decoder_ =
            decoderName value.dataType

        encoder_ =
            encoderName value.dataType

        ( default, fields ) =
            Tuple.mapBoth (Tuple.mapFirst String.fromInt) (List.map (Tuple.mapFirst String.fromInt)) value.fields

        variants =
            if value.withUnrecognized then
                Tuple.second default :: List.map Tuple.second fields ++ [ value.dataType ++ "Unrecognized_ Int" ]

            else
                Tuple.second default :: List.map Tuple.second fields

        decoderFields =
            if value.withUnrecognized then
                default :: fields ++ [ ( "v", value.dataType ++ "Unrecognized_ v" ) ]

            else
                default :: fields ++ [ ( "_", Tuple.second default ) ]

        encoderFields =
            if value.withUnrecognized then
                default :: fields ++ [ ( "v", value.dataType ++ "Unrecognized_ v" ) ]

            else
                default :: fields
    in
    { exposedTypes = [ value.dataType ++ "(..)" ]
    , exposedTypesDocs = [ value.dataType ]
    , exposedDecoders = []
    , exposedEncoders = []
    , models =
        [ "{-| "
            ++ value.dataType
            ++ "\n-}"
            ++ "\ntype "
            ++ value.dataType
            ++ "\n    = "
            ++ String.join "\n    | " variants
        ]
    , decoders =
        [ """
{{ decoder }} : Decode.Decoder {{ dataType }}
{{ decoder }} =
    Decode.int32
        |> Decode.map
            (\\value ->
                case value of
{{ fields }}
            )
            """
            |> String.trim
            |> interpolate "decoder" decoder_
            |> interpolate "dataType" value.dataType
            |> interpolate "fields"
                (String.join "\n\n" <|
                    List.map
                        (\( val, name ) ->
                            "                    {{ value }} ->\n                        {{ name }}"
                                |> interpolate "name" name
                                |> interpolate "value" val
                        )
                        decoderFields
                )
        ]
    , encoders =
        [ """
{{ encoder }} : {{ dataType }} -> Encode.Encoder
{{ encoder }} value =
    Encode.int32 <|
        case value of
{{ fields }}
            """
            |> String.trim
            |> interpolate "encoder" encoder_
            |> interpolate "dataType" value.dataType
            |> interpolate "fields"
                (String.join "\n\n" <|
                    List.map
                        (\( val, name ) ->
                            "            {{ name }} ->\n                {{ value }}"
                                |> interpolate "name" name
                                |> interpolate "value" val
                        )
                        encoderFields
                )
        ]
    , setters = []
    }



-- MESSAGE


message : EnumDefaults -> Message -> Struct
message enumDefaults value =
    let
        decoder_ =
            decoderName value.dataType

        encoder_ =
            encoderName value.dataType

        ( exposedDecoders, exposedEncoder ) =
            if value.isTopLevel then
                ( [ decoder_ ], [ encoder_ ] )

            else
                ( [], [] )
    in
    { exposedTypes = [ value.dataType ]
    , exposedTypesDocs = [ value.dataType ]
    , exposedDecoders = exposedDecoders
    , exposedEncoders = exposedEncoder
    , models =
        [ """
{-| {{ dataType }}
-}
type alias {{ dataType }} =
    { {{ fields }}
    }
    """
            |> String.trim
            |> interpolate "dataType" value.dataType
            |> interpolate "fields" (String.join "\n    , " <| List.map recordField value.fields)
        ]
    , decoders =
        [ """
{{ decoder }} : Decode.Decoder {{ dataType }}
{{ decoder }} =
    Decode.message ({{ dataType }} {{ defaults }})
        [ {{ fields }}
        ]
            """
            |> String.trim
            |> interpolate "decoder" decoder_
            |> interpolate "dataType" value.dataType
            |> interpolate "defaults" (String.join " " <| List.map (fieldDefault enumDefaults << Tuple.second) value.fields)
            |> interpolate "fields" (String.join "\n        , " <| List.map (fieldDecoder enumDefaults) value.fields)
        ]
    , encoders =
        [ """
{{ encoder }} : {{ dataType }} -> Encode.Encoder
{{ encoder }} model =
    Encode.message
        [ {{ fields }}
        ]
            """
            |> String.trim
            |> interpolate "encoder" encoder_
            |> interpolate "dataType" value.dataType
            |> interpolate "fields" (String.join "\n        , " <| List.map fieldEncoder value.fields)
        ]
    , setters = List.map Tuple.first value.fields
    }
        |> append (concatMap identity <| List.filterMap (oneOf << Tuple.second) value.fields)
        |> append (concatMap identity <| List.filterMap (recursive << Tuple.second) value.fields)


oneOf : Field -> Maybe Struct
oneOf field =
    case field of
        OneOfField dataType fields ->
            Just
                { exposedTypes = [ dataType ++ "(..)" ]
                , exposedTypesDocs = [ dataType ]
                , exposedDecoders = []
                , exposedEncoders = []
                , models =
                    [ "{-| "
                        ++ dataType
                        ++ "\n-}"
                        ++ "\ntype "
                        ++ dataType
                        ++ "\n    = "
                        ++ String.join "\n    | "
                            (List.map
                                (\( _, fieldDataType, fieldType ) ->
                                    let
                                        type_ =
                                            case fieldType of
                                                Primitive d _ _ ->
                                                    d

                                                Embedded d ->
                                                    d

                                                Enumeration _ d ->
                                                    d
                                    in
                                    fieldDataType ++ " " ++ type_
                                )
                                fields
                            )
                    ]
                , decoders = []
                , encoders =
                    [ """
{{ encoder }} : {{ dataType }} -> ( Int, Encode.Encoder )
{{ encoder }} model =
    case model of{{ fields }}
                """
                        |> String.trim
                        |> interpolate "encoder" (encoderName dataType)
                        |> interpolate "dataType" dataType
                        |> interpolate "fields"
                            (String.join "\n" <|
                                List.map
                                    (\( fieldNumber, fieldDataType, fieldType ) ->
                                        "\n        {{ dataType }} value ->\n            ( {{ fieldNumber }}, {{ fieldEncoder }} value )"
                                            |> interpolate "dataType" fieldDataType
                                            |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                                            |> interpolate "fieldEncoder" (encoder fieldType)
                                    )
                                    fields
                            )
                    ]
                , setters = []
                }

        _ ->
            Nothing


recursive : Field -> Maybe Struct
recursive field =
    case field of
        RecursiveField dataType recursiveField ->
            case recursiveField of
                Field _ cardinality fieldType ->
                    let
                        fieldDataType =
                            fieldTypeDataType cardinality fieldType
                    in
                    Just
                        { exposedTypes = [ dataType ++ "(..)" ]
                        , exposedTypesDocs = [ dataType ]
                        , exposedDecoders = []
                        , exposedEncoders = []
                        , models =
                            [ "{-| "
                                ++ dataType
                                ++ "\n-}"
                                ++ "\ntype "
                                ++ dataType
                                ++ "\n    = "
                                ++ dataType
                                ++ " ("
                                ++ fieldDataType
                                ++ ")"
                            ]
                        , decoders =
                            [ """
unwrap{{ dataType }} : {{ dataType }} -> {{ fieldDataType }}
unwrap{{ dataType }} ({{ dataType }} value) =
    value
                        """
                                |> String.trim
                                |> interpolate "dataType" dataType
                                |> interpolate "fieldDataType" fieldDataType
                            ]
                        , encoders = []
                        , setters = []
                        }

                _ ->
                    Nothing

        _ ->
            Nothing



-- FIELD


recordField : ( FieldName, Field ) -> String
recordField ( fieldName, field ) =
    let
        type_ =
            case field of
                Field _ cardinality fieldType ->
                    fieldTypeDataType cardinality fieldType

                MapField _ { key, value } ->
                    "Dict.Dict " ++ fieldTypeDataType Optional key ++ " " ++ fieldTypeDataType Optional value

                OneOfField dataType _ ->
                    "Maybe " ++ dataType

                RecursiveField dataType field_ ->
                    dataType
    in
    fieldName ++ " : " ++ type_


fieldDefault : EnumDefaults -> Field -> String
fieldDefault enumDefaults field =
    case field of
        Field _ cardinality fieldType ->
            case cardinality of
                Repeated ->
                    "[]"

                _ ->
                    fieldTypeDefault enumDefaults fieldType

        MapField _ _ ->
            "Dict.empty"

        OneOfField _ _ ->
            "Nothing"

        RecursiveField name field_ ->
            "(" ++ name ++ " " ++ fieldDefault enumDefaults field_ ++ ")"


fieldTypeDefault : EnumDefaults -> FieldType -> String
fieldTypeDefault enumDefaults fieldType =
    case fieldType of
        Primitive _ _ default ->
            default

        Embedded _ ->
            "Nothing"

        Enumeration default dataType ->
            Maybe.withDefault (Maybe.withDefault dataType <| Dict.get dataType enumDefaults) default


fieldTypeDataType : Cardinality -> FieldType -> String
fieldTypeDataType cardinality fieldType =
    let
        fieldDataType =
            case fieldType of
                Primitive dataType _ _ ->
                    dataType

                Embedded dataType ->
                    dataType

                Enumeration _ dataType ->
                    dataType
    in
    case cardinality of
        Repeated ->
            "List " ++ fieldDataType

        _ ->
            case fieldType of
                Embedded _ ->
                    "Maybe " ++ fieldDataType

                _ ->
                    fieldDataType


fieldDecoder : EnumDefaults -> ( FieldName, Field ) -> String
fieldDecoder enumDefaults ( fieldName, field ) =
    case field of
        Field fieldNumber cardinality fieldType ->
            let
                fieldDecoder_ =
                    case fieldType of
                        Embedded _ ->
                            if cardinality == Repeated then
                                decoder fieldType

                            else
                                "(Decode.map Just " ++ decoder fieldType ++ ")"

                        _ ->
                            decoder fieldType
            in
            "Decode.{{ cardinality }} {{ fieldNumber }} {{ fieldDecoder }}{{ getter }} {{ setter }}"
                |> interpolate "cardinality" (cardinalityCoder cardinality)
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "fieldDecoder" fieldDecoder_
                |> interpolate "setter" ("set" ++ String.Extra.toSentenceCase fieldName)
                |> interpolate "getter"
                    (case cardinality of
                        Repeated ->
                            " ." ++ fieldName

                        _ ->
                            ""
                    )

        MapField fieldNumber { key, value } ->
            "Decode.mapped {{ fieldNumber }} ( {{ defaultKey }}, {{ defaultValue }} ) {{ keyDecoder }} {{ valueDecoder }} {{ getter }} {{ setter }}"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "defaultKey" (fieldTypeDefault enumDefaults key)
                |> interpolate "defaultValue" (fieldTypeDefault enumDefaults value)
                |> interpolate "keyDecoder" (decoder key)
                |> interpolate "valueDecoder" (decoder value)
                |> interpolate "setter" ("set" ++ String.Extra.toSentenceCase fieldName)
                |> interpolate "getter" ("." ++ fieldName)

        OneOfField _ fields ->
            """
        Decode.oneOf
            [ {{ fields }}
            ]
            {{ setter }}
            """
                |> String.trim
                |> interpolate "fields" (String.join "\n            , " <| List.map oneOfFieldDecoder fields)
                |> interpolate "setter" ("set" ++ String.Extra.toSentenceCase fieldName)

        RecursiveField dataType field_ ->
            case field_ of
                Field fieldNumber cardinality fieldType ->
                    "Decode.{{ cardinality }} {{ fieldNumber }} (Decode.lazy (\\_ -> {{ fieldDecoder }})){{ getter }} {{ setter }}"
                        |> interpolate "cardinality" (cardinalityCoder cardinality)
                        |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                        |> interpolate "fieldDecoder" (decoder fieldType)
                        |> interpolate "setter" ("(set" ++ String.Extra.toSentenceCase fieldName ++ " << " ++ dataType ++ ")")
                        |> interpolate "getter"
                            (case cardinality of
                                Repeated ->
                                    " (unwrap" ++ dataType ++ " << ." ++ fieldName ++ ")"

                                _ ->
                                    ""
                            )

                _ ->
                    ""


oneOfFieldDecoder : ( FieldNumber, DataType, FieldType ) -> String
oneOfFieldDecoder ( fieldNumber, dataType, fieldType ) =
    "( {{ fieldNumber }}, Decode.map {{ dataType }} {{ fieldDecoder }} )"
        |> interpolate "fieldNumber" (String.fromInt fieldNumber)
        |> interpolate "dataType" dataType
        |> interpolate "fieldDecoder" (decoder fieldType)


decoder : FieldType -> String
decoder fieldType =
    case fieldType of
        Primitive _ coder _ ->
            "Decode." ++ coder

        Embedded dataType ->
            decoderName dataType

        Enumeration _ dataType ->
            decoderName dataType


fieldEncoder : ( FieldName, Field ) -> String
fieldEncoder ( fieldName, field ) =
    case field of
        Field fieldNumber cardinality fieldType ->
            let
                prefix =
                    case cardinality of
                        Repeated ->
                            "Encode.list "

                        _ ->
                            case fieldType of
                                Embedded _ ->
                                    "Maybe.withDefault Encode.none <| Maybe.map "

                                _ ->
                                    ""
            in
            "( {{ fieldNumber }}, {{ prefix }}{{ fieldEncoder }} model.{{ fieldName }} )"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "prefix" prefix
                |> interpolate "fieldEncoder" (encoder fieldType)
                |> interpolate "fieldName" fieldName

        MapField fieldNumber { key, value } ->
            "( {{ fieldNumber }}, Encode.dict {{ keyEncoder }} {{ valueEncoder }} model.{{ fieldName }} )"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "keyEncoder" (encoder key)
                |> interpolate "valueEncoder" (encoder value)
                |> interpolate "fieldName" fieldName

        OneOfField dataType fields ->
            "Maybe.withDefault ( 0, Encode.none ) <| Maybe.map {{ fieldEncoder }} model.{{ fieldName }}"
                |> interpolate "fieldEncoder" (encoderName dataType)
                |> interpolate "fieldName" fieldName

        RecursiveField dataType field_ ->
            case field_ of
                Field fieldNumber cardinality fieldType ->
                    let
                        prefix =
                            case cardinality of
                                Repeated ->
                                    "Encode.list "

                                _ ->
                                    ""
                    in
                    "( {{ fieldNumber }}, {{ prefix }}{{ fieldEncoder }} {{ getField }} )"
                        |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                        |> interpolate "prefix" prefix
                        |> interpolate "fieldEncoder" (encoder fieldType)
                        |> interpolate "getField" ("<| unwrap" ++ dataType ++ " model." ++ fieldName)

                _ ->
                    ""


encoder : FieldType -> String
encoder fieldType =
    case fieldType of
        Primitive _ coder _ ->
            "Encode." ++ coder

        Embedded dataType ->
            encoderName dataType

        Enumeration _ dataType ->
            encoderName dataType


cardinalityCoder : Cardinality -> String
cardinalityCoder cardinality =
    case cardinality of
        Optional ->
            "optional"

        Required ->
            "required"

        Repeated ->
            "repeated"



-- SETTER


setter : String -> String
setter fieldName =
    """
{{ setter }} : a -> { b | {{ fieldName }} : a } -> { b | {{ fieldName }} : a }
{{ setter }} value model =
    { model | {{ fieldName }} = value }
    """
        |> String.trim
        |> interpolate "setter" ("set" ++ String.Extra.toSentenceCase fieldName)
        |> interpolate "fieldName" fieldName



-- HELPERS


interpolate : String -> String -> String -> String
interpolate key =
    String.replace ("{{ " ++ key ++ " }}")


decoderName : String -> String
decoderName str =
    case List.Extra.unconsLast (String.split "." str) of
        Just ( x, xs ) ->
            String.join "." (xs ++ [ String.Extra.decapitalize x ++ "Decoder" ])

        Nothing ->
            ""


encoderName : String -> String
encoderName str =
    case List.Extra.unconsLast (String.split "." str) of
        Just ( x, xs ) ->
            String.join "." (xs ++ [ "to" ++ x ++ "Encoder" ])

        Nothing ->
            ""
