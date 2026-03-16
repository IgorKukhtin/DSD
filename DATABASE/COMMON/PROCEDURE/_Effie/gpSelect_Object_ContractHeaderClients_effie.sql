-- Function: gpSelect_Object_ContractHeaderClients_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ContractHeaderClients_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractHeaderClients_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
             , clientExtId          TVarChar   -- Идентификатор контрагента
             , isDefault            Boolean    -- true - контракт по умолчанию, false - обычный контракт
             , isDeleted            Boolean    -- Признак активности
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     RETURN QUERY
     WITH 
     tmpObject_Contract_View AS (SELECT *
                                 FROM Object_Contract_View
                                 WHERE Object_Contract_View.isErased = FALSE 
                                       AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() 
                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                 )
         

   -- Результат
   SELECT DISTINCT
         Object_Contract_View.ContractId   ::TVarChar AS contractHeaderExtId
       , Object_Partner.Id                 ::TVarChar AS clientExtId
       , TRUE                              ::Boolean  AS isDefault
       , FALSE                             ::Boolean  AS isDeleted
  
   FROM Object AS Object_Partner
         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                              ON ObjectLink_ContractPartner_Partner.ChildObjectId = Object_Partner.Id
                             AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
         LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                   AND Object_ContractPartner.isErased = FALSE
         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                              ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                             AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

         INNER JOIN tmpObject_Contract_View AS Object_Contract_View
                                            ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND Object_Partner.isErased = FALSE
     AND (Object_Contract_View.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId)
 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractHeaderClients_effie (zfCalc_UserAdmin()::TVarChar);