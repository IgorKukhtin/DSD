-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpGetDescSets (TVarChar);

CREATE OR REPLACE FUNCTION gpGetDescSets(
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (IncomeDesc TVarChar, ReturnOutDesc TVarChar, SaleDesc TVarChar, SaleRealDesc TVarChar, ReturnInDesc TVarChar, ReturnInRealDesc TVarChar
             , MoneyDesc TVarChar , ServiceDesc TVarChar, TransferDebtDesc TVarChar, SendDebtDesc TVarChar
             , OtherDesc TVarChar, PriceCorrectiveDesc TVarChar, ServiceRealDesc TVarChar, ChangeCurrencyDesc TVarChar)
AS
$BODY$
BEGIN

     RETURN QUERY
       SELECT
          zc_Movement_Income()::TVarChar    AS IncomeDesc
        , zc_Movement_ReturnOut()::TVarChar AS ReturnOutDesc
        , (zc_Movement_Sale() :: TVarChar || ';' || zc_Movement_TransferDebtOut() :: TVarChar) :: TVarChar                          AS SaleDesc
        , (zc_Movement_Sale() :: TVarChar || ';' || zc_Movement_PriceCorrective() :: TVarChar || ';' || zc_Movement_Service() :: TVarChar || ';' || 'SaleRealDesc') :: TVarChar AS SaleRealDesc
        , (zc_Movement_ReturnIn()::TVarChar||';'||zc_Movement_TransferDebtIn()::TVarChar)::TVarChar AS ReturnInDesc
        , zc_Movement_ReturnIn()::TVarChar                                                          AS ReturnInRealDesc
        , (zc_Movement_Cash()::TVarChar||';'||zc_Movement_BankAccount()::TVarChar||';'||zc_Movement_PersonalAccount()::TVarChar)::TVarChar
                                            AS MoneyDesc
        , (zc_Movement_ProfitLossService() :: TVarChar || ';' || zc_Movement_Service() :: TVarChar || ';' || zc_Movement_TransportService() :: TVarChar) :: TVarChar
                                            AS ServiceDesc
        , (zc_Movement_TransferDebtOut()::TVarChar||';'||zc_Movement_TransferDebtIn()::TVarChar)::TVarChar AS TransferDebtDesc
        , (zc_Movement_SendDebt()::TVarChar)::TVarChar AS SendDebtDesc
        , (zc_Movement_LossDebt() :: TVarChar || ';' || zc_Movement_PersonalReport() :: TVarChar) :: TVarChar AS OtherDesc
        , zc_Movement_PriceCorrective() :: TVarChar AS PriceCorrectiveDesc
        , (zc_Movement_ProfitLossService() :: TVarChar || ';' || zc_Movement_Service() :: TVarChar || ';' || zc_Movement_TransportService() :: TVarChar || ';' || 'ServiceRealDesc') :: TVarChar
                                            AS ServiceRealDesc
        , zc_Movement_Currency() :: TVarChar AS ChangeCurrencyDesc
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetDescSets (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.15                                        * add zc_Movement_PersonalReport
 31.08.14                                        * add Real...
 22.04.14                         *
 11.03.14                         *
*/

-- тест
-- SELECT * FROM gpGetDescSets (inSession:= '2')