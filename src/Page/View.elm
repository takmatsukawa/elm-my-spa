module Page.View exposing (Model, Msg, init, subscriptions, update, view)

import Env exposing (Env)
import Html exposing (..)
import Id exposing (Id)
import Route



-- MODEL


type alias Model =
    { env : Env
    , id : Id
    }


init : Env -> Id -> ( Model, Cmd Msg )
init env id =
    ( Model env id
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
    { title = "elm-my-app - view"
    , body =
        [ a [ Route.href Route.Index ] [ text "Back to Index" ]
        , p [] [ text <| "view " ++ Id.toString model.id ]
        ]
    }
