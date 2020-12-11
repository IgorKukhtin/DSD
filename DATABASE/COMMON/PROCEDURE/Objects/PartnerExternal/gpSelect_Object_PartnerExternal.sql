-- Function: gpSelect_Object_PartnerExternal (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerExternal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerExternal(
    IN inShowAll     Boolean  ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , ObjectCode TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PartnerRealId Integer, PartnerRealName TVarChar
             , ContractId Integer, ContractName TVarChar
             , RetailId Integer, RetailName TVarChar
             , RetailName_partner TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartnerExternal());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
     WITH
     tmpPartnerExternal AS (SELECT *
                            FROM Object AS Object_PartnerExternal
                            WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
                             AND (Object_PartnerExternal.isErased = inShowAll OR inShowAll = TRUE)
                            )
   , tmpObjectString AS (SELECT ObjectString.*
                         FROM ObjectString
                         WHERE ObjectString.DescId = zc_ObjectString_PartnerExternal_ObjectCode()
                           AND ObjectString.ObjectId IN (SELECT DISTINCT tmpPartnerExternal.Id FROM tmpPartnerExternal)
                         )
   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpPartnerExternal.Id FROM tmpPartnerExternal)
                         AND ObjectLink.DescId IN (zc_ObjectLink_PartnerExternal_Partner()
                                                 , zc_ObjectLink_PartnerExternal_PartnerReal()
                                                 , zc_ObjectLink_PartnerExternal_Contract()
                                                 , zc_ObjectLink_PartnerExternal_Retail()
                                                  )
                       )   
   , tmpObjectLinkJur AS (SELECT ObjectLink.*
                          FROM ObjectLink
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpObjectLink.ChildObjectId FROM tmpObjectLink WHERE tmpObjectLink.DescId=zc_ObjectLink_PartnerExternal_Partner() )
                            AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                          )
   , tmpObjectLinkRet AS (SELECT ObjectLink.*
                          FROM ObjectLink
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpObjectLinkJur.ChildObjectId FROM tmpObjectLinkJur)
                            AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()
                          )
   
       SELECT 
             Object_PartnerExternal.Id          AS Id
           , Object_PartnerExternal.ObjectCode  AS Code
           , Object_PartnerExternal.ValueData   AS Name
           
           , ObjectString_ObjectCode.ValueData  AS ObjectCode

           , Object_Partner.Id                  AS PartnerId
           , Object_Partner.ValueData           AS PartnerName
           , Object_PartnerReal.Id              AS PartnerRealId
           , Object_PartnerReal.ValueData       AS PartnerRealName
           , Object_Contract.Id                 AS ContractId
           , Object_Contract.ValueData          AS ContractName
           , Object_Retail.Id                   AS RetailId
           , Object_Retail.ValueData            AS RetailName

           , Object_Retail_Partner.ValueData    AS RetailName_partner
           , Object_Juridical.Id                AS JuridicalId
           , Object_Juridical.ValueData         AS JuridicalName

           , Object_PartnerExternal.isErased    AS isErased

       FROM tmpPartnerExternal AS Object_PartnerExternal
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_PartnerExternal.AccessKeyId
       
            LEFT JOIN tmpObjectString AS ObjectString_ObjectCode
                                   ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id 
                                  AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()

            LEFT JOIN tmpObjectLink AS ObjectLink_Partner
                                    ON ObjectLink_Partner.ObjectId = Object_PartnerExternal.Id 
                                   AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner.ChildObjectId

            LEFT JOIN tmpObjectLink AS ObjectLink_PartnerReal
                                    ON ObjectLink_PartnerReal.ObjectId = Object_PartnerExternal.Id 
                                   AND ObjectLink_PartnerReal.DescId = zc_ObjectLink_PartnerExternal_PartnerReal()
            LEFT JOIN Object AS Object_PartnerReal ON Object_PartnerReal.Id = ObjectLink_PartnerReal.ChildObjectId

            LEFT JOIN tmpObjectLink AS ObjectLink_Contract
                                    ON ObjectLink_Contract.ObjectId = Object_PartnerExternal.Id 
                                   AND ObjectLink_Contract.DescId = zc_ObjectLink_PartnerExternal_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract.ChildObjectId

            LEFT JOIN tmpObjectLink AS ObjectLink_Retail
                                    ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id 
                                   AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId

            LEFT JOIN tmpObjectLinkJur AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN tmpObjectLinkRet AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail_Partner ON Object_Retail_Partner.Id = ObjectLink_Juridical_Retail.ChildObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.12.20         * PartnerRealName
 30.10.20         *       
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartnerExternal (False, zfCalc_UserAdmin())
