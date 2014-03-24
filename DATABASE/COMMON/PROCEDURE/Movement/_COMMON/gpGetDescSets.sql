-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpGetDescSets (TVarChar);

CREATE OR REPLACE FUNCTION gpGetDescSets(
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (IncomeDesc TVarChar, ReturnOutDesc TVarChar, SaleDesc TVarChar, ReturnInDesc TVarChar
             , MoneyDesc TVarChar , ServiceDesc TVarChar, SendDebtDesc TVarChar, OtherDesc TVarChar)
AS
$BODY$
BEGIN

     RETURN QUERY
       SELECT
          zc_Movement_Income()::TVarChar    AS IncomeDesc
        , zc_Movement_ReturnOut()::TVarChar AS ReturnOutDesc
        , zc_Movement_Sale()::TVarChar      AS SaleDesc
        , zc_Movement_ReturnIn()::TVarChar  AS ReturnInDesc
        , (zc_Movement_Cash()::TVarChar||';'||zc_Movement_BankAccount()::TVarChar||';'||zc_Movement_PersonalAccount()::TVarChar)::TVarChar
                                            AS MoneyDesc
        , (zc_Movement_Service()::TVarChar||';'||zc_Movement_TransportService()::TVarChar)::TVarChar
                                            AS ServiceDesc
        , (zc_Movement_LossDebt()::TVarChar||';'||zc_Movement_SendDebt()::TVarChar)::TVarChar
                                            AS SendDebtDesc
        , zc_Movement_ProfitLossService()::TVarChar AS OtherDesc;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetDescSets (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.14                         *

*/

-- тест
-- SELECT * FROM gpGetDescSets (inSession:= '2')