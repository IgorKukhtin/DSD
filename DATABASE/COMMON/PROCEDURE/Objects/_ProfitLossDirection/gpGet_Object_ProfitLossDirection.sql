-- Function: gpGet_Object_ProfitLossDirection (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_ProfitLossDirection (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProfitLossDirection(
    IN inId             Integer,       -- ключ объекта <Аналитики статей отчета о прибылях и убытках - направление>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_ProfitLossDirection());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_ProfitLossDirection();
   ELSE
       RETURN QUERY 
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM Object 
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ProfitLossDirection (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_ProfitLossDirection (2, '')
