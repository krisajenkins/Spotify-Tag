module View (rootView) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Response)
import Schema exposing (..)
import Signal exposing (Address)
import String

wordButton : Address Action -> String -> Html
wordButton uiChannel s =
  button [class "btn btn-info"
         ,onClick uiChannel (ChooseWord s)]
         [text s]

albumImage : Album -> Html
albumImage album =
  case List.head album.images of
    Nothing -> div [] []
    Just i -> img [src i.url
                  ,class "img-responsive"]
                  []

trackView : Address Action -> Track -> Html
trackView uiChannel track =
  div [class "col-xs-2 track"
      ,id track.id]
      (albumImage track.album
      ::
      (h3 [] [text (String.join " / " (List.map .name track.artists))]
       ::
       (List.map (wordButton uiChannel)
                (String.split " " track.name))))

trackListView : Address Action -> List Track -> Html
trackListView uiChannel tracks =
  div [class "row"]
      (List.map (trackView uiChannel) tracks)

tracksView : Address Action -> Response (Result String (List Track)) -> Html
tracksView uiChannel r =
  case r of
    Http.Success (Ok tracks) -> trackListView uiChannel tracks
    _ -> div [] [code [] [text (toString r)]]

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div []
      [div [id "main-container"
           ,class "container"]
           (h1 [] [text (case model.chosenWord of
                           Nothing -> "Get Started!"
                           Just s -> s)]
           ::
           [tracksView uiChannel model.tracks])]