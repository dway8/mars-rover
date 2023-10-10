module InstructionTests exposing (..)

import Expect
import Instruction exposing (Instruction(..))
import Parser as P
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Instruction module"
        [ describe "sequenceParser"
            [ test "returns an empty list if the input is empty" <|
                \_ ->
                    let
                        input =
                            ""

                        expected =
                            Ok []
                    in
                    Expect.equal expected (P.run Instruction.sequenceParser input)
            , test "returns Nothing if the input is wrong" <|
                \_ ->
                    let
                        input =
                            "FFDL"
                    in
                    Expect.err (P.run Instruction.sequenceParser input)
            , test "returns the right sequence of instructions in the right order" <|
                \_ ->
                    let
                        input =
                            "FFLFRFF"

                        expected =
                            Ok [ Forward, Forward, Left, Forward, Right, Forward, Forward ]
                    in
                    Expect.equal expected (P.run Instruction.sequenceParser input)
            ]
        ]
