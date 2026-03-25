-- Function: gpSelect_Object_PriceForTwin_effie
 
DROP FUNCTION IF EXISTS gpSelect_Object_PriceForTwin_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceForTwin_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId                 TVarChar   -- Идентификатор перевязки прайс-торговая точка-клиент
             , clientExtID           TVarChar   -- Идентификатор клиента
             , priceHeaderExtId      TVarChar   -- Идентификатор прайса
             , ttExtID               TVarChar   -- Идентификатор торговой точки
             , employeeExtId         TVarChar   -- Идентификатор сотрудника 
             , defaultPrice          Boolean    -- true - прайс по умолчанию / false - обычный
             , isDeleted             Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна. 
             
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmp_tt AS (SELECT DISTINCT gpSelect.ttExtId, gpSelect.clientExtId FROM gpSelect_Object_Twins_effie('') AS gpSelect)
        , tmp_Contract AS (SELECT DISTINCT gpSelect.extId FROM gpSelect_Object_ContractHeaders_effie (inSession) AS gpSelect)
     --
     SELECT DISTINCT
            tmp.contractHeaderExtId          ::TVarChar AS extId
          , tmp.PartnerId                    ::TVarChar AS clientExtID
          , tmp.priceHeaderExtId             ::TVarChar AS priceHeaderExtId
          , tmp_tt.ttExtId                   ::TVarChar AS ttExtId
          , NULL                             ::TVarChar AS employeeExtId
          , tmp.defaultPrice                 ::Boolean  AS defaultPrice
          , FALSE                            ::Boolean  AS isDeleted
     FROM gpSelect_Object_ContractPrices_effie (inSession) AS tmp
          INNER JOIN tmp_tt       ON tmp_tt.clientExtId = tmp.PartnerId           :: TVarChar
          INNER JOIN tmp_Contract ON tmp_Contract.ExtId = tmp.contractHeaderExtId :: TVarChar
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar) where extId not in (SELECT ExtId FROM gpSelect_Object_ContractHeaders_effie (zfCalc_UserAdmin()::TVarChar) where isDeleted = FALSE)
-- SELECT * FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar) where clientExtID not in (SELECT ExtId FROM gpSelect_Object_clients_effie (zfCalc_UserAdmin()::TVarChar) where isDeleted = FALSE)
-- SELECT * FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar) where ttExtId not in (SELECT ExtId FROM gpSelect_Object_TT_effie (zfCalc_UserAdmin()::TVarChar) where isDeleted = 0)

-- тест
-- SELECT * FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar);
