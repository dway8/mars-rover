port module Main exposing
    ( main
    , parseInput
    )

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
    -- TODO
    input ++ "-OK"


parseInput : String -> Maybe { gridInput : String, robotsInput : List String }
parseInput input =
    let
        nonEmptyLines =
            String.lines input
                |> List.filter (String.isEmpty >> not)
    in
    case nonEmptyLines of
        gridInput :: firstRobotInput :: restRobotInput ->
            -- destructure in 2 terms + rest to ensure there is at least one robot input (`restRobotInput` can be empty)
            Just
                { gridInput = gridInput
                , robotsInput = firstRobotInput :: restRobotInput
                }

        _ ->
            -- there is not at least a grid input & one robot input => fail
            Nothing
