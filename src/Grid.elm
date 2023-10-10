module Grid exposing
    ( Grid
    , isPositionInside
    , parser
    )

import Parser as P exposing ((|.), (|=))
import Position exposing (Position)


type alias Grid =
    { columns : Int
    , rows : Int
    }


parser : P.Parser Grid
parser =
    P.succeed Grid
        |= P.int
        |. P.symbol " "
        |= P.int
        |. P.symbol "\n"


isPositionInside : Grid -> Position -> Bool
isPositionInside grid position =
    (position.x >= 0)
        && (position.y >= 0)
        && (position.x <= grid.rows)
        && (position.y <= grid.columns)
