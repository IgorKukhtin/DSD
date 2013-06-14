-- Function: gpGet_Object_PriceList()

--DROP FUNCTION gpGet_Object_PriceList();

CREATE OR REPLACE FUNCTION gpGet_Object_PriceList(
    IN inId          Integer,       -- ключ объекта <Прайс лист> 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_PriceList();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id
           , Object.ObjectCode
           , Object.ValueData
           , Object.isErased
       FROM Object
       WHERE Object.Id = inId;
   END IF;
    
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PriceList(integer, TVarChar)
      OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.13          *
 00.06.13
 
*/

-- тест
-- SELECT * FROM gpSelect_PriceList('2')