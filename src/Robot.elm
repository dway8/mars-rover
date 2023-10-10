module Robot exposing
    ( Robot(..)
    , fromString
    , move
    , parser
    , toString
    )

import Grid exposing (Grid)
import Instruction exposing (Instruction(..))
import Orientation exposing (Orientation(..))
import Parser as P exposing ((|.), (|=))
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


parser : P.Parser Robot
parser =
    {- Some `P.spaces` are included to provide a bit of flexibility in the input.
       Example: "(3,4,N)    FFFRF" is accepted.
       If this is not desirable, we can remove the `P.spaces`
        and just check for `P.symbol " "` at the right places.
    -}
    P.succeed
        (\x y orientation instructions ->
            OnGrid
                { position = Position x y
                , orientation = orientation
                , remainingInstructions = instructions
                }
        )
        |. P.symbol "("
        |. P.spaces
        |= P.int
        |. P.spaces
        |. P.symbol ","
        |. P.spaces
        |= P.int
        |. P.symbol ","
        |. P.spaces
        |= Orientation.parser
        |. P.spaces
        |. P.symbol ")"
        |. P.spaces
        |= Instruction.sequenceParser
        |. P.oneOf [ P.symbol "\n", P.end ]


fromString : String -> Maybe Robot
fromString str =
    P.run parser str
        |> Result.toMaybe


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

                nextInstruction :: rest ->
                    let
                        ( nextPosition, nextOrientation ) =
                            executeInstruction nextInstruction ( onGridRobotData.position, onGridRobotData.orientation )
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
executeInstruction instruction ( position, orientation ) =
    case instruction of
        Forward ->
            ( moveForward orientation position, orientation )

        Left ->
            ( position, Orientation.rotateAntiClockwise orientation )

        Right ->
            ( position, Orientation.rotateClockwise orientation )


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


toString : Robot -> String
toString robot =
    case robot of
        OnGrid { position, orientation } ->
            stateToString position orientation

        OffGrid { lastKnownPosition, lastKnownOrientation } ->
            stateToString lastKnownPosition lastKnownOrientation ++ " LOST"


stateToString : Position -> Orientation -> String
stateToString position orientation =
    "(" ++ Position.toString position ++ ", " ++ Orientation.toString orientation ++ ")"
