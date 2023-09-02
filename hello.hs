main :: IO ()
main = putStrLn . render $ myHtml

myHtml :: Html
myHtml = html_ "My title"
    (h1_ "Heading" `append_`
        (p_ "Paragraph #1" `append_` p_ "Paragraph #2"))

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


-- body_ :: String -> Structure
-- body_  = Structure . el "body"
--
-- head_ :: String -> Structure
-- head_ = Structure . el "head"
--
-- title_ :: String -> Structure
-- title_ = Structure . el "title"

p_ :: String -> Structure
p_ = Structure . el "p"

h1_ :: String -> Structure
h1_ = Structure . el "h1"

append_ :: Structure -> Structure -> Structure
append_ (Structure str1) (Structure str2) =
    Structure (str1 ++ str2)


-- makeHTML :: String -> String -> Html
-- makeHTML title content = html_ body
--     where body = head_ (title_ title) `append_` body_ content


-- getStructureString :: Structure -> String
-- getStructureString struct =
--     case struct of
--         Structure str -> str

render :: Html -> String
render (Html str) = str
