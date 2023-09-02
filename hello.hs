import Html

main :: IO ()
main = putStrLn . render $ myHtml

myHtml :: Html
myHtml = html_ "My title"
    (h1_ "Heading" `append_`
        (p_ "Paragraph #1</head>" `append_` p_ "Paragraph #2"))

