module Main exposing (Flags, Model(..), Msg(..), changeRouteTo, init, main, subscriptions, toEnv, update, updateWith, view)

import Browser
import Browser.Navigation as Nav
import Env exposing (Env)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Id exposing (Id)
import Page.Index as IndexPage
import Page.View as ViewPage
import Route exposing (Route)
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Model
    = NotFound Env
    | Index Env IndexPage.Model
    | View Env Id ViewPage.Model


type alias Flags =
    {}


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    changeRouteTo (Route.fromUrl url)
        (NotFound <|
            Env.create key
        )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotIndexMsg IndexPage.Msg
    | GotViewMsg ViewPage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    let
        env =
            toEnv model
    in
    case ( message, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case Route.fromUrl url of
                        Just _ ->
                            ( model, Nav.pushUrl (Env.navKey env) (Url.toString url) )

                        Nothing ->
                            ( model, Nav.load <| Url.toString url )

                Browser.External href ->
                    if String.length href == 0 then
                        ( model, Cmd.none )

                    else
                        ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotIndexMsg subMsg, Index _ subModel ) ->
            IndexPage.update subMsg subModel
                |> updateWith (Index env) GotIndexMsg

        ( GotViewMsg subMsg, View _ id subModel ) ->
            ViewPage.update subMsg subModel
                |> updateWith (View env id) GotViewMsg

        ( _, _ ) ->
            ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        env =
            toEnv model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound env, Cmd.none )

        Just Route.Index ->
            IndexPage.init env
                |> updateWith (Index env) GotIndexMsg

        Just (Route.View id) ->
            ViewPage.init env id
                |> updateWith (View env id) GotViewMsg


toEnv : Model -> Env
toEnv page =
    case page of
        NotFound env ->
            env

        Index env _ ->
            env

        View env _ _ ->
            env


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Index _ subModel ->
            Sub.map GotIndexMsg (IndexPage.subscriptions subModel)

        View _ _ subModel ->
            Sub.map GotViewMsg (ViewPage.subscriptions subModel)



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage toMsg { title, body } =
            { title = title, body = List.map (Html.map toMsg) body }
    in
    case model of
        NotFound _ ->
            { title = "Not Found", body = [ Html.text "Not Found" ] }

        Index _ subModel ->
            viewPage GotIndexMsg (IndexPage.view subModel)

        View _ _ subModel ->
            viewPage GotViewMsg (ViewPage.view subModel)
