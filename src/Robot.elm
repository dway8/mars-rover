module Robot exposing
    ( Robot(..)
    , fromString
    , initialStateFromString
    , move
    )

import Grid exposing (Grid)
import Instruction exposing (Instruction(..))
import Orientation exposing (Orientation(..))
import Position exposing (Position)


type Robot
    = OnGrid
        { position : Position
        , orientation : Orientation
        , remainingInstructions : List Instruction
        }
    | OffGrid
        { lastKnownPosition : Position
        , lastKnownOrientation : Orientation
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
                        OnGrid
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


move : Grid -> Robot -> Robot
move grid robot =
    case robot of
        OffGrid _ ->
            robot

        OnGrid onGridRobotData ->
            case onGridRobotData.remainingInstructions of
                [] ->
                    -- robot has finished moving
                    robot

                nextMovement :: rest ->
                    let
                        ( nextPosition, nextOrientation ) =
                            executeInstruction nextMovement ( onGridRobotData.position, onGridRobotData.orientation )
                    in
                    if Grid.isPositionInside grid nextPosition then
                        OnGrid
                            { position = nextPosition
                            , orientation = nextOrientation
                            , remainingInstructions = rest
                            }
                            |> move grid

                    else
                        OffGrid
                            { lastKnownPosition = onGridRobotData.position
                            , lastKnownOrientation = onGridRobotData.orientation
                            }


executeInstruction : Instruction -> ( Position, Orientation ) -> ( Position, Orientation )
executeInstruction movement ( position, orientation ) =
    case movement of
        Forward ->
            ( moveForward orientation position, orientation )

        Left ->
            ( position, Orientation.rotateLeft orientation )

        Right ->
            ( position, Orientation.rotateRight orientation )


moveForward : Orientation -> Position -> Position
moveForward orientation position =
    case orientation of
        North ->
            { position | y = position.y + 1 }

        East ->
            { position | x = position.x + 1 }

        South ->
            { position | y = position.y - 1 }

        West ->
            { position | x = position.x - 1 }
