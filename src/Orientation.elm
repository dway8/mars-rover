module Orientation exposing
    ( Orientation(..)
    , parser
    , rotateAntiClockwise
    , rotateClockwise
    , toString
    )

import Parser as P exposing ((|.))


type Orientation
    = North
    | East
    | South
    | West


parser : P.Parser Orientation
parser =
    P.oneOf
        [ P.succeed North |. P.symbol "N"
        , P.succeed East |. P.symbol "E"
        , P.succeed South |. P.symbol "S"
        , P.succeed West |. P.symbol "W"
        ]


rotateClockwise : Orientation -> Orientation
rotateClockwise orientation =
    case orientation of
        North ->
            East

        East ->
            South

        South ->
            West

        West ->
            North


rotateAntiClockwise : Orientation -> Orientation
rotateAntiClockwise orientation =
    case orientation of
        North ->
            West

        East ->
            North

        South ->
            East

        West ->
            South


toString : Orientation -> String
toString orientation =
    case orientation of
        North ->
            "N"

        East ->
            "E"

        South ->
            "S"

        West ->
            "W"
