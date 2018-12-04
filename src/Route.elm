module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Id exposing (Id)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Index
    | View Id


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Index (Parser.s "elm-my-spa")
        , Parser.map View (Parser.s "elm-my-spa" </> Parser.s "view" </> Id.idParser)
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Index ->
                    []

                View id ->
                    [ "view", Id.toString id ]
    in
    "/elm-my-spa/" ++ String.join "/" pieces
