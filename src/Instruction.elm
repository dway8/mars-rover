module Instruction exposing
    ( Instruction(..)
    , sequenceFromString
    )

import Maybe.Extra


type Instruction
    = Forward
    | Left
    | Right


fromChar : Char -> Maybe Instruction
fromChar str =
    case str of
        'F' ->
            Just Forward

        'L' ->
            Just Left

        'R' ->
            Just Right

        _ ->
            Nothing


sequenceFromString : String -> Maybe (List Instruction)
sequenceFromString str =
    str
        |> String.trim
        |> String.toList
        |> List.map fromChar
        |> Maybe.Extra.combine
