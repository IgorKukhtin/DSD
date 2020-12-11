-- Страна производитель

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptLevel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptLevel(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptLevel());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptLevel())   AS Code
           , '' :: TVarChar    AS Name
           , '' :: TVarChar    AS ShortName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptLevel.Id         AS Id
           , Object_ReceiptLevel.ObjectCode AS Code
           , Object_ReceiptLevel.ValueData  AS Name
           , COALESCE (ObjectString_ShortName.ValueData, NULL) :: TVarChar AS ShortName
       FROM Object AS Object_ReceiptLevel
           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_ReceiptLevel.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_ReceiptLevel_ShortName()
       WHERE Object_ReceiptLevel.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptLevel(0, '2')
