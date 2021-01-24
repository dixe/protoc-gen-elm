module Generator exposing (generate)

import Dict exposing (Dict)
import List.Extra
import Model exposing (..)
import Set exposing (Set)
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
    Dict String String


type alias CyclicMessageMap =
    Dict String CyclicFieldMap


type alias CyclicFieldMap =
    Dict String String


type alias Struct =
    { exposedTypes : List String
    , exposedTypesDocs : List String
    , exposedDecoders : List String
    , exposedEncoders : List String
    , rpcs : List String
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
    , rpcs = []
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
    , rpcs = b.rpcs ++ a.rpcs
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

        cyclicMessageMap =
            buildCyclicMessageMap package.messages

        struct =
            append
                (concatMap (message enumDefaults cyclicMessageMap) package.messages)
            <|
                append
                    (concatMap rpc package.rpcs)
                    (concatMap enum package.enums)

        imports =
            package.imports
                |> Set.remove package.name
                |> Set.map (String.append "import ")
                |> Set.insert "import Protobuf.Decode as Decode"
                |> Set.insert "import Protobuf.Encode as Encode"
                |> Set.insert "import Http"
    in
    """

module {{ name }} exposing
    ( {{ exposedTypes }}
    , {{ exposedDecoders }}
    , {{ exposedEncoders }}
    )

{-| ProtoBuf module: `{{ name }}`

This module was generated automatically using

  - [`protoc-gen-elm`](https://www.npmjs.com/package/protoc-gen-elm) {{ pluginVersion }}
  - `protoc` {{ compilerVersion }}
  - the following specification file{{ files }}

To run it use [`elm-protocol-buffers`](https://package.elm-lang.org/packages/eriktim/elm-protocol-buffers/{{ libraryVersion }}) version {{ libraryVersion }} or higher.



# Model

@docs {{ exposedTypesDocs }}


# Decoder

@docs {{ exposedDecoders }}


# Encoder

@docs {{ exposedEncoders }}

-}

{{ imports }}


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


{{ rpcs }}


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
        |> interpolate "files" (usedFiles package.files)
        |> interpolate "imports" (String.join "\n" <| Set.toList imports)
        |> interpolate "exposedTypes" (String.join ", " struct.exposedTypes)
        |> interpolate "exposedTypesDocs" (String.join ", " struct.exposedTypesDocs)
        |> interpolate "exposedDecoders" (String.join ", " struct.exposedDecoders)
        |> interpolate "exposedEncoders" (String.join ", " struct.exposedEncoders)
        |> interpolate "models" (String.join "\n\n\n" struct.models)
        |> interpolate "decoders" (String.join "\n\n\n" struct.decoders)
        |> interpolate "encoders" (String.join "\n\n\n" struct.encoders)
        |> interpolate "setters" (String.join "\n\n\n" <| List.map setter (List.Extra.unique struct.setters))
        |> interpolate "rpcs" (String.join "\n\n\n" struct.rpcs)


usedFiles : List String -> String
usedFiles files =
    case files of
        file :: [] ->
            ": `" ++ file ++ "`"

        files_ ->
            "s:" ++ String.join "" (List.map (\file -> "\n      - `" ++ file ++ "`") files_)



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
    , rpcs = []
    , models =
        [ "{-| `"
            ++ value.dataType
            ++ "` enumeration\n-}"
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



-- RPC


rpc : Rpc -> Struct
rpc value =
    let
        rpcString =
            """
{{ name }} : String -> {{ RequestType }} -> (Result Http.Error {{ ResponseType }} -> msg) -> Cmd msg
{{ name }} url request toMsg =
    generatedBaseRequest url {{ RequestEncoder }} request  toMsg {{ ResponseDecoder }}
             """

        outType =
            removePackageName value.outputType

        inType =
            removePackageName value.inputType
    in
    { empty
        | rpcs =
            [ rpcString
                |> String.trim
                |> (interpolate "name" <| String.Extra.decapitalize value.name)
                |> (interpolate "RequestEncoder" <| encoderName inType)
                |> (interpolate "ResponseDecoder" <| decoderName outType)
                |> interpolate "RequestType" inType
                |> interpolate "ResponseType" outType
            ]
    }



-- MESSAGE


message : EnumDefaults -> CyclicMessageMap -> Message -> Struct
message enumDefaults cyclicMessageMap value =
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

        cyclicFields =
            Dict.get value.dataType cyclicMessageMap
                |> Maybe.withDefault Dict.empty
    in
    append
        (concatMap identity <| List.filterMap (oneOf << Tuple.second) value.fields)
        (concatMap identity <| List.filterMap (recursive cyclicFields) value.fields)
        |> append
            { exposedTypes = [ value.dataType ]
            , exposedTypesDocs = [ value.dataType ]
            , exposedDecoders = exposedDecoders
            , exposedEncoders = exposedEncoder
            , rpcs = []
            , models =
                [ """
{-| `{{ dataType }}` message
-}
type alias {{ dataType }} =
    {{ fields }}
    """
                    |> String.trim
                    |> interpolate "dataType" value.dataType
                    |> interpolate "fields"
                        (case value.fields of
                            [] ->
                                "{}"

                            fields ->
                                "{ " ++ (String.join "\n    , " <| List.map (recordField cyclicFields) fields) ++ "\n    }"
                        )
                ]
            , decoders =
                [ """
{{ header }}{{ decoder }} : Decode.Decoder {{ dataType }}
{{ decoder }} =
    Decode.message {{ default }}
        {{ fields }}
            """
                    |> String.trim
                    |> interpolate "header"
                        (if value.isTopLevel then
                            "{-| `" ++ value.dataType ++ "` decoder\n-}\n"

                         else
                            ""
                        )
                    |> interpolate "decoder" decoder_
                    |> interpolate "dataType" value.dataType
                    |> interpolate "default"
                        (case value.fields of
                            [] ->
                                value.dataType

                            fields ->
                                "(" ++ value.dataType ++ " " ++ (String.join " " <| List.map (fieldDefault enumDefaults cyclicFields) fields) ++ ")"
                        )
                    |> interpolate "fields"
                        (case value.fields of
                            [] ->
                                "[]"

                            fields ->
                                "[ " ++ (String.join "\n        , " <| List.map (fieldDecoder enumDefaults cyclicFields) fields) ++ "\n        ]"
                        )
                ]
            , encoders =
                [ """
{{ header }}{{ encoder }} : {{ dataType }} -> Encode.Encoder
{{ encoder }} model =
    Encode.message
        {{ fields }}
            """
                    |> String.trim
                    |> interpolate "header"
                        (if value.isTopLevel then
                            "{-| `" ++ value.dataType ++ "` encoder\n-}\n"

                         else
                            ""
                        )
                    |> interpolate "encoder" encoder_
                    |> interpolate "dataType" value.dataType
                    |> interpolate "fields"
                        (case value.fields of
                            [] ->
                                "[]"

                            fields ->
                                "[ " ++ (String.join "\n        , " <| List.map (fieldEncoder cyclicFields) fields) ++ "\n        ]"
                        )
                ]
            , setters = List.map Tuple.first value.fields
            }


oneOf : Field -> Maybe Struct
oneOf field =
    case field of
        OneOfField dataType fields ->
            Just
                { exposedTypes = [ dataType ++ "(..)" ]
                , exposedTypesDocs = [ dataType ]
                , exposedDecoders = []
                , exposedEncoders = []
                , rpcs = []
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


recursive : CyclicFieldMap -> ( String, Field ) -> Maybe Struct
recursive cyclicFieldMap ( fieldName, field ) =
    case Dict.get fieldName cyclicFieldMap of
        Just dataType ->
            let
                fieldDataType =
                    case field of
                        Field _ cardinality fieldType ->
                            fieldTypeDataType cardinality fieldType

                        MapField _ { value } ->
                            "Dict.Dict String (" ++ fieldTypeDataType Optional value ++ ")"

                        OneOfField oneOfType _ ->
                            "Maybe " ++ oneOfType
            in
            Just
                { exposedTypes = [ dataType ++ "(..)" ]
                , exposedTypesDocs = [ dataType ]
                , exposedDecoders = []
                , exposedEncoders = []
                , rpcs = []
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



-- FIELD


recordField : CyclicFieldMap -> ( FieldName, Field ) -> String
recordField cyclicFieldMap ( fieldName, field ) =
    let
        dataType =
            case Dict.get fieldName cyclicFieldMap of
                Just dataType_ ->
                    dataType_

                Nothing ->
                    case field of
                        Field _ cardinality fieldType ->
                            fieldTypeDataType cardinality fieldType

                        MapField _ { key, value } ->
                            let
                                valueDataType_ =
                                    fieldTypeDataType Optional value

                                valueDataType =
                                    case value of
                                        Embedded _ ->
                                            "(" ++ valueDataType_ ++ ")"

                                        _ ->
                                            valueDataType_
                            in
                            "Dict.Dict " ++ fieldTypeDataType Optional key ++ " " ++ valueDataType

                        OneOfField dataType_ _ ->
                            "Maybe " ++ dataType_
    in
    fieldName ++ " : " ++ dataType


fieldDefault : EnumDefaults -> CyclicFieldMap -> ( String, Field ) -> String
fieldDefault enumDefaults cyclicFieldMap ( fieldName, field ) =
    let
        fieldDefault_ =
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
    in
    case Dict.get fieldName cyclicFieldMap of
        Just dataType ->
            "(" ++ dataType ++ " " ++ fieldDefault_ ++ ")"

        Nothing ->
            fieldDefault_


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


fieldDecoder : EnumDefaults -> CyclicFieldMap -> ( FieldName, Field ) -> String
fieldDecoder enumDefaults cyclicFieldMap ( fieldName, field ) =
    let
        lazy =
            case Dict.get fieldName cyclicFieldMap of
                Just _ ->
                    True

                Nothing ->
                    False

        toDecoder name =
            if lazy then
                "(Decode.lazy (\\_ -> " ++ name ++ "))"

            else
                name

        fieldDecoder_ cardinality fieldType =
            case fieldType of
                Embedded _ ->
                    if cardinality == Repeated then
                        toDecoder <| decoder fieldType

                    else
                        toDecoder <| "(Decode.map Just " ++ decoder fieldType ++ ")"

                _ ->
                    toDecoder <| decoder fieldType

        setter_ =
            case Dict.get fieldName cyclicFieldMap of
                Just dataType ->
                    "(set" ++ String.Extra.toSentenceCase fieldName ++ " << " ++ dataType ++ ")"

                Nothing ->
                    "set" ++ String.Extra.toSentenceCase fieldName

        getter cardinality =
            case cardinality of
                Repeated ->
                    case Dict.get fieldName cyclicFieldMap of
                        Just dataType ->
                            " (unwrap" ++ dataType ++ " << ." ++ fieldName ++ ")"

                        Nothing ->
                            " ." ++ fieldName

                _ ->
                    ""
    in
    case field of
        Field fieldNumber cardinality fieldType ->
            "Decode.{{ cardinality }} {{ fieldNumber }} {{ fieldDecoder }}{{ getter }} {{ setter }}"
                |> interpolate "cardinality" (cardinalityCoder cardinality)
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "fieldDecoder" (fieldDecoder_ cardinality fieldType)
                |> interpolate "setter" setter_
                |> interpolate "getter" (getter cardinality)

        MapField fieldNumber { key, value } ->
            "Decode.mapped {{ fieldNumber }} ( {{ defaultKey }}, {{ defaultValue }} ) {{ keyDecoder }} {{ valueDecoder }}{{ getter }} {{ setter }}"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "defaultKey" (fieldTypeDefault enumDefaults key)
                |> interpolate "defaultValue" (fieldTypeDefault enumDefaults value)
                |> interpolate "keyDecoder" (decoder key)
                |> interpolate "valueDecoder" (fieldDecoder_ Optional value)
                |> interpolate "setter" setter_
                |> interpolate "getter" (getter Repeated)

        OneOfField _ fields ->
            """
        Decode.oneOf
            [ {{ fields }}
            ]
            {{ setter }}
            """
                |> String.trim
                |> interpolate "fields" (String.join "\n            , " <| List.map (oneOfFieldDecoder lazy) fields)
                |> interpolate "setter" setter_


oneOfFieldDecoder : Bool -> ( FieldNumber, DataType, FieldType ) -> String
oneOfFieldDecoder lazy ( fieldNumber, dataType, fieldType ) =
    let
        decoderTemplate =
            if lazy then
                "Decode.lazy (\\_ -> Decode.map {{ dataType }} {{ fieldDecoder }})"

            else
                "Decode.map {{ dataType }} {{ fieldDecoder }}"
    in
    "( {{ fieldNumber }}, {{ decoderTemplate }} )"
        |> interpolate "decoderTemplate" decoderTemplate
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


fieldEncoder : CyclicFieldMap -> ( FieldName, Field ) -> String
fieldEncoder cyclicFieldMap ( fieldName, field ) =
    let
        getter_ =
            case Dict.get fieldName cyclicFieldMap of
                Just dataType ->
                    "(unwrap" ++ dataType ++ " model." ++ fieldName ++ ")"

                Nothing ->
                    "model." ++ fieldName

        fieldEncoder_ cardinality fieldType =
            case cardinality of
                Repeated ->
                    "Encode.list " ++ encoder fieldType

                _ ->
                    case fieldType of
                        Embedded _ ->
                            "(Maybe.withDefault Encode.none << Maybe.map " ++ encoder fieldType ++ ")"

                        _ ->
                            encoder fieldType
    in
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
            "( {{ fieldNumber }}, {{ fieldEncoder }} {{ getter }} )"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "fieldEncoder" (fieldEncoder_ cardinality fieldType)
                |> interpolate "getter" getter_

        MapField fieldNumber { key, value } ->
            "( {{ fieldNumber }}, Encode.dict {{ keyEncoder }} {{ valueEncoder }} {{ getter }} )"
                |> interpolate "fieldNumber" (String.fromInt fieldNumber)
                |> interpolate "keyEncoder" (encoder key)
                |> interpolate "valueEncoder" (fieldEncoder_ Optional value)
                |> interpolate "getter" getter_

        OneOfField dataType fields ->
            "Maybe.withDefault ( 0, Encode.none ) <| Maybe.map {{ fieldEncoder }} {{ getter }}"
                |> interpolate "fieldEncoder" (encoderName dataType)
                |> interpolate "getter" getter_


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



-- RECURSION


buildCyclicMessageMap : List Message -> CyclicMessageMap
buildCyclicMessageMap messages =
    let
        graph =
            buildDependencyGraph messages

        types =
            Dict.keys graph
    in
    types
        |> List.map (\type_ -> ( type_, findCyclicFields type_ graph ))
        |> Dict.fromList
        |> foldCyclicMessageMap graph


buildDependencyGraph : List Message -> Dict String (List ( String, String ))
buildDependencyGraph =
    Dict.fromList << List.map messageDependencies


messageDependencies : Message -> ( String, List ( String, String ) )
messageDependencies msg =
    ( msg.dataType, List.concatMap messageFieldDependencies msg.fields )


messageFieldDependencies : ( String, Field ) -> List ( String, String )
messageFieldDependencies ( fieldName, field ) =
    let
        fieldType_ fieldType =
            case fieldType of
                Primitive _ _ _ ->
                    Nothing

                Embedded dataType ->
                    Just ( fieldName, dataType )

                Enumeration _ _ ->
                    Nothing
    in
    case field of
        Field _ _ fieldType ->
            Maybe.withDefault [] <| Maybe.map List.singleton (fieldType_ fieldType)

        MapField _ { value } ->
            Maybe.withDefault [] <| Maybe.map List.singleton (fieldType_ value)

        OneOfField _ fields ->
            List.filterMap (\( _, _, fieldType ) -> fieldType_ fieldType) fields


findCyclicFields : String -> Dict String (List ( String, String )) -> List String
findCyclicFields root graph =
    let
        fields =
            Dict.get root graph
                |> Maybe.withDefault []

        graph_ =
            Dict.map (always <| List.map Tuple.second) graph
    in
    List.filterMap
        (\( fieldName, field ) ->
            if findCyclicFieldsHelp root Set.empty [ field ] graph_ then
                Just fieldName

            else
                Nothing
        )
        fields


findCyclicFieldsHelp : String -> Set String -> List String -> Dict String (List String) -> Bool
findCyclicFieldsHelp root visited unvisited graph =
    case unvisited of
        [] ->
            Set.member root visited

        next :: rest ->
            if Set.member next visited then
                findCyclicFieldsHelp root visited rest graph

            else
                let
                    newVisited =
                        Set.insert next visited

                    nextDeps =
                        Maybe.withDefault [] (Dict.get next graph)

                    newUnvisited =
                        nextDeps ++ rest
                in
                findCyclicFieldsHelp root newVisited newUnvisited graph


foldCyclicMessageMap : Dict String (List ( String, String )) -> Dict String (List String) -> CyclicMessageMap
foldCyclicMessageMap graph dict =
    let
        types =
            Dict.toList dict
                |> List.sortBy (List.length << Tuple.second)
                |> List.map Tuple.first
    in
    List.foldr
        (\dataType fold ->
            let
                fieldNames =
                    Maybe.withDefault [] <| Dict.get dataType fold

                dependencies =
                    List.concatMap
                        (\fieldName ->
                            Dict.get dataType graph
                                |> Maybe.map (List.filter ((==) fieldName << Tuple.first))
                                |> Maybe.map (List.map Tuple.second)
                                |> Maybe.withDefault []
                        )
                        fieldNames
                        |> Set.fromList

                backDependencies type_ =
                    Dict.get type_ graph
                        |> Maybe.map (List.filter ((==) dataType << Tuple.second))
                        |> Maybe.map (List.map Tuple.first)
                        |> Maybe.withDefault []
                        |> Set.fromList
            in
            Dict.map
                (\type_ cyclicFields ->
                    if Set.member type_ dependencies then
                        List.filter (\f -> Set.member f (backDependencies type_)) cyclicFields

                    else
                        cyclicFields
                )
                fold
        )
        dict
        types
        |> Dict.map
            (\type_ names ->
                names
                    |> List.map (\name -> ( name, String.Extra.classify <| type_ ++ "_" ++ name ))
                    |> Dict.fromList
            )



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


removePackageName : String -> String
removePackageName str =
    case List.Extra.unconsLast (String.split "." str) of
        Just ( x, xs ) ->
            x

        Nothing ->
            ""
