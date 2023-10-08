port module Main exposing (main)

import Platform exposing (Program)


port transformInput : (String -> msg) -> Sub msg


port sendResult : String -> Cmd msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    ()


type Msg
    = Input String


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( model, transform input |> sendResult )


subscriptions : Model -> Sub Msg
subscriptions _ =
    transformInput Input


transform : String -> String
transform input =
    input ++ "-OK"
