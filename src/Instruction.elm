module Instruction exposing
    ( Instruction(..)
    , sequenceParser
    )

import Maybe.Extra
import Parser as P exposing ((|.))


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


sequenceParser : P.Parser (List Instruction)
sequenceParser =
    P.succeed ()
        |. P.chompUntilEndOr "\n"
        |> P.getChompedString
        |> P.andThen
            (\str ->
                str
                    |> String.toList
                    |> List.map fromChar
                    |> Maybe.Extra.combine
                    |> (\res ->
                            case res of
                                Just instructions ->
                                    P.succeed instructions

                                Nothing ->
                                    P.problem "Wrong instruction"
                       )
            )
