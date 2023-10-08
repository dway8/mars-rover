module InstructionTests exposing (..)

import Expect
import Instruction exposing (Instruction(..))
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Instruction module"
        [ describe "sequenceFromString"
            [ test "returns an empty list if the input is empty" <|
                \_ ->
                    let
                        input =
                            ""

                        expected =
                            Just []
                    in
                    Expect.equal expected (Instruction.sequenceFromString input)
            , test "returns Nothing if the input is wrong" <|
                \_ ->
                    let
                        input =
                            "/FDFD"

                        expected =
                            Nothing
                    in
                    Expect.equal expected (Instruction.sequenceFromString input)
            , test "returns the right sequence of movements in the right order" <|
                \_ ->
                    let
                        input =
                            "FFLFRFF"

                        expected =
                            Just [ Forward, Forward, Left, Forward, Right, Forward, Forward ]
                    in
                    Expect.equal expected (Instruction.sequenceFromString input)
            ]
        ]
