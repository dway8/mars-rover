module Orientation exposing
    ( Orientation(..)
    , fromString
    , rotateAntiClockwise
    , rotateClockwise
    , toString
    )

import List.Extra


type Orientation
    = North
    | East
    | South
    | West


fromString : String -> Maybe Orientation
fromString str =
    case str of
        "N" ->
            Just North

        "E" ->
            Just East

        "S" ->
            Just South

        "W" ->
            Just West

        _ ->
            Nothing


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
