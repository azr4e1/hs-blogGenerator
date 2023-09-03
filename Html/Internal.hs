module Html.Internal
where

newtype Html = Html String
newtype Structure = Structure String
type Title = String
type SimpleTag = String -> Structure


instance Semigroup Structure where
    (<>) (Structure str1) (Structure str2)
        = Structure (str1 <> str2)

html_ :: Title -> Structure -> Html
html_ title (Structure body) = Html .
    el "html" $
    el "head" ( el "title" . escape $ title)
    ++ el "body" body

el :: String -> String -> String
el tag content =
    "<" ++ tag ++ ">" ++ content ++ "</" ++ tag ++ ">"

getStructureString :: Structure -> String
getStructureString (Structure struct) = struct

render :: Html -> String
render (Html str) = str

escape :: String -> String
escape =
    let
        escapeChar c =
            case c of
                '<' -> "&lt;"
                '>' -> "&gt;"
                '&' -> "&amp;"
                '"' -> "&quot;"
                '\'' -> "&#39;"
                _ -> [c]
    in
        concatMap escapeChar

p_ :: String -> Structure
p_ = Structure . el "p" . escape

code_ :: String -> Structure
code_ = Structure . el "pre" . escape

h1_ :: String -> Structure
h1_ = Structure . el "h1" . escape

ul_ :: [Structure] -> Structure
ul_ = Structure . el "ul" . concatMap listElementTag
    where listElementTag =
            let li_ = el "li"
            in li_ . getStructureString

ol_ :: [Structure] -> Structure
ol_ = Structure . el "ol" . concatMap listElementTag
    where listElementTag =
            let li_ = el "li"
            in li_ . getStructureString
