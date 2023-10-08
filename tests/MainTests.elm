module MainTests exposing (..)

import Expect
import Main
import Test exposing (Test, describe, test)


parseInputTests : Test
parseInputTests =
    describe "parseInput"
        [ test "returns Nothing if the input is empty" <|
            \_ ->
                let
                    input =
                        ""

                    expected =
                        Nothing
                in
                Expect.equal expected (Main.parseInput input)
        , test "returns Nothing if the input only contains a grid" <|
            \_ ->
                let
                    input =
                        "4 6"

                    expected =
                        Nothing
                in
                Expect.equal expected (Main.parseInput input)
        , test "returns Nothing if the input only contains a robot" <|
            \_ ->
                let
                    input =
                        "(1, 0, W) FFLR"

                    expected =
                        Nothing
                in
                Expect.equal expected (Main.parseInput input)
        , test "returns grid & robots input correctly if there is a grid & 1 robot" <|
            \_ ->
                let
                    input =
                        "4 5\n(6, 6, N) LFFFRFFFF"

                    expected =
                        Just { gridInput = "4 5", robotsInput = [ "(6, 6, N) LFFFRFFFF" ] }
                in
                Expect.equal expected (Main.parseInput input)
        , test "returns grid & robots input correctly if there is a grid & 2 robots" <|
            \_ ->
                let
                    input =
                        "400 300\n(16, 6, N) LFFFRFFFF\n(0, 2, S) L"

                    expected =
                        Just { gridInput = "400 300", robotsInput = [ "(16, 6, N) LFFFRFFFF", "(0, 2, S) L" ] }
                in
                Expect.equal expected (Main.parseInput input)
        , test "does not fail if there is a new line at the end of the last robot" <|
            \_ ->
                let
                    input =
                        "400 300\n(16, 6, N) LFFFRFFFF\n(0, 2, S) L\n"

                    expected =
                        Just { gridInput = "400 300", robotsInput = [ "(16, 6, N) LFFFRFFFF", "(0, 2, S) L" ] }
                in
                Expect.equal expected (Main.parseInput input)
        ]


transformTests : Test
transformTests =
    describe "transform"
        [ test "returns \"ERROR\" if the input is wrong" <|
            \_ ->
                let
                    input =
                        "WRONG"

                    expected =
                        "ERROR"
                in
                Expect.equal expected (Main.transform input)
        , test "returns the robots new positions if the input is correct #1" <|
            \_ ->
                let
                    input =
                        "4 8\n(2, 3, E) LFRFF\n(0, 2, N) FFLFRFF"

                    expected =
                        "(4, 4, E)\n(0, 4, W) LOST"
                in
                Expect.equal expected (Main.transform input)
        , test "returns the robots new positions if the input is correct #2" <|
            \_ ->
                let
                    input =
                        "4 8\n(2, 3, N) FLLFR\n(1, 0, S) FFRLF"

                    expected =
                        "(2, 3, W)\n(1, 0, S) LOST"
                in
                Expect.equal expected (Main.transform input)
        ]
