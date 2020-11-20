-- Function: gpGet_Object_AmbulantClinicSP (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_AmbulantClinicSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AmbulantClinicSP(
    IN inId          Integer,       -- Группа товаров 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar)
AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_AmbulantClinicSP()) AS Code
           , CAST ('' as TVarChar)  AS Name;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_AmbulantClinicSP.Id            AS Id
           , Object_AmbulantClinicSP.ObjectCode    AS Code
           , Object_AmbulantClinicSP.ValueData     AS Name
       FROM OBJECT AS Object_AmbulantClinicSP
       WHERE Object_AmbulantClinicSP.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AmbulantClinicSP (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.11.20                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_AmbulantClinicSP(0,'3')