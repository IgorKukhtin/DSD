-- Function: gpSelect_Object_Car (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Car (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Car (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Car(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar 
             , KoeffHoursWork TFloat, PartnerMin TFloat
             , Length TFloat, Width TFloat, Height TFloat
             , Weight TFloat, Year TFloat
             , VIN TVarChar, EngineNum TVarChar
             , RegistrationCertificate TVarChar, Comment TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar, CarModelName_full TVarChar 
             , CarTypeId Integer, CarTypeCode Integer, CarTypeName TVarChar
             , BodyTypeId Integer, BodyTypeCode Integer, BodyTypeName TVarChar
             , CarPropertyId Integer, CarPropertyCode Integer, CarPropertyName TVarChar
             , ObjectColorId Integer, ObjectColorCode Integer, ObjectColorName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , FuelMasterId Integer, FuelMasterCode Integer, FuelMasterName TVarChar
             , FuelChildId Integer, FuelChildCode Integer, FuelChildName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar, AssetInvNumber TVarChar
             , isIrna Boolean
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll   Boolean;
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
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_Car.Id          AS Id
           , Object_Car.ObjectCode  AS Code
           , Object_Car.ValueData   AS Name
           , (COALESCE (Object_CarModel.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS NameAll
           
           
           , COALESCE (ObjectFloat_KoeffHoursWork.ValueData,0) :: TFloat AS KoeffHoursWork
           , COALESCE (ObjectFloat_PartnerMin.ValueData,0)     :: TFloat AS PartnerMin
           , COALESCE (ObjectFloat_Length.ValueData,0)         :: TFloat AS Length
           , COALESCE (ObjectFloat_Width.ValueData,0)          :: TFloat AS Width 
           , COALESCE (ObjectFloat_Height.ValueData,0)         :: TFloat AS Height
           , COALESCE (ObjectFloat_Weight.ValueData,0)         :: TFloat AS Weight
           , COALESCE (ObjectFloat_Year.ValueData,0)           :: TFloat  AS Year

           , ObjectString_VIN.ValueData       :: TVarChar AS VIN
           , ObjectString_EngineNum.ValueData :: TVarChar AS EngineNum
           , RegistrationCertificate.ValueData     AS RegistrationCertificate
           , ObjectString_Comment.ValueData        AS Comment
           
           , Object_CarModel.Id         AS CarModelId
           , Object_CarModel.ObjectCode AS CarModelCode
           , Object_CarModel.ValueData  AS CarModelName 
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName_full

           , Object_CarType.Id          AS CarTypeId
           , Object_CarType.ObjectCode  AS CarTypeCode
           , Object_CarType.ValueData   AS CarTypeName

           , Object_BodyType.Id         AS BodyTypeId
           , Object_BodyType.ObjectCode AS BodyTypeCode
           , Object_BodyType.ValueData  AS BodyTypeName
           
           , Object_CarProperty.Id         AS CarPropertyId
           , Object_CarProperty.ObjectCode AS CarPropertyCode
           , Object_CarProperty.ValueData  AS CarPropertyName
           
           , Object_ObjectColor.Id         AS ObjectColorId
           , Object_ObjectColor.ObjectCode AS ObjectColorCode
           , Object_ObjectColor.ValueData  AS ObjectColorName          
         
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
           
           , Object_Asset.Id                  AS AssetId
           , Object_Asset.ObjectCode          AS AssetCode
           , Object_Asset.ValueData           AS AssetName    
           , ObjectString_InvNumber.ValueData AS AssetInvNumber

           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna
           , Object_Car.isErased      AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_Car
                              ON Object_Car.isErased = tmpIsErased.isErased 
                             AND Object_Car.DescId = zc_Object_Car()
     
            LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Car.AccessKeyId
       
            LEFT JOIN ObjectString AS RegistrationCertificate 
                                   ON RegistrationCertificate.ObjectId = Object_Car.Id 
                                  AND RegistrationCertificate.DescId = zc_ObjectString_Car_RegistrationCertificate()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Car.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Car_Comment()

            LEFT JOIN ObjectString AS ObjectString_VIN
                                   ON ObjectString_VIN.ObjectId = Object_Car.Id
                                  AND ObjectString_VIN.DescId = zc_ObjectString_Car_VIN()

            LEFT JOIN ObjectString AS ObjectString_EngineNum
                                   ON ObjectString_EngineNum.ObjectId = Object_Car.Id
                                  AND ObjectString_EngineNum.DescId = zc_ObjectString_Car_EngineNum()

            LEFT JOIN ObjectFloat AS ObjectFloat_KoeffHoursWork
                                  ON ObjectFloat_KoeffHoursWork.ObjectId = Object_Car.Id
                                 AND ObjectFloat_KoeffHoursWork.DescId = zc_ObjectFloat_Car_KoeffHoursWork()

            LEFT JOIN ObjectFloat AS ObjectFloat_PartnerMin
                                  ON ObjectFloat_PartnerMin.ObjectId = Object_Car.Id
                                 AND ObjectFloat_PartnerMin.DescId = zc_ObjectFloat_Car_PartnerMin()

            LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                  ON ObjectFloat_Length.ObjectId = Object_Car.Id
                                 AND ObjectFloat_Length.DescId = zc_ObjectFloat_Car_Length()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                  ON ObjectFloat_Width.ObjectId = Object_Car.Id
                                 AND ObjectFloat_Width.DescId = zc_ObjectFloat_Car_Width()
            LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                  ON ObjectFloat_Height.ObjectId = Object_Car.Id
                                 AND ObjectFloat_Height.DescId = zc_ObjectFloat_Car_Height()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Car.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Car_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Year
                                  ON ObjectFloat_Year.ObjectId = Object_Car.Id
                                 AND ObjectFloat_Year.DescId = zc_ObjectFloat_Car_Year()

            LEFT JOIN ObjectLink AS Car_CarModel
                                 ON Car_CarModel.ObjectId = Object_Car.Id
                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS Car_CarType
                                 ON Car_CarType.ObjectId = Object_Car.Id
                                AND Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS Car_BodyType
                                 ON Car_BodyType.ObjectId = Object_Car.Id
                                AND Car_BodyType.DescId = zc_ObjectLink_Car_BodyType()
            LEFT JOIN Object AS Object_BodyType ON Object_BodyType.Id = Car_BodyType.ChildObjectId

            LEFT JOIN ObjectLink AS Car_CarProperty
                                 ON Car_CarProperty.ObjectId = Object_Car.Id
                                AND Car_CarProperty.DescId = zc_ObjectLink_Car_CarProperty()
            LEFT JOIN Object AS Object_CarProperty ON Object_CarProperty.Id = Car_CarProperty.ChildObjectId

            LEFT JOIN ObjectLink AS Car_ObjectColor
                                 ON Car_ObjectColor.ObjectId = Object_Car.Id
                                AND Car_ObjectColor.DescId = zc_ObjectLink_Car_ObjectColor()
            LEFT JOIN Object AS Object_ObjectColor ON Object_ObjectColor.Id = Car_ObjectColor.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                 ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_Car_PersonalDriver.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster 
                                 ON ObjectLink_Car_FuelMaster.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
            LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_FuelChild
                                 ON ObjectLink_Car_FuelChild.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_FuelChild.DescId = zc_ObjectLink_Car_FuelChild()
            LEFT JOIN Object AS Object_FuelChild ON Object_FuelChild.Id = ObjectLink_Car_FuelChild.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical
                                 ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Car_Juridical.ChildObjectId    
           -- информативно
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ChildObjectId = Object_Car.Id
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = ObjectLink_Asset_Car.ObjectId        

            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Asset.Id
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_Car.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

     WHERE (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll = TRUE OR Object_Unit.Id = 8395 -- 21000 Транспорт - сбыт
         OR (vbAccessKey_Kiev = TRUE AND Object_Car.AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportLviv(), zc_Enum_Process_AccessKey_GuideLviv()))
         OR (vbAccessKey_Lviv = TRUE AND Object_Car.AccessKeyId IN (zc_Enum_Process_AccessKey_TrasportKiev(), zc_Enum_Process_AccessKey_GuideKiev()))
           )
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Car(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
 17.07.23         *
 04.05.22         *
 07.12.21         *
 02.11.21         *
 05.10.21         *
 27.04.21         * PartnerMin
 30.11.16         * add inShowAll
 28.11.16         * add Asset
 17.12.14         * add Juridical
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
-- 
SELECT * FROM gpSelect_Object_Car (false , zfCalc_UserAdmin())
