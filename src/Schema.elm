module Schema where

import Http exposing (Response)
import Json.Decode as JsonDecode
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (apply,date)

type Action
  = NoOp
  | ChooseWord String
  | QueryResponse (Response (List Track))

type alias Artist =
  {id : String
  ,name : String}

type alias AlbumImage =
  {url : String}

type alias Album =
  {name : String
  ,images : List AlbumImage}

type alias Track =
  {id : String
  ,name : String
  ,album : Album
  ,artists : List Artist}

decodeArtist : Decoder Artist
decodeArtist = Artist
  `map`   ("id" := string)
  `apply` ("name" := string)

decodeAlbumImage : Decoder AlbumImage
decodeAlbumImage = AlbumImage
  `map`   ("url" := string)

decodeAlbum : Decoder Album
decodeAlbum = Album
  `map`   ("name" := string)
  `apply` ("images" := Json.Decode.list decodeAlbumImage)

decodeTrack : Decoder Track
decodeTrack = Track
  `map`   ("id" := string)
  `apply` ("name" := string)
  `apply` ("album" := decodeAlbum)
  `apply` ("artists" := Json.Decode.list decodeArtist)

decodeSpotifySearch : Decoder (List Track)
decodeSpotifySearch =
  at ["tracks", "items"] (Json.Decode.list decodeTrack)

type alias Model =
  {chosenWord : Maybe String
  ,tracks : Response (List Track)}
