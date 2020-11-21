-- Function: gpSelect_Object_AmbulantClinicSP()

DROP FUNCTION IF EXISTS gpSelect_Object_AmbulantClinicSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AmbulantClinicSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
           Object.Id         AS Id 
         , Object.ObjectCode AS Code
         , Object.ValueData  AS Name
         , Object.isErased   AS isErased
     FROM Object
     WHERE Object.DescId = zc_Object_AmbulantClinicSP();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_AmbulantClinicSP(TVarChar)
  OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.11.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_AmbulantClinicSP('3')