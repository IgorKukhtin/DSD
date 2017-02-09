-- Function: gpGet_Object_MobileTariff (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MobileTariff2 (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_MobileTariff2(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
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
             , ContractId Integer, ContractName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MobileTariff());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MobileTariff()) AS Code
        
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as TFloat)     AS Monthly
           , CAST (0 as TFloat)     AS PocketMinutes
           , CAST (0 as TFloat)     AS PocketSMS
           , CAST (0 as TFloat)     AS PocketInet
           , CAST (0 as TFloat)     AS CostSMS
           , CAST (0 as TFloat)     AS CostMinutes
           , CAST (0 as TFloat)     AS CostInet

           , CAST ('' as TVarChar)  AS Comment
    
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName

           , CAST (NULL AS Boolean) AS isErased
;
   ELSE
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
           , Object_Contract.ValueData             AS ContractName 
           
           , Object_MobileTariff.isErased    AS isErased
           
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

       WHERE Object_MobileTariff.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.16         * parce
 23.09.16         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MobileTariff2 (0,  inPartnerId:= 83665 , inMobileTariffKindId := 153273 ,  inSession := '5')
