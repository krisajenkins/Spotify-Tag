module Main where

import Html exposing (Html)
import Http exposing (Response)
import Json.Decode as JsonDecode
import Schema exposing (..)
import Signal exposing ((<~),mergeMany,Mailbox,foldp)
import String
import View exposing (rootView)

actionSignal : Signal Action
actionSignal =
  mergeMany [uiMailbox.signal
            ,QueryResponse <~ query]

uiMailbox : Mailbox Action
uiMailbox = Signal.mailbox NoOp

constructQueryUrl : Action -> String
constructQueryUrl a =
 "https://api.spotify.com/v1/search?type=track&q="
 ++
 (case a of
    ChooseWord s -> s
    NoOp -> "dance")

uiWords : Signal Action
uiWords = Signal.filter (\a -> case a of
                                 ChooseWord _ -> True
                                 _ -> False)
                        NoOp
                        uiMailbox.signal

wordRequests : Signal String
wordRequests = constructQueryUrl <~ uiWords

query : Signal (Response (Result String (List Track)))
query = Http.map (JsonDecode.decodeString decodeSpotifySearch)
                 <~ Http.sendGet wordRequests

initialModel : Model
initialModel =
  {chosenWord = Nothing
  ,tracks = Http.NotAsked}

step : Action -> Model -> Model
step a m =
  case a of
    NoOp -> m
    ChooseWord s -> {m | chosenWord <- Just s}
    QueryResponse xs -> {m | tracks <- xs}

modelSignal : Signal Model
modelSignal =
  foldp step
        initialModel
        actionSignal

main : Signal Html
main = rootView uiMailbox.address <~ modelSignal
