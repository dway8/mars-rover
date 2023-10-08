module RobotTests exposing (..)

import Expect
import Grid exposing (Grid)
import Instruction exposing (Instruction(..))
import Orientation exposing (Orientation(..))
import Position exposing (Position)
import Robot exposing (Robot(..))
import Test exposing (Test, describe, test)


initialStateFromStringTests : Test
initialStateFromStringTests =
    describe "initialStateFromStringTests"
        [ test "returns Nothing if the input is empty" <|
            \_ ->
                let
                    input =
                        ""

                    expected =
                        Nothing
                in
                Expect.equal expected (Robot.initialStateFromString input)
        , test "returns Nothing if the input is wrong" <|
            \_ ->
                let
                    input =
                        "WRONG"

                    expected =
                        Nothing
                in
                Expect.equal expected (Robot.initialStateFromString input)
        , test "returns Nothing if missing the orientation" <|
            \_ ->
                let
                    input =
                        "2, 0"

                    expected =
                        Nothing
                in
                Expect.equal expected (Robot.initialStateFromString input)
        , test "returns a correct state for a correct input" <|
            \_ ->
                let
                    input =
                        "1, 8, N"

                    expected =
                        Just ( { x = 1, y = 8 }, North )
                in
                Expect.equal expected (Robot.initialStateFromString input)
        , test "returns a correct state for a correct input with missing spaces after parentheses" <|
            \_ ->
                let
                    input =
                        "2,0,S"

                    expected =
                        Just ( { x = 2, y = 0 }, South )
                in
                Expect.equal expected (Robot.initialStateFromString input)
        , test "returns a correct state for coordinates > 10" <|
            \_ ->
                let
                    input =
                        "19, 100, W"

                    expected =
                        Just ( { x = 19, y = 100 }, West )
                in
                Expect.equal expected (Robot.initialStateFromString input)
        ]


fromStringTests : Test
fromStringTests =
    describe "fromString"
        [ test "returns Nothing if empty input" <|
            \_ ->
                let
                    input =
                        ""

                    expected =
                        Nothing
                in
                Expect.equal expected (Robot.fromString input)
        , test "returns Nothing if missing initial state" <|
            \_ ->
                let
                    input =
                        "LLFFR"

                    expected =
                        Nothing
                in
                Expect.equal expected (Robot.fromString input)
        , test "returns a correct robot if missing instructions" <|
            \_ ->
                let
                    input =
                        "(0, 4, S)"

                    expected =
                        Just <|
                            OnGrid
                                { position = Position 0 4
                                , orientation = South
                                , remainingInstructions = []
                                }
                in
                Expect.equal expected (Robot.fromString input)
        , test "returns a correct robot if correct input" <|
            \_ ->
                let
                    input =
                        "(9, 8, E) RLF"

                    expected =
                        Just <|
                            OnGrid
                                { position = Position 9 8
                                , orientation = East
                                , remainingInstructions = [ Right, Left, Forward ]
                                }
                in
                Expect.equal expected (Robot.fromString input)
        ]


moveTests : Test
moveTests =
    describe "move"
        ((test "returns the same robot if no instructions" <|
            \_ ->
                let
                    robot =
                        OnGrid
                            { position = Position 3 6
                            , orientation = South
                            , remainingInstructions = []
                            }

                    grid =
                        Grid 10 10

                    expected =
                        robot
                in
                Expect.equal expected (Robot.move grid robot)
         )
            :: ([ { input =
                        OnGrid
                            { position = Position 3 6
                            , orientation = South
                            , remainingInstructions = [ Forward ]
                            }
                  , expected =
                        OnGrid
                            { position = Position 3 5
                            , orientation = South
                            , remainingInstructions = []
                            }
                  }
                , { input =
                        OnGrid
                            { position = Position 0 0
                            , orientation = West
                            , remainingInstructions = [ Right, Forward, Forward, Right, Forward ]
                            }
                  , expected =
                        OnGrid
                            { position = Position 1 2
                            , orientation = East
                            , remainingInstructions = []
                            }
                  }
                , { input =
                        OnGrid
                            { position = Position 4 3
                            , orientation = West
                            , remainingInstructions = [ Right, Left, Right, Left ]
                            }
                  , expected =
                        OnGrid
                            { position = Position 4 3
                            , orientation = West
                            , remainingInstructions = []
                            }
                  }
                , { input =
                        OnGrid
                            { position = Position 2 6
                            , orientation = North
                            , remainingInstructions = [ Forward, Forward, Forward ]
                            }
                  , expected =
                        OnGrid
                            { position = Position 2 9
                            , orientation = North
                            , remainingInstructions = []
                            }
                  }
                ]
                    |> List.indexedMap
                        (\idx { input, expected } ->
                            test ("returns a robot with correct position & orientation for a large enough grid & various scenarios: #" ++ String.fromInt idx) <|
                                \_ ->
                                    Expect.equal expected (Robot.move (Grid 15 15) input)
                        )
               )
            ++ [ test "returns an OffGrid robot if it moves outside the grid on y" <|
                    \_ ->
                        let
                            robot =
                                OnGrid
                                    { position = Position 1 1
                                    , orientation = North
                                    , remainingInstructions = [ Forward, Forward, Left ]
                                    }

                            grid =
                                Grid 2 2

                            expected =
                                OffGrid { lastKnownPosition = Position 1 2, lastKnownOrientation = North }
                        in
                        Expect.equal expected (Robot.move grid robot)
               , test "returns an OffGrid robot if it moves outside the grid on x & y" <|
                    \_ ->
                        let
                            robot =
                                OnGrid
                                    { position = Position 0 0
                                    , orientation = North
                                    , remainingInstructions = [ Left, Forward ]
                                    }

                            grid =
                                Grid 2 2

                            expected =
                                OffGrid { lastKnownPosition = Position 0 0, lastKnownOrientation = West }
                        in
                        Expect.equal expected (Robot.move grid robot)
               , test "returns an OffGrid robot if it moves outside the grid and then comes back inside" <|
                    \_ ->
                        let
                            robot =
                                OnGrid
                                    { position = Position 2 2
                                    , orientation = East
                                    , remainingInstructions = [ Forward, Left, Left, Forward, Forward ]
                                    }

                            grid =
                                Grid 2 2

                            expected =
                                OffGrid { lastKnownPosition = Position 2 2, lastKnownOrientation = East }
                        in
                        Expect.equal expected (Robot.move grid robot)
               ]
        )
