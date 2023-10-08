module Orientation exposing
    ( Orientation(..)
    , fromString
    )


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
