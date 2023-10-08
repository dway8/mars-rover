module Robot exposing
    ( Robot
    , fromString
    , initialStateFromString
    )

import Instruction exposing (Instruction)
import Orientation exposing (Orientation)
import Position exposing (Position)


type alias Robot =
    { position : Position
    , orientation : Orientation
    , remainingInstructions : List Instruction
    }


fromString : String -> Maybe Robot
fromString str =
    case String.split ")" str of
        positionAndOrientationStr :: instructionsStr :: [] ->
            if not (String.startsWith "(" str) then
                Nothing

            else
                Maybe.map2
                    (\( position, orientation ) instructions ->
                        { position = position
                        , orientation = orientation
                        , remainingInstructions = instructions
                        }
                    )
                    (positionAndOrientationStr
                        -- drop first parenthesis
                        |> String.dropLeft 1
                        |> initialStateFromString
                    )
                    (Instruction.sequenceFromString instructionsStr)

        _ ->
            Nothing


initialStateFromString : String -> Maybe ( Position, Orientation )
initialStateFromString str =
    str
        |> String.split ","
        |> List.map String.trim
        |> (\input ->
                case input of
                    xStr :: yStr :: orientationStr :: [] ->
                        case
                            ( String.toInt xStr
                            , String.toInt yStr
                            , Orientation.fromString orientationStr
                            )
                        of
                            ( Just x, Just y, Just orientation ) ->
                                Just ( Position x y, orientation )

                            _ ->
                                Nothing

                    _ ->
                        Nothing
           )
