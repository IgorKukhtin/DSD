-- Function: gpGet_Object_Car(Integer,TVarChar)

-- DROP FUNCTION gpGet_Object_Car(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Car(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , RegistrationCertificate TVarChar, StartDateRate TDateTime, EndDateRate TDateTime
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , FuelMasterId Integer, FuelMasterCode Integer, FuelMasterName TVarChar
             , FuelChildId Integer, FuelChildCode Integer, FuelChildName TVarChar
             , RateFuelKindId Integer, RateFuelKindCode Integer, RateFuelKindName TVarChar
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
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS StartDateRate
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS EndDateRate

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

           , CAST (0 as Integer)    AS RateFuelKindId
           , CAST (0 as Integer)    AS RateFuelKindCode
           , CAST ('' as TVarChar)  AS RateFuelKindName

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
           
           , ObjectDate_Car_StartRate.ValueData AS StartDateRate
           , ObjectDate_Car_EndRate.ValueData   AS EndDateRate
           
           , Object_CarModel.Id         AS CarModelId
           , Object_CarModel.ObjectCode AS CarModelCode
           , Object_CarModel.ValueData  AS CarModelName
         
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ObjectCode  AS UnitCode
           , Object_Unit.ValueData   AS UnitName

           , Object_PersonalDriver.Id          AS PersonalDriverId
           , Object_PersonalDriver.ObjectCode  AS PersonalDriverCode
           , Object_PersonalDriver.ValueData   AS PersonalDriverName

           , Object_FuelMaster.Id          AS FuelMasterId
           , Object_FuelMaster.ObjectCode  AS FuelMasterCode
           , Object_FuelMaster.ValueData   AS FuelMasterName        

           , Object_FuelChild.Id          AS FuelChildId
           , Object_FuelChild.ObjectCode  AS FuelChildCode
           , Object_FuelChild.ValueData   AS FuelChildName
           
           , Object_RateFuelKind.Id          AS RateFuelKindId
           , Object_RateFuelKind.ObjectCode  AS RateFuelKindCode
           , Object_RateFuelKind.ValueData   AS RateFuelKindName
 
           , Object.isErased AS isErased
           
       FROM Object AS Object_Car
       
            LEFT JOIN ObjectString AS RegistrationCertificate ON RegistrationCertificate.ObjectId = Object_Car.Id 
                                                             AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
                                                             
            LEFT JOIN ObjectDate AS ObjectDate_Car_StartRate ON ObjectDate_Car_StartRate.ObjectId = Object_Car.Id 
                                                            AND ObjectDate_Car_StartRate.DescId = zc_ObjectDate_Car_StartDateRate()
                
            LEFT JOIN ObjectDate AS ObjectDate_Car_EndRate ON ObjectDate_Car_EndRate.ObjectId = Object_Car.Id 
                                                          AND ObjectDate_Car_EndRate.DescId = zc_ObjectDate_Car_EndDateRate()          
       
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                                                 AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster ON ObjectLink_Car_FuelMaster.ObjectId = Object_Car.Id
                                                             AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
            LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelChild ON ObjectLink_Car_FuelChild.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_FuelChild.DescId = zc_ObjectLink_Car_FuelChild()
            LEFT JOIN Object AS Object_FuelChild ON Object_FuelChild.Id = ObjectLink_Car_FuelChild.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_RateFuelKind ON ObjectLink_Car_RateFuelKind.ObjectId = Object_Car.Id
                                                               AND ObjectLink_Car_RateFuelKind.DescId = zc_ObjectLink_Car_RateFuelKind()
            LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_Car_RateFuelKind.ChildObjectId
            
       WHERE Object_Car.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Car(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          * add StartDateRate, EndDateRate, Unit, PersonalDriver, FuelMaster, FuelChild, RateFuelKind               
 10.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpGet_Object_Car (2, '')
