-- Function: gpSelect_Object_ContractPartner (TVarChar)

--DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartner (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartner (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartner(
    IN inIsShowAll   Boolean,   -- из договоров передавать всегда TRUE т.е. показывается все, на FALSE показать только договора, где есть и isConnected = TRUE и isConnected = FALSE, т.е. если к договору подвязана только часть контрагентов
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractCode Integer, InvNumber TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , Address TVarChar
             , isConnected Boolean
             , isErased Boolean
        
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY   
     WITH
     tmpContractPartner AS (SELECT 
                                   Object_ContractPartner.Id          AS Id
                                 , Object_ContractPartner.ObjectCode  AS Code
                               
                                 , View_Contract.ContractId
                                 , View_Contract.ContractCode
                                 , View_Contract.InvNumber
                      
                                 , Object_Partner.Id           AS PartnerId
                                 , Object_Partner.ObjectCode   AS PartnerCode
                                 , Object_Partner.ValueData    AS PartnerName
                                 , Object_Juridical.Id         AS JuridicalId
                                 , Object_Juridical.ObjectCode AS JuridicalCode
                                 , Object_Juridical.ValueData  AS JuridicalName
                                 
                                 , ObjectString_Address.ValueData      AS Address
                      
                                 , NOT Object_ContractPartner.isErased AS isConnected
                                 , Object_ContractPartner.isErased     AS isErased 
                                 
                             FROM Object AS Object_ContractPartner
                                                                                  
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                      AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                  LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId
                                  
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                       ON ObjectLink_ContractPartner_Partner.ObjectId = Object_ContractPartner.Id
                                                      AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                  LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId
                      
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                      
                                  LEFT JOIN ObjectString AS ObjectString_Address
                                                         ON ObjectString_Address.ObjectId = Object_Partner.Id
                                                        AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
                      
                           WHERE Object_ContractPartner.DescId = zc_Object_ContractPartner() 
                         UNION ALL
                           SELECT 
                                 0 :: Integer  AS Id
                               , 0 :: Integer  AS Code
                    
                               , View_Contract.ContractId
                               , View_Contract.ContractCode
                               , View_Contract.InvNumber
                    
                               , Object_Partner.Id               AS PartnerId
                               , Object_Partner.ObjectCode       AS PartnerCode
                               , Object_Partner.ValueData        AS PartnerName
                    
                               , Object_Juridical.Id         AS JuridicalId
                               , Object_Juridical.ObjectCode AS JuridicalCode
                               , Object_Juridical.ValueData  AS JuridicalName
                    
                               , ObjectString_Address.ValueData  AS Address
                    
                               , FALSE                           AS isConnected
                               , Object_Partner.isErased         AS isErased
                    
                           FROM Object AS Object_Partner
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                    
                                LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                    
                                /*LEFT JOIN Object_ContractPartner_View AS View_ContractPartner
                                                                      ON View_ContractPartner.PartnerId  = Object_Partner.Id
                                                                     AND View_ContractPartner.ContractId = View_Contract.ContractId*/
                    
                                LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                     ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                                                    AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                    
                                LEFT JOIN ObjectString AS ObjectString_Address
                                                       ON ObjectString_Address.ObjectId = Object_Partner.Id
                                                      AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
                           WHERE Object_Partner.DescId = zc_Object_Partner()
                             AND Object_Partner.isErased = FALSE
                             /*AND View_ContractPartner.ContractId IS NULL*/
                             AND ObjectLink_ContractPartner_Partner.ChildObjectId IS NULL   
                           )
   , tmpCount AS (SELECT tmpContractPartner.ContractId
                       , tmpContractPartner.JuridicalId
                       , COUNT (DISTINCT tmpContractPartner.isConnected) AS CountParam
                  FROM tmpContractPartner                                     
                  GROUP BY tmpContractPartner.ContractId
                         , tmpContractPartner.JuridicalId
                  )


       SELECT 
             tmpContractPartner.Id
           , tmpContractPartner.Code
         
           , tmpContractPartner.ContractId
           , tmpContractPartner.ContractCode
           , tmpContractPartner.InvNumber

           , tmpContractPartner.PartnerId
           , tmpContractPartner.PartnerCode
           , tmpContractPartner.PartnerName
           , tmpContractPartner.JuridicalCode
           , tmpContractPartner.JuridicalName
           
       
           , tmpContractPartner.Address

           , tmpContractPartner.isConnected
           , tmpContractPartner.isErased
           
       FROM tmpContractPartner
                                                            
            INNER JOIN tmpCount ON tmpCount.ContractId = tmpContractPartner.ContractId
                              AND tmpCount.JuridicalId = tmpContractPartner.JuridicalId
                              AND (tmpCount.CountParam = 2 OR inIsShowAll = TRUE)  --показываем только договора где не все контрагенты подключены
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_ContractPartner (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.24         *
 08.05.17         *
 05.02.15         * 
*/

/*
CREATE TABLE _tmpContractPartner_22_03_22 (
   Id                    INTEGER NOT NULL, 
   ContractId                INTEGER NOT NULL, 
   PartnerId              Integer NOT NULL, 
   isErased         Boolean
     
);

insert into _tmpContractPartner_22_03_22 (Id, ContractId, PartnerId, isErased)
       SELECT 
             Object_ContractPartner.Id          AS Id
         
           , COALESCE (View_Contract.ContractId, 0) as ContractId
--           , View_Contract.*

           , COALESCE (Object_Partner.Id, 0)         AS PartnerId
       
           , Object_ContractPartner.isErased     AS isErased
           
       FROM Object AS Object_ContractPartner
                                                            
            LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                 ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                 ON ObjectLink_ContractPartner_Partner.ObjectId = Object_ContractPartner.Id
                                AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId


     WHERE Object_ContractPartner.DescId = zc_Object_ContractPartner()
*/
-- тест
-- SELECT * FROM gpSelect_Object_ContractPartner (TRUE,zfCalc_UserAdmin())
