-- Function: gpGet_Object_CountSP_1303 (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_CountSP_1303 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CountSP_1303(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_CountSP_1303());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CountSP_1303()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CountSP_1303.Id          AS Id
            , Object_CountSP_1303.ObjectCode  AS Code
            , Object_CountSP_1303.ValueData   AS Name
            , Object_CountSP_1303.isErased    AS isErased
       FROM Object AS Object_CountSP_1303
       WHERE Object_CountSP_1303.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.05.22                                                       *              
*/

-- тест
-- SELECT * FROM gpGet_Object_CountSP_1303(0,'2')