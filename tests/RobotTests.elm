module RobotTests exposing (suite)

import Expect
import Orientation exposing (Orientation(..))
import Robot exposing (Robot)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Robot module"
        [ describe "fromString"
            [ test "returns Nothing if the input is wrong" <|
                \_ ->
                    let
                        input =
                            "3,4,E"

                        expected =
                            Nothing
                    in
                    Expect.equal expected (Robot.fromString input)
            , test "returns Nothing if empty coordinates+orientation" <|
                \_ ->
                    let
                        input =
                            "()"

                        expected =
                            Nothing
                    in
                    Expect.equal expected (Robot.fromString input)
            , test "returns Nothing if missing the orientation" <|
                \_ ->
                    let
                        input =
                            "(2,0)"

                        expected =
                            Nothing
                    in
                    Expect.equal expected (Robot.fromString input)
            , test "returns a correct robot for a correct input" <|
                \_ ->
                    let
                        input =
                            "(1,8,N)"

                        expected =
                            Just <|
                                { position = { x = 1, y = 8 }
                                , orientation = North
                                }
                    in
                    Expect.equal expected (Robot.fromString input)
            , test "returns a correct robot for coordinates > 10" <|
                \_ ->
                    let
                        input =
                            "(19,100,W)"

                        expected =
                            Just <|
                                { position = { x = 19, y = 100 }
                                , orientation = West
                                }
                    in
                    Expect.equal expected (Robot.fromString input)
            ]
        ]
