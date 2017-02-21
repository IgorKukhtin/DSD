-- Function: gpSelect_Object_MobileTariff (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MobileTariff2 (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobileTariff2(
    IN inShowAll     Boolean ,      -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Monthly TFloat
             , PocketMinutes TFloat
             , PocketSMS TFloat
             , PocketInet TFloat
             , CostSMS TFloat
             , CostMinutes TFloat
             , CostInet TFloat
             , Comment TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_MobileTariff());
     vbUserId:= lpGetUserBySession (inSession);
    
     -- Результат
     RETURN QUERY 
        SELECT 
             Object_MobileTariff.Id          AS Id
           , Object_MobileTariff.ObjectCode  AS Code
           , Object_MobileTariff.ValueData   AS Name
           
           , ObjectFloat_Monthly.ValueData         AS Monthly
           , ObjectFloat_PocketMinutes.ValueData   AS PocketMinutes

           , ObjectFloat_PocketSMS.ValueData       AS PocketSMS
           , ObjectFloat_PocketInet.ValueData      AS PocketInet
           , ObjectFloat_CostSMS.ValueData         AS CostSMS
           , ObjectFloat_CostMinutes.ValueData     AS CostMinutes
           , ObjectFloat_CostInet.ValueData        AS CostInet

           , ObjectString_Comment.ValueData        AS Comment 
         
           , Object_Contract.Id                    AS ContractId
           , Object_Contract.ObjectCode            AS ContractCode
           , Object_Contract.ValueData             AS ContractName 

           , Object_Juridical.Id                   AS JuridicalId
           , Object_Juridical.ObjectCode           AS JuridicalCode
           , Object_Juridical.ValueData            AS JuridicalName
           
           , Object_MobileTariff.isErased          AS isErased
           
       FROM Object AS Object_MobileTariff
       
            LEFT JOIN ObjectFloat AS ObjectFloat_Monthly
                                  ON ObjectFloat_Monthly.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_Monthly.DescId = zc_ObjectFloat_MobileTariff_Monthly()
            LEFT JOIN ObjectFloat AS ObjectFloat_PocketMinutes
                                  ON ObjectFloat_PocketMinutes.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_PocketMinutes.DescId = zc_ObjectFloat_MobileTariff_PocketMinutes()
            LEFT JOIN ObjectFloat AS ObjectFloat_PocketSMS
                                  ON ObjectFloat_PocketSMS.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_PocketSMS.DescId = zc_ObjectFloat_MobileTariff_PocketSMS()
            LEFT JOIN ObjectFloat AS ObjectFloat_PocketInet
                                  ON ObjectFloat_PocketInet.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_PocketInet.DescId = zc_ObjectFloat_MobileTariff_PocketInet()
            LEFT JOIN ObjectFloat AS ObjectFloat_CostSMS
                                  ON ObjectFloat_CostSMS.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_CostSMS.DescId = zc_ObjectFloat_MobileTariff_CostSMS()
            LEFT JOIN ObjectFloat AS ObjectFloat_CostMinutes
                                  ON ObjectFloat_CostMinutes.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_CostMinutes.DescId = zc_ObjectFloat_MobileTariff_CostMinutes()
            LEFT JOIN ObjectFloat AS ObjectFloat_CostInet
                                  ON ObjectFloat_CostInet.ObjectId = Object_MobileTariff.Id 
                                 AND ObjectFloat_CostInet.DescId = zc_ObjectFloat_MobileTariff_CostInet()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_MobileTariff.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_MobileTariff_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_MobileTariff_Contract
                                 ON ObjectLink_MobileTariff_Contract.ObjectId = Object_MobileTariff.Id 
                                AND ObjectLink_MobileTariff_Contract.DescId = zc_ObjectLink_MobileTariff_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_MobileTariff_Contract.ChildObjectId                               

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId                               

     WHERE Object_MobileTariff.DescId = zc_Object_MobileTariff()
       AND (Object_MobileTariff.isErased = inShowAll OR inShowAll = True)
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.17         *
 05.10.16         * parce
 23.09.16         *
*/

-- тест
--SELECT * FROM gpSelect_Object_MobileTariff2 (TRUE,zfCalc_UserAdmin())
