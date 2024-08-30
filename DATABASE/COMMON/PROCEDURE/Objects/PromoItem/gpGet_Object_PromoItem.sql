-- Function: gpGet_Object_PromoItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PromoItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PromoItem(
    IN inId             Integer,       -- ключ объекта <>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Code Integer, Name TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_PromoItem());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             lfGet_ObjectCode(0, zc_Object_PromoItem()) AS Code
           , CAST ('' as TVarChar)  AS Name;
   ELSE
       RETURN QUERY 
       SELECT
             Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object 
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.24         *

*/

-- тест
-- SELECT * FROM gpGet_Object_PromoItem (2, '')
