module RobotTests exposing (suite)

import Expect
import Instruction exposing (Instruction(..))
import Orientation exposing (Orientation(..))
import Position exposing (Position)
import Robot exposing (Robot)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Robot module"
        [ describe "initialStateFromString"
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
        , describe "fromString"
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
                            Just
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
                            Just
                                { position = Position 9 8
                                , orientation = East
                                , remainingInstructions = [ Right, Left, Forward ]
                                }
                    in
                    Expect.equal expected (Robot.fromString input)
            ]
        ]
