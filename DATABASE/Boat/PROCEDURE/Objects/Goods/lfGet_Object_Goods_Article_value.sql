--
DROP FUNCTION IF EXISTS lfGet_Object_Goods_Article_value (TVarChar);

CREATE OR REPLACE FUNCTION lfGet_Object_Goods_Article_value(
    IN inSrchText  TVarChar
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbValue Integer;
BEGIN

   --если ТОвар сохранен, то ничего не меняем
   IF COALESCE (inSrchText, '') = ''
   THEN
        RETURN '';
   END IF;
   
   vbValue:= 1 + COALESCE ((SELECT MAX (zfConvert_StringToFloat (SUBSTRING (ObjectString_Article.ValueData FROM 1 + LENGTH (inSrchText) FOR 3))) ::Integer
                            FROM Object AS Object_Goods
                                 INNER JOIN ObjectString AS ObjectString_Article
                                                         ON ObjectString_Article.ObjectId  = Object_Goods.Id
                                                        AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                                        AND ObjectString_Article.ValueData ILIKE (inSrchText || '%')
                                                      --AND LENGTH (ObjectString_Article.ValueData) = LENGTH (inSrchText) + 2
                                 INNER JOIN ObjectString AS ObjectString_Comment
                                                         ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                                        AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                                        AND (ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                                                          OR ObjectString_Comment.ValueData ILIKE 'DECK'
                                                          OR ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                            )

                            WHERE Object_Goods.DescId = zc_Object_Goods()
                           ), 0);
                      
                      
   IF EXISTS (SELECT 1 FROM Object_Article WHERE Object_Article.Article ILIKE inSrchText AND Object_Article.LastValue >= vbValue)
   THEN
       UPDATE Object_Article SET LastValue = Object_Article.LastValue + 1 WHERE Object_Article.Article ILIKE inSrchText;
   ELSE
       UPDATE Object_Article SET LastValue = vbValue WHERE Object_Article.Article ILIKE inSrchText;
       --
       IF NOT FOUND THEN
          INSERT INTO Object_Article (Article, LastValue) VALUES (inSrchText, vbValue);
       END IF;
   END IF;


   --
   --
   RETURN inSrchText || (SELECT Object_Article.LastValue :: TVarChar FROM Object_Article WHERE Object_Article.Article ILIKE inSrchText);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.22         *
*/

-- тест
-- delete from Object_Article;
-- SELECT lfGet_Object_Goods_Article_value ('AGL-280-'), lfGet_Object_Goods_Article_value ('AGL-280-')
