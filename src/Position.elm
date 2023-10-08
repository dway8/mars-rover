module Position exposing
    ( Position
    , toString
    )


type alias Position =
    { x : Int
    , y : Int
    }


toString : Position -> String
toString position =
    String.fromInt position.x ++ ", " ++ String.fromInt position.y
