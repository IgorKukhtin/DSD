-- Function: gpSelect_Object_Car (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Car (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Car(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , RegistrationCertificate TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , FuelMasterId Integer, FuelMasterCode Integer, FuelMasterName TVarChar
             , FuelChildId Integer, FuelChildCode Integer, FuelChildName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Car());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
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
           
           , Object_Car.isErased    AS isErased
           
       FROM Object AS Object_Car
            LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Car.AccessKeyId
       
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

     WHERE Object_Car.DescId = zc_Object_Car()
       AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Car(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 30.09.13                                        * add Object_Personal_View
 26.09.13          * del StartDateRate, EndDateRate, RateFuelKind               
 24.09.13          * add StartDateRate, EndDateRate, Unit, PersonalDriver, FuelMaster, FuelChild, RateFuelKind               
 10.06.13          * 
 03.06.13          
*/
/*
UPDATE Object SET AccessKeyId = COALESCE (Object_Branch.AccessKeyId, zc_Enum_Process_AccessKey_TrasportDnepr()) FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Car_Unit() AND Object.DescId = zc_Object_Car();
*/
-- тест
-- SELECT * FROM gpSelect_Object_Car (zfCalc_UserAdmin())