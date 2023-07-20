-- Function: gpSelect_Object_CardFuel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CardFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CardFuel(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LimitMoney TFloat, LimitFuel TFloat
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , PaidKindId Integer, PaidKindCode Integer, PaidKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , CardFuelKindId Integer, CardFuelKindName TVarChar
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_CardFuel());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- Результат
   RETURN QUERY 
       SELECT
             Object_CardFuel.Id         AS Id
           , Object_CardFuel.ObjectCode AS Code
           , Object_CardFuel.ValueData  AS NAME
                      
           , ObjectFloat_CardFuel_Limit.ValueData      AS LimitMoney
           , ObjectFloat_CardFuel_LimitFuel.ValueData  AS LimitFuel

           , View_PersonalDriver.PersonalId   AS PersonalDriverId 
           , View_PersonalDriver.PersonalCode AS PersonalDriverCode
           , View_PersonalDriver.PersonalName AS PersonalDriverName

           , Object_Car.Id         AS CarId 
           , Object_Car.ObjectCode AS CarCode
           , Object_Car.ValueData  AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           
           , Object_PaidKind.Id         AS PaidKindId 
           , Object_PaidKind.ObjectCode AS PaidKindCode
           , Object_PaidKind.ValueData  AS PaidKindName
                       
           , Object_Juridical.Id         AS JuridicalId 
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Goods.Id         AS GoodsId 
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName    
           
           , Object_CardFuelKind.Id        AS CardFuelKindId
           , Object_CardFuelKind.ValueData AS CardFuelKindName
            
           , Object_CardFuel.isErased   AS isErased
           
       FROM Object AS Object_CardFuel
            LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_CardFuel.AccessKeyId

            LEFT JOIN ObjectFloat AS ObjectFloat_CardFuel_Limit ON ObjectFloat_CardFuel_Limit.ObjectId = Object_CardFuel.Id
                                                               AND ObjectFloat_CardFuel_Limit.DescId = zc_ObjectFloat_CardFuel_Limit()
            LEFT JOIN ObjectFloat AS ObjectFloat_CardFuel_LimitFuel ON ObjectFloat_CardFuel_LimitFuel.ObjectId = Object_CardFuel.Id
                                                                   AND ObjectFloat_CardFuel_LimitFuel.DescId = zc_ObjectFloat_CardFuel_LimitFuel()

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PersonalDriver ON ObjectLink_CardFuel_PersonalDriver.ObjectId = Object_CardFuel.Id
                                                                      AND ObjectLink_CardFuel_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = ObjectLink_CardFuel_PersonalDriver.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Car ON ObjectLink_CardFuel_Car.ObjectId = Object_CardFuel.Id
                                                           AND ObjectLink_CardFuel_Car.DescId = zc_ObjectLink_CardFuel_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_CardFuel_Car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PaidKind ON ObjectLink_CardFuel_PaidKind.ObjectId = Object_CardFuel.Id
                                                                AND ObjectLink_CardFuel_PaidKind.DescId = zc_ObjectLink_CardFuel_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_CardFuel_PaidKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                                 AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Goods ON ObjectLink_CardFuel_Goods.ObjectId = Object_CardFuel.Id
                                                             AND ObjectLink_CardFuel_Goods.DescId = zc_ObjectLink_CardFuel_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_CardFuel_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_CardFuelKind
                                 ON ObjectLink_CardFuel_CardFuelKind.ObjectId = Object_CardFuel.Id
                                AND ObjectLink_CardFuel_CardFuelKind.DescId = zc_ObjectLink_CardFuel_CardFuelKind()
            LEFT JOIN Object AS Object_CardFuelKind ON Object_CardFuelKind.Id = ObjectLink_CardFuel_CardFuelKind.ChildObjectId

   WHERE Object_CardFuel.DescId = zc_Object_CardFuel()
     -- AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CardFuel (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.21         * add CardFuelKindName
 14.01.16         * add LimitFuel
 02.09.14                                        * rem AccessKey...
 14.12.13                                        * add vbAccessKeyAll
 14.12.13                                        * add CardFuelLimit
 18.10.13                                        * add CarModelName
 14.10.13         *
*/
/*
UPDATE Object SET AccessKeyId = CASE WHEN ObjectLink.ChildObjectId IS NOT NULL THEN COALESCE (Object_Branch.AccessKeyId, zc_Enum_Process_AccessKey_TrasportDnepr()) END FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = ObjectLink.ChildObjectId AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit() LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink_Car_Unit.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_CardFuel_Car() AND Object.DescId = zc_Object_CardFuel();
*/
-- тест
-- SELECT * FROM gpSelect_Object_CardFuel (zfCalc_UserAdmin())
