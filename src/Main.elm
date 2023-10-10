port module Main exposing
    ( main
    , parseInput
    , transform
    )

import Grid exposing (Grid)
import Json.Decode as D
import Json.Encode as E
import Parser as P exposing ((|.), (|=))
import Platform exposing (Program)
import Robot exposing (Robot)


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
                |> Maybe.map
                    (\{ grid, robots } ->
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


type alias State =
    { grid : Grid
    , robots : List Robot
    }


parseInput : String -> Maybe State
parseInput input =
    P.run parser input
        |> Result.toMaybe


parser : P.Parser State
parser =
    P.succeed (\grid robots -> { grid = grid, robots = robots })
        |= Grid.parser
        |= P.sequence
            { start = ""
            , separator = ""
            , end = ""
            , spaces = P.succeed ()
            , item = Robot.parser
            , trailing = P.Forbidden
            }
