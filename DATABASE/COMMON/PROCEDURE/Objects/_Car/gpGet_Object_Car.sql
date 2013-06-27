-- Function: gpGet_Object_Car()

-- DROP FUNCTION gpGet_Object_Car();

CREATE OR REPLACE FUNCTION gpGet_Object_Car(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CarModelId Integer, CarModelName TVarChar, RegistrationCertificate TVarChar) AS
$BODY$BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS CarModelId
           , CAST ('' as TVarChar)  AS CarModelName
           , CAST ('' as TVarChar)  AS RegistrationCertificate
       FROM Object 
       WHERE Object.DescId = zc_Object_Car();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id          AS Id
           , Object.ObjectCode  AS Code
           , Object.ValueData   AS Name
           , Object.isErased    AS isErased
           , CarModel.Id        AS CarModelId
           , CarModel.ValueData AS CarModelName
           , RegistrationCertificate.ValueData      AS RegistrationCertificate
       FROM Object
  LEFT JOIN ObjectLink AS Car_CarModel
         ON Car_CarModel.ObjectId = Object.Id AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
  LEFT JOIN Object AS CarModel
         ON CarModel.Id = Car_CarModel.ChildObjectId
  LEFT JOIN ObjectString AS RegistrationCertificate 
         ON RegistrationCertificate.ObjectId = Object.Id AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
      WHERE Object.Id = inId;
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Car(integer, TVarChar)
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpGet_Object_Car (2, '')
