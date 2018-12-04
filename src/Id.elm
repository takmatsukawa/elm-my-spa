module Id exposing (Id, idDecoder, idParser, toString)

import Json.Decode as JD
import Url.Parser


type Id
    = Id String


idParser : Url.Parser.Parser (Id -> a) a
idParser =
    Url.Parser.custom "ID" (\str -> Just (Id str))


toString : Id -> String
toString (Id id) =
    id


idDecoder : JD.Decoder Id
idDecoder =
    JD.map Id JD.string
