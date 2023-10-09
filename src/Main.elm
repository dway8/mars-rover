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


port sendResult : String -> Cmd msg


main : Program Flags Model msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    ()


type alias Flags =
    { input : E.Value }


init : Flags -> ( Model, Cmd msg )
init flags =
    ( (), transform flags.input |> sendResult )


update : msg -> Model -> ( Model, Cmd msg )
update _ model =
    ( model, Cmd.none )


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
