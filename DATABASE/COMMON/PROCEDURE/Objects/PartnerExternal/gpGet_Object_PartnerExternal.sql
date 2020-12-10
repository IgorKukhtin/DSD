-- Function: gpGet_Object_PartnerExternal (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PartnerExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartnerExternal(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , ObjectCode TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PartnerRealId Integer, PartnerRealName TVarChar
             , ContractId Integer, ContractName TVarChar
             , RetailId Integer, RetailName TVarChar
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PartnerExternal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PartnerExternal()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST ('' as TVarChar)  AS ObjectCode

           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS PartnerRealId
           , CAST ('' as TVarChar)  AS PartnerRealName

           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName 

           , CAST (0 as Integer)    AS RetailId
           , CAST ('' as TVarChar)  AS RetailName
           ;
   ELSE
       RETURN QUERY 
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
       FROM Object AS Object_PartnerExternal
       
            LEFT JOIN ObjectString AS ObjectString_ObjectCode
                                   ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id 
                                  AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()

            LEFT JOIN ObjectLink AS ObjectLink_Partner
                                 ON ObjectLink_Partner.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner.ChildObjectId                               

            LEFT JOIN ObjectLink AS ObjectLink_PartnerReal
                                 ON ObjectLink_PartnerReal.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_PartnerReal.DescId = zc_ObjectLink_PartnerExternal_PartnerReal()
            LEFT JOIN Object AS Object_PartnerReal ON Object_PartnerReal.Id = ObjectLink_PartnerReal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract
                                 ON ObjectLink_Contract.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_Contract.DescId = zc_ObjectLink_PartnerExternal_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Retail
                                 ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId

       WHERE Object_PartnerExternal.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.20         *       
*/

-- тест
-- SELECT * FROM gpGet_Object_PartnerExternal (0, inSession := '5')
