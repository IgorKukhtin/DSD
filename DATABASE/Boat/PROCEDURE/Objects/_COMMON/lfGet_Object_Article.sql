-- Function: lfGet_Object_Article (Integer) - Используется для дефолтов в Get-процедурах (т.е. сократить код и не писать строку запроса)

DROP FUNCTION IF EXISTS lfGet_Object_Article (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Article (IN inObjectId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT ValueData FROM ObjectString where ObjectId = inObjectId AND DescId = zc_ObjectString_Article()), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22                                        *                            
*/

-- тест
-- SELECT * FROM lfGet_Object_Article (1)
