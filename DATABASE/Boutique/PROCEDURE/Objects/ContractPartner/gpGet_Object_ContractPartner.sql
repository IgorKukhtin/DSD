-- Function: gpGet_Object_ContractPartner (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContractPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractPartner(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractPartner());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractPartner()) AS Code
          
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName  

           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractPartner.Id          AS Id
           , Object_ContractPartner.ObjectCode  AS Code

           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS ContractName

           , Object_Partner.Id          AS PartnerId
           , Object_Partner.ValueData   AS PartnerName

           , Object_ContractPartner.isErased AS isErased
           
       FROM Object AS Object_ContractPartner
       
            LEFT JOIN ObjectLink AS ContractPartner_Contract
                                 ON ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                AND ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ContractPartner_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                 ON ObjectLink_ContractPartner_Partner.ObjectId = Object_ContractPartner.Id
                                AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId
                                           
       WHERE Object_ContractPartner.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_ContractPartner (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.15         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractPartner (0, inSession := '5')
