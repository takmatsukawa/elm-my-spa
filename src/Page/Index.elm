module Page.Index exposing (Model, Msg, init, subscriptions, update, view)

import Env exposing (Env)
import Html exposing (..)
import Id exposing (Id)
import Json.Decode as JD
import Route



-- MODEL


type alias Model =
    { env : Env
    , items : List Item
    }


type alias Item =
    { id : Id
    , name : String
    }


init : Env -> ( Model, Cmd Msg )
init env =
    let
        items =
            List.range 1 5
                |> List.map (\i -> "item" ++ String.fromInt i)
                |> List.map (\name -> ( JD.decodeString Id.idDecoder ("\"" ++ name ++ "\""), name ))
                |> List.filterMap
                    (\result ->
                        case Tuple.first result of
                            Ok id ->
                                Just <| Item id (Tuple.second result)

                            _ ->
                                Nothing
                    )
    in
    ( Model env items
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOps


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOps ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "elm-my-app - index"
    , body =
        [ text "Index:"
        , ul [] <| List.map (\item -> li [] [ a [ Route.href <| Route.View item.id ] [ text item.name ] ]) model.items
        ]
    }
