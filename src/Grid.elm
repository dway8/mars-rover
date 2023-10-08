module Grid exposing
    ( Grid
    , fromString
    , isPositionInside
    )

import Position exposing (Position)


type alias Grid =
    { columns : Int
    , rows : Int
    }


fromString : String -> Maybe Grid
fromString str =
    str
        |> String.split " "
        |> (\list ->
                case list of
                    columnsStr :: rowsStr :: [] ->
                        case ( String.toInt columnsStr, String.toInt rowsStr ) of
                            ( Just columns, Just rows ) ->
                                Just { columns = columns, rows = rows }

                            _ ->
                                Nothing

                    _ ->
                        Nothing
           )


isPositionInside : Grid -> Position -> Bool
isPositionInside grid position =
    (position.x >= 0)
        && (position.y >= 0)
        && (position.x <= grid.rows)
        && (position.y <= grid.columns)
