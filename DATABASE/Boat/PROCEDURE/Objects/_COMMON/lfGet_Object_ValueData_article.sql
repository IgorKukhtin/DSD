-- Function: lfGet_Object_ValueData_article (Integer) - Используется для дефолтов в Get-процедурах (т.е. сократить код и не писать строку запроса)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData_article (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData_article (IN inId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT CASE WHEN TRIM (ObjectString_Article.ValueData) <> '' THEN '(' || ObjectString_Article.ValueData || ') ' ELSE '' END || Object.ValueData
                       FROM Object
                            LEFT JOIN ObjectString AS ObjectString_Article
                                                   ON ObjectString_Article.ObjectId = Object.Id
                                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                       WHERE Object.Id = inId
                      ), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.13                                        *                            
*/

-- тест
-- SELECT * FROM lfGet_Object_ValueData_article (253246)
