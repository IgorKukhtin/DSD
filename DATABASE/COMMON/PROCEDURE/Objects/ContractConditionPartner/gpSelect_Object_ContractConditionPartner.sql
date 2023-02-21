-- Function: gpSelect_Object_ContractConditionPartner (TVarChar)

--DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionPartner (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionPartner (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionPartner(
    IN inContractId  Integer,
    IN inJuridicalId Integer,
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractConditionId Integer, ContractConditionCode Integer, ContractConditionName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , Address TVarChar
             , isConnected Boolean
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractConditionPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH
     tmpCCP AS (SELECT 
                      Object_ContractConditionPartner.Id          AS Id
                    , Object_ContractConditionPartner.ObjectCode  AS Code
         
                    , Object_ContractCondition.Id                 AS ContractConditionId
                    , Object_ContractCondition.ObjectCode         AS ContractConditionCode
                    , Object_ContractCondition.ValueData          AS ContractConditionName
         
                    , Object_Partner.Id                           AS PartnerId
                    , Object_Partner.ObjectCode                   AS PartnerCode
                    , Object_Partner.ValueData                    AS PartnerName
                    , ObjectString_Address.ValueData              AS Address
                    , NOT Object_ContractConditionPartner.isErased AS isConnected
                    , Object_ContractConditionPartner.isErased    AS isErased
                    
                FROM Object AS Object_ContractConditionPartner
                                                                     
                     LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                          ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                         AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
                     LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId
                     
                     LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                          ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                         AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                     LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractConditionPartner_Partner.ChildObjectId
         
                     LEFT JOIN ObjectString AS ObjectString_Address
                                            ON ObjectString_Address.ObjectId = Object_Partner.Id
                                           AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
         
              WHERE Object_ContractConditionPartner.DescId = zc_Object_ContractConditionPartner()
                )

 , tmpPartner AS (SELECT Object_ContractCondition.Id                 AS ContractConditionId
                       , Object_ContractCondition.ObjectCode         AS ContractConditionCode
                       , Object_ContractCondition.ValueData          AS ContractConditionName
            
                       , Object_Partner.Id                           AS PartnerId
                       , Object_Partner.ObjectCode                   AS PartnerCode
                       , Object_Partner.ValueData                    AS PartnerName
                       , ObjectString_Address.ValueData              AS Address
                       , FALSE                                       AS isConnected
                       , FALSE                                       AS isErased
                       
                   FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                         INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                        
                         INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                              AND ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId
            
                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId 
            
                         LEFT JOIN ObjectString AS ObjectString_Address
                                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
            
                   WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                     AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                     AND inisShowAll = TRUE
                  )

       SELECT 
             Object_ContractConditionPartner.Id
           , Object_ContractConditionPartner.Code

           , Object_ContractConditionPartner.ContractConditionId
           , Object_ContractConditionPartner.ContractConditionCode
           , Object_ContractConditionPartner.ContractConditionName

           , Object_ContractConditionPartner.PartnerId
           , Object_ContractConditionPartner.PartnerCode
           , Object_ContractConditionPartner.PartnerName
           , Object_ContractConditionPartner.Address
           , Object_ContractConditionPartner.isConnected
           , Object_ContractConditionPartner.isErased
           
       FROM tmpCCP AS Object_ContractConditionPartner
   --показать всех контрагентов для Договора и юр.лица
   UNION
       SELECT 
             0          AS Id
           , 0          AS Code

           , Object_Partner.ContractConditionId
           , Object_Partner.ContractConditionCode
           , Object_Partner.ContractConditionName

           , Object_Partner.PartnerId
           , Object_Partner.PartnerCode
           , Object_Partner.PartnerName
           , Object_Partner.Address
           , Object_Partner.isConnected
           , Object_Partner.isErased
           
       FROM tmpPartner AS Object_Partner 
             LEFT JOIN tmpCCP AS Object_ContractConditionPartner ON Object_ContractConditionPartner.ContractConditionId = Object_Partner.ContractConditionId
                                                                AND Object_ContractConditionPartner.PartnerId = Object_Partner.PartnerId
       WHERE Object_ContractConditionPartner IS NULL
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.23         *
 23.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractConditionPartner (5893128, 15158, true, zfCalc_UserAdmin())-- where PartnerId = 17665
-- SELECT * FROM gpSelect_Object_ContractConditionPartner ( zfCalc_UserAdmin())

--select * from gpInsertUpdate_Object_ContractConditionPartner(ioId := 0 , inCode := 0 , inContractConditionId := 5501738 , inPartnerId := 877148 ,  inSession := '9457');