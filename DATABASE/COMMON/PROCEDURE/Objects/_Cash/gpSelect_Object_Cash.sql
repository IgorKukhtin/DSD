-- Function: gpSelect_Object_Cash()

-- DROP FUNCTION gpSelect_Object_Cash();

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyName TVarChar, BranchName TVarChar, JuridicalName TVarChar, 
               BusinessName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   RETURN QUERY 
   SELECT 
     Object.Id          AS Id 
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , Currency.ValueData AS CurrencyName
   , Branch.ValueData   AS BranchName
   , MainJuridical.ValueData  AS JuridicalName
   , Business.ValueData AS BusinessName

   FROM Object
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object.AccessKeyId
        LEFT JOIN ObjectLink 
               ON ObjectLink.ObjectId = Object.Id
              AND ObjectLink.DescId = zc_ObjectLink_Cash_Currency()
        LEFT JOIN Object AS Currency
                         ON Currency.Id = ObjectLink.ChildObjectId
        LEFT JOIN ObjectLink AS Cash_Branch
                             ON Cash_Branch.ObjectId = Object.Id
                            AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
           LEFT JOIN Object AS Branch ON Branch.Id = Cash_Branch.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_MainJuridical
                                ON Cash_MainJuridical.ObjectId = Object.Id
                               AND Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical()
           LEFT JOIN Object AS MainJuridical ON MainJuridical.Id = Cash_MainJuridical.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_Business
                                ON Cash_Business.ObjectId = Object.Id
                               AND Cash_Business.DescId = zc_ObjectLink_Cash_Business()
           LEFT JOIN Object AS Business ON Business.Id = Cash_Business.ChildObjectId
   WHERE Object.DescId = zc_Object_Cash()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Cash (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.11.13                                        * Cyr1251
 10.05.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash('2')