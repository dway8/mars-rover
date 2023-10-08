module Orientation exposing
    ( Orientation(..)
    , fromString
    , rotateLeft
    , rotateRight
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


orientationsClockwise : List Orientation
orientationsClockwise =
    [ North, East, South, West ]


rotateLeft : Orientation -> Orientation
rotateLeft =
    rotateBy { clockwise = False }


rotateRight : Orientation -> Orientation
rotateRight =
    rotateBy { clockwise = True }


rotateBy : { clockwise : Bool } -> Orientation -> Orientation
rotateBy { clockwise } orientation =
    List.Extra.elemIndex orientation orientationsClockwise
        |> Maybe.andThen
            (\idx ->
                List.Extra.getAt
                    (modBy 4
                        (idx
                            + (if clockwise then
                                1

                               else
                                -1
                              )
                        )
                    )
                    orientationsClockwise
            )
        |> Maybe.withDefault orientation
