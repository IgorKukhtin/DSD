-- Function: gpSelect_Object_Cash()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyId Integer, CurrencyName TVarChar, 
               BranchId Integer, BranchName TVarChar,
               JuridicalName TVarChar, 
               BusinessName TVarChar, 
               PaidKindName TVarChar,
               isNotCurrencyDiff Boolean
               )
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
        , Currency.Id        AS CurrencyId
        , Currency.ValueData AS CurrencyName
        , Branch.Id          AS BranchId
        , Branch.ValueData   AS BranchName
        , JuridicalBasis.ValueData  AS JuridicalName
        , Business.ValueData AS BusinessName
        , PaidKind.ValueData AS PaidKindName
        , COALESCE (ObjectBoolean_notCurrencyDiff.ValueData, FALSE) ::Boolean AS isNotCurrencyDiff    

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
          
        LEFT JOIN ObjectLink AS Cash_JuridicalBasis
                             ON Cash_JuridicalBasis.ObjectId = Object.Id
                            AND Cash_JuridicalBasis.DescId = zc_ObjectLink_Cash_JuridicalBasis()
        LEFT JOIN Object AS JuridicalBasis ON JuridicalBasis.Id = Cash_JuridicalBasis.ChildObjectId
           
        LEFT JOIN ObjectLink AS Cash_Business
                             ON Cash_Business.ObjectId = Object.Id
                            AND Cash_Business.DescId = zc_ObjectLink_Cash_Business()
        LEFT JOIN Object AS Business ON Business.Id = Cash_Business.ChildObjectId
           
        LEFT JOIN ObjectLink AS Cash_PaidKind
                             ON Cash_PaidKind.ObjectId = Object.Id
                            AND Cash_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
        LEFT JOIN Object AS PaidKind ON PaidKind.Id = Cash_PaidKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_notCurrencyDiff
                                ON ObjectBoolean_notCurrencyDiff.ObjectId = Object.Id
                               AND ObjectBoolean_notCurrencyDiff.DescId = zc_ObjectBoolean_Cash_notCurrencyDiff()                      
   WHERE Object.DescId = zc_Object_Cash()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Cash (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.24         *
 25.11.14         * add PaidKind               
 28.12.13                                        * rename to zc_ObjectLink_Cash_JuridicalBasis
 24.12.13                                        * Cyr1251
 10.05.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash (zfCalc_UserAdmin())
