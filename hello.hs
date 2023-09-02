main :: IO ()
main = putStrLn myHtml

myHtml :: String
myHtml = makeHTML "My Page" (h1_ "How" ++ p_ "Are you?")

el :: String -> String -> String
el tag content =
    "<" ++ tag ++ ">" ++ content ++ "</" ++ tag ++ ">"
html_ :: String -> String
html_  = el "html"

body_ :: String -> String
body_  = el "body"

head_ :: String -> String
head_ = el "head"

title_ :: String -> String
title_ = el "title"

p_ :: String -> String
p_ = el "p"

h1_ :: String -> String
h1_ = el "h1"

makeHTML :: String -> String -> String
makeHTML title content = html_ body
    where body = head_ (title_ title) ++ body_ content
