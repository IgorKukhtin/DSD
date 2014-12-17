-- Function: gpGet_Object_Car (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Car (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Car(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , RegistrationCertificate TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , FuelMasterId Integer, FuelMasterCode Integer, FuelMasterName TVarChar
             , FuelChildId Integer, FuelChildCode Integer, FuelChildName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Car());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_Car.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS RegistrationCertificate

           , CAST (0 as Integer)    AS CarModelId
           , CAST (0 as Integer)    AS CarModelCode
           , CAST ('' as TVarChar)  AS CarModelName
          
           , CAST (0 as Integer)    AS UnitId
           , CAST (0 as Integer)    AS UnitCode
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (0 as Integer)    AS PersonalDriverId
           , CAST (0 as Integer)    AS PersonalDriverCode
           , CAST ('' as TVarChar)  AS PersonalDriverName

           , CAST (0 as Integer)    AS FuelMasterId
           , CAST (0 as Integer)    AS FuelMasterCode
           , CAST ('' as TVarChar)  AS FuelMasterName
          
           , CAST (0 as Integer)    AS FuelChildId
           , CAST (0 as Integer)    AS FuelChildCode
           , CAST ('' as TVarChar)  AS FuelChildName
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_Car
       WHERE Object_Car.DescId = zc_Object_Car();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Car.Id          AS Id
           , Object_Car.ObjectCode  AS Code
           , Object_Car.ValueData   AS Name
           
           , RegistrationCertificate.ValueData  AS RegistrationCertificate
           
           , Object_CarModel.Id         AS CarModelId
           , Object_CarModel.ObjectCode AS CarModelCode
           , Object_CarModel.ValueData  AS CarModelName
         
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ObjectCode  AS UnitCode
           , Object_Unit.ValueData   AS UnitName

           , View_PersonalDriver.PersonalId   AS PersonalDriverId
           , View_PersonalDriver.PersonalCode AS PersonalDriverCode
           , View_PersonalDriver.PersonalName AS PersonalDriverName

           , Object_FuelMaster.Id          AS FuelMasterId
           , Object_FuelMaster.ObjectCode  AS FuelMasterCode
           , Object_FuelMaster.ValueData   AS FuelMasterName        

           , Object_FuelChild.Id          AS FuelChildId
           , Object_FuelChild.ObjectCode  AS FuelChildCode
           , Object_FuelChild.ValueData   AS FuelChildName
           
           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName           
           
           , Object_Car.isErased AS isErased
           
       FROM Object AS Object_Car
       
            LEFT JOIN ObjectString AS RegistrationCertificate ON RegistrationCertificate.ObjectId = Object_Car.Id 
                                                             AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
                                                             
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                                                 AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_Car_PersonalDriver.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster ON ObjectLink_Car_FuelMaster.ObjectId = Object_Car.Id
                                                             AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
            LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelChild ON ObjectLink_Car_FuelChild.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_FuelChild.DescId = zc_ObjectLink_Car_FuelChild()
            LEFT JOIN Object AS Object_FuelChild ON Object_FuelChild.Id = ObjectLink_Car_FuelChild.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Car_Juridical.ChildObjectId            

       WHERE Object_Car.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Car (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.14         * add Juridical               
 30.09.13                                        * add Object_Personal_View
 26.09.13          * del StartDateRate, EndDateRate, RateFuelKind               
 24.09.13          * add StartDateRate, EndDateRate, Unit, PersonalDriver, FuelMaster, FuelChild, RateFuelKind               
 10.06.13          *
 03.06.13          
*/

-- тест
-- SELECT * FROM gpGet_Object_Car (2, '')
