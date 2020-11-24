-- Function: gpGet_Object_PriceList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceList(
    IN inId          Integer,       -- ключ объекта <Прайс лист> 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
               , PriceWithVAT Boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)         AS Id
           , lfGet_ObjectCode(0, zc_Object_PriceList())   AS Code
           , CAST ('' as TVarChar)       AS Name
           , CAST (FALSE AS Boolean)     AS PriceWithVAT

      ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT

       FROM Object AS Object_PriceList
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
       WHERE Object_PriceList.Id = inId;

   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PriceList (0, '2')
