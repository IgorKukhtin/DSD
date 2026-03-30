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
          tmpClient AS (SELECT DISTINCT gpSelect.PartnerId FROM gpSelect_Object_ContractPrices_effie (inSession) AS gpSelect)
        , tmpContract AS (SELECT DISTINCT gpSelect.extId FROM gpSelect_Object_ContractHeaders_effie (inSession) AS gpSelect)
        , tmpContract_Client AS (SELECT DISTINCT
                                        gpSelect.contractHeaderExtId
                                      , gpSelect.PartnerId AS clientExtId
                                 FROM gpSelect_Object_ContractPrices_effie (inSession) AS gpSelect
                                 WHERE gpSelect.PartnerId IN (SELECT tmpClient.PartnerId FROM tmpClient)
                                   AND gpSelect.contractHeaderExtId IN (SELECT tmpContract.extId FROM tmpContract)
                                )
     -- Результат
     SELECT DISTINCT
           tmpContract_Client.contractHeaderExtId  ::TVarChar AS contractHeaderExtId
         , tmpContract_Client.clientExtId          ::TVarChar AS clientExtId
         , TRUE                                    ::Boolean  AS isDefault
         , FALSE                                   ::Boolean  AS isDeleted

     FROM tmpContract_Client
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
