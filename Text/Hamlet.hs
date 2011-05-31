{-# LANGUAGE OverloadedStrings #-}
module Text.Hamlet
    ( -- * Construction
      preEscapedString
    , preEscapedText
    , preEscapedLazyText
    , cdata
    , toHtml
      -- * Rendering
      -- ** ByteString
    , renderHamlet
    , renderHtml
      -- ** Text
    , renderHamletText
    , renderHtmlText
      -- * Hamlet
    , module Text.Hamlet.NonPoly
    ) where

import Text.Hamlet.NonPoly
    ( Html, html, htmlFile
    , Hamlet, hamlet, hamletFile
    , IHamlet, ihamlet, ihamletFile
    )
import Text.Hamlet.Parse
import qualified Data.ByteString.Lazy as L
import Data.Monoid (mappend)
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.Encoding as T
import qualified Data.Text.Encoding.Error as T
import Text.Blaze.Renderer.Utf8 (renderHtml)
import qualified Text.Blaze.Renderer.Text as BT
import Text.Blaze (preEscapedText, preEscapedString, string, unsafeByteString, toHtml, preEscapedLazyText)
import Data.Text (Text)

-- | Converts a 'Hamlet' to lazy bytestring.
renderHamlet :: (url -> [(Text, Text)] -> Text) -> Hamlet url -> L.ByteString
renderHamlet render h = renderHtml $ h render

renderHamletText :: (url -> [(Text, Text)] -> Text) -> Hamlet url
                 -> T.Text
renderHamletText render h =
    T.decodeUtf8With T.lenientDecode $ renderHtml $ h render

renderHtmlText :: Html -> T.Text
renderHtmlText = BT.renderHtml

-- | Wrap an 'Html' for embedding in an XML file.
cdata :: Html -> Html
cdata h =
    preEscapedText "<![CDATA["
    `mappend`
    h
    `mappend`
    preEscapedText "]]>"
