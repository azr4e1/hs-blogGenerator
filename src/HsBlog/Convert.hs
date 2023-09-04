module HsBlog.Convert where

import qualified HsBlog.Markup as Markup
import qualified HsBlog.Html as Html

convertStructure :: Markup.Structure -> Html.Structure
convertStructure structure =
    case structure of
        Markup.Heading n txt -> 
            Html.h_ n txt

        Markup.Paragraph p -> 
            Html.p_ p

        Markup.UnorderedList list -> 
            Html.ul_ $ map Html.p_ list

        Markup.OrderedList list -> 
            Html.ol_ $ map Html.p_ list

        Markup.CodeBlock list -> 
            Html.code_ (unlines list)

-- concatenateDocument :: Markup.Document -> Html.Structure
-- concatenateDocument document = mconcat htmlDocument
--     where htmlDocument = map convertStructure document

convert :: Html.Title -> Markup.Document -> Html.Html
convert title = Html.html_ title . foldMap convertStructure

process :: Html.Title -> String -> String
process title = Html.render . convert title . Markup.parse
