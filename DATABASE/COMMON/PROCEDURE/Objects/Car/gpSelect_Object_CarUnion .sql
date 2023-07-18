-- Function: gpSelect_Object_Car (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CarUnion (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CarUnion(
    IN inIsShowAll        Boolean,   
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar 
             , RegistrationCertificate TVarChar, Comment TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , FuelMasterId Integer, FuelMasterCode Integer, FuelMasterName TVarChar
             , FuelChildId Integer, FuelChildCode Integer, FuelChildName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , DescName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbAccessKey_Kiev Boolean;
   DECLARE vbAccessKey_Lviv Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Car());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);
     
     vbAccessKey_Kiev:= EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportKiev(), zc_Enum_Process_AccessKey_GuideKiev()));
     vbAccessKey_Lviv:= EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportLviv(), zc_Enum_Process_AccessKey_GuideLviv()));

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Car.Id          AS Id
           , Object_Car.ObjectCode  AS Code
           , Object_Car.ValueData   AS Name
           , (COALESCE (Object_CarModel.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS NameAll
           
           , RegistrationCertificate.ValueData  AS RegistrationCertificate
           , ObjectString_Comment.ValueData        AS Comment
           
           , Object_CarModel.Id         AS CarModelId
           , Object_CarModel.ObjectCode AS CarModelCode
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
         
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

           , ObjectDesc.ItemName          AS DescName
           
           , Object_Car.isErased          AS isErased
           
       FROM Object AS Object_Car
            LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON vbAccessKeyAll = FALSE AND tmpRoleAccessKey.AccessKeyId = Object_Car.AccessKeyId
       
            LEFT JOIN ObjectString AS RegistrationCertificate 
                                   ON RegistrationCertificate.ObjectId = Object_Car.Id 
                                  AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Car.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Car_Comment()
                                                             
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
            
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

            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Car.DescId
            
     WHERE Object_Car.DescId = zc_Object_Car()
       AND (tmpRoleAccessKey.AccessKeyId > 0 OR vbAccessKeyAll = TRUE OR Object_Unit.Id = 8395 -- 21000 Транспорт - сбыт
            OR (vbAccessKey_Kiev = TRUE AND Object_Car.AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportLviv(), zc_Enum_Process_AccessKey_GuideLviv()))
            OR (vbAccessKey_Lviv = TRUE AND Object_Car.AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportKiev(), zc_Enum_Process_AccessKey_GuideKiev()))
           )
       AND (Object_Car.isErased = FALSE
        OR (Object_Car.isErased = TRUE AND inIsShowAll = TRUE))
      UNION

       SELECT 
             Object_CarExternal.Id          AS Id
           , Object_CarExternal.ObjectCode  AS Code
           , Object_CarExternal.ValueData   AS Name
           , (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_CarExternal.ValueData, '')) :: TVarChar AS NameAll
           
           , RegistrationCertificate.ValueData  AS RegistrationCertificate
           , ObjectString_Comment.ValueData     AS Comment
           
           , Object_CarModel.Id           AS CarModelId
           , Object_CarModel.ObjectCode   AS CarModelCode
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName


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

         
           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName           

           , ObjectDesc.ItemName          AS DescName
           
           , Object_CarExternal.isErased  AS isErased
           
       FROM Object AS Object_CarExternal
            
            LEFT JOIN ObjectString AS RegistrationCertificate 
                                   ON RegistrationCertificate.ObjectId = Object_CarExternal.Id 
                                  AND RegistrationCertificate.DescId = zc_ObjectString_CarExternal_RegistrationCertificate()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_CarExternal.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_CarExternal_Comment()
                                                             
            LEFT JOIN ObjectLink AS CarExternal_CarModel
                                 ON CarExternal_CarModel.ObjectId = Object_CarExternal.Id
                                AND CarExternal_CarModel.DescId = zc_ObjectLink_CarExternal_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = CarExternal_CarModel.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_CarExternal.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_CarExternal_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical 
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_CarExternal.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CarExternal_Juridical.ChildObjectId            

            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_CarExternal.DescId
     WHERE Object_CarExternal.DescId = zc_Object_CarExternal()
       AND (Object_CarExternal.isErased = FALSE
        OR (Object_CarExternal.isErased = TRUE AND inIsShowAll = TRUE))
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.17         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_CarUnion (True, '5')
