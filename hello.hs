import Html
import Markup

main :: IO ()
main = putStrLn . render $ myHtml

myHtml :: Html
myHtml = html_ "My title"
    (h1_ "Heading"
    <>
     p_ "Paragraph #1</head>" <>
     p_ "Paragraph #2" <>
     ul_ [p_ "Item #1", p_ "Item #2", p_ "Item #3"] <>
     ol_ [p_ "Item #1", p_ "Item #2", p_ "Item #3"] <>
     code_ "Code Block")
