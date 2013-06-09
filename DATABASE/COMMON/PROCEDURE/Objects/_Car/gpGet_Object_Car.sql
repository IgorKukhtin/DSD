-- Function: gpGet_Object_Car()

--DROP FUNCTION gpGet_Object_Car();

CREATE OR REPLACE FUNCTION gpGet_Object_Car(
    IN inId          Integer,       -- Банки
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CarModelId Integer, CarModelName TVarChar, RegistrationCertificate TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
     , CarModel.Id        AS CarModelId
     , CarModel.ValueData AS CarModelName
     , RegistrationCertificate.ValueData      AS RegistrationCertificate
     FROM Object
LEFT JOIN ObjectLink AS Car_CarModel
       ON Car_CarModel.ObjectId = Object.Id AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
LEFT JOIN Object AS CarModel
       ON CarModel.Id = Car_CarModel.ChildObjectId
LEFT JOIN ObjectString AS RegistrationCertificate 
       ON RegistrationCertificate.ObjectId = Object.Id AND RegistrationCertificate.DescId = zc_ObjectString_RegistrationCertificate()
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Car(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')