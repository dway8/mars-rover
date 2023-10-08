module Robot exposing
    ( Robot
    , fromString
    )

import Orientation exposing (Orientation)
import Position exposing (Position)


type alias Robot =
    { position : Position
    , orientation : Orientation
    }


fromString : String -> Maybe Robot
fromString str =
    if not (String.startsWith "(" str) || not (String.endsWith ")" str) then
        Nothing

    else
        str
            |> String.dropLeft 1
            |> String.dropRight 1
            |> String.split ","
            |> List.map String.trim
            |> (\input ->
                    case input of
                        xStr :: yStr :: orientationStr :: [] ->
                            case
                                ( String.toInt xStr
                                , String.toInt yStr
                                , Orientation.fromString orientationStr
                                )
                            of
                                ( Just x, Just y, Just orientation ) ->
                                    Just ( Position x y, orientation )

                                _ ->
                                    Nothing

                        _ ->
                            Nothing
               )
            |> Maybe.map
                (\( position, orientation ) ->
                    { position = position
                    , orientation = orientation
                    }
                )
