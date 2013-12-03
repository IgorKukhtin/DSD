-- Function: gpGet_Object_PositionLevel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PositionLevel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PositionLevel(
    IN inId             Integer,       -- ключ объекта <Топливные карты>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_PositionLevel());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PositionLevel()) AS Code
           , CAST ('' as TVarChar)  AS Name
                      
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_PositionLevel.Id         AS Id
           , Object_PositionLevel.ObjectCode AS Code
           , Object_PositionLevel.ValueData  AS NAME
                      
           , Object_PositionLevel.isErased   AS isErased
           
       FROM Object AS Object_PositionLevel
       WHERE Object_PositionLevel.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PositionLevel (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.10.13          *         

*/

-- тест
-- SELECT * FROM gpGet_Object_PositionLevel (2, '')
