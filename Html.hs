module Html
    (Html,
     Title,
     Structure,
     html_,
     p_,
     h1_,
     append_,
     render)
where

newtype Html = Html String
newtype Structure = Structure String
type Title = String

html_ :: Title -> Structure -> Html
html_ title (Structure body) = Html .
    el "html" $
    el "head" ( el "title" title)
    ++ el "body" body

el :: String -> String -> String
el tag content =
    "<" ++ tag ++ ">" ++ content ++ "</" ++ tag ++ ">"

p_ :: String -> Structure
p_ = Structure . el "p"

h1_ :: String -> Structure
h1_ = Structure . el "h1"

append_ :: Structure -> Structure -> Structure
append_ (Structure str1) (Structure str2) =
    Structure (str1 ++ str2)

getStructureString :: Structure -> String
getStructureString (Structure struct) = struct

render :: Html -> String
render (Html str) = str
