module GridTests exposing (..)

import Expect
import Grid exposing (Grid)
import Parser as P
import Test exposing (Test, describe, test)


fromStringTests : Test
fromStringTests =
    describe "fromString"
        [ test "returns Nothing if the input is empty" <|
            \_ ->
                let
                    input =
                        ""
                in
                Expect.err (P.run Grid.parser input)
        , test "returns Nothing if the input is wrong" <|
            \_ ->
                let
                    input =
                        "4 r\n"
                in
                Expect.err (P.run Grid.parser input)
        , test "returns Nothing if there is no space between columns and rows" <|
            \_ ->
                let
                    input =
                        "29\n"
                in
                Expect.err (P.run Grid.parser input)
        , test "returns Nothing if the input is padded with spaces" <|
            \_ ->
                let
                    input =
                        " 2 9  \n"
                in
                Expect.err (P.run Grid.parser input)
        , test "returns Nothing if there is more than 1 space between columns and rows" <|
            \_ ->
                let
                    input =
                        "2  9\n"
                in
                Expect.err (P.run Grid.parser input)
        , test "returns Nothing if the input contains more than 2 numbers" <|
            \_ ->
                let
                    input =
                        "5 5 6\n"
                in
                Expect.err (P.run Grid.parser input)
        , test "returns a correct grid for a correct input" <|
            \_ ->
                let
                    input =
                        "8 3\n"

                    expected =
                        Ok { columns = 8, rows = 3 }
                in
                Expect.equal expected (P.run Grid.parser input)
        , test "returns a correct grid for # of rows/columns > 10" <|
            \_ ->
                let
                    input =
                        "100 20\n"

                    expected =
                        Ok { columns = 100, rows = 20 }
                in
                Expect.equal expected (P.run Grid.parser input)
        ]


isPositionInsideTests : Test
isPositionInsideTests =
    describe "isPositionInside"
        [ test "returns False for an 0x0 grid" <|
            \_ ->
                let
                    grid =
                        Grid 0 0

                    position =
                        { x = 2, y = 4 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal False
        , test "returns True for a position in the bottom-left corner" <|
            \_ ->
                let
                    grid =
                        Grid 3 4

                    position =
                        { x = 0, y = 0 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal True
        , test "returns True for a position in the top-right corner" <|
            \_ ->
                let
                    grid =
                        Grid 10 15

                    position =
                        { x = 15, y = 10 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal True
        , test "returns False for a negative position" <|
            \_ ->
                let
                    grid =
                        Grid 10 15

                    position =
                        { x = -15, y = 10 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal False
        , test "returns False for a position with x ok but y too big" <|
            \_ ->
                let
                    grid =
                        Grid 5 7

                    position =
                        { x = 3, y = 6 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal False
        , test "returns True for a position inside the grid" <|
            \_ ->
                let
                    grid =
                        Grid 5 7

                    position =
                        { x = 3, y = 2 }
                in
                Grid.isPositionInside grid position
                    |> Expect.equal True
        ]
