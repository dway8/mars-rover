module GridTests exposing (..)

import Expect
import Grid exposing (Grid)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Grid module"
        [ describe "isPositionInside"
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
        ]
