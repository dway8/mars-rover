module Grid exposing
    ( Grid
    , isPositionInside
    )

import Position exposing (Position)


type alias Grid =
    { columns : Int
    , rows : Int
    }


isPositionInside : Grid -> Position -> Bool
isPositionInside grid position =
    (position.x >= 0)
        && (position.y >= 0)
        && (position.x <= grid.rows)
        && (position.y <= grid.columns)
