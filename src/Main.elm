port module Main exposing
    ( main
    , parseInput
    , transform
    )

import Grid
import Json.Decode as D
import Json.Encode as E
import Platform exposing (Program)
import Robot


port transformInput : (E.Value -> msg) -> Sub msg


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
    = Input E.Value


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


transform : E.Value -> String
transform jsonInput =
    case D.decodeValue D.string jsonInput of
        Ok inputStr ->
            parseInput inputStr
                |> Maybe.andThen
                    (\{ gridInput, robotsInput } ->
                        case ( Grid.fromString gridInput, Robot.listFromString robotsInput ) of
                            ( Just grid, Just robots ) ->
                                Just ( grid, robots )

                            _ ->
                                Nothing
                    )
                |> Maybe.map
                    (\( grid, robots ) ->
                        robots
                            |> List.map (Robot.move grid)
                            |> List.map Robot.toString
                            |> String.join "\n"
                    )
                |> Maybe.withDefault errorResult

        Err _ ->
            errorResult


errorResult : String
errorResult =
    "ERROR"


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
