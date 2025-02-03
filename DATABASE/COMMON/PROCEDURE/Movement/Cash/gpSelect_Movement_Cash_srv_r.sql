-- Function: gpSelect_Movement_Cash_srv_r()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_srv_r (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_srv_r(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inCashId           Integer , --
    IN inCurrencyId       Integer , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat

               -- Сумма в валюте
             , AmountCurrency TFloat
               -- Cумма грн, обмен
             , AmountSumm TFloat
               -- факт. курс на дату - для курс разн.
             , CurrencyValue_mi_calc TFloat
               -- расч. курс на дату - для курс разн.
             , CurrencyValue_calc    TFloat

             , ServiceDate TDateTime
             , Comment TVarChar
             , CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceCode Integer, MoneyPlaceName TVarChar, OKPO TVarChar, ItemName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberName TVarChar, PositionName TVarChar, PersonalServiceListId Integer, PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelId Integer, CarModelName TVarChar
             , UnitId_Car Integer, UnitName_Car TVarChar
             , CurrencyName TVarChar, CurrencyPartnerName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , isLoad Boolean
             , PartionMovementName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
             , UnitName_Mobile TVarChar
             , PositionName_Mobile TVarChar
             , GUID TVarChar
             , CurrencyId_x  Integer
             , MovementId_x  Integer
             , AmountSumm_x  TFloat

             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCount Integer;
   DECLARE vbUser_all Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY
       WITH 
       tmpMovement AS (SELECT spSelect.* 
                       FROM gpSelect_Movement_Cash (inStartDate,
                                                    inEndDate,
                                                    inCashId,
                                                    inCurrencyId,
                                                    inJuridicalBasisId,
                                                    inIsErased,
                                                    inSession) AS spSelect
                       )

       SELECT
             tmp.Id
           , tmp.InvNumber
           , tmp.OperDate
           , tmp.StatusCode
           , tmp.StatusName
           , tmp.AmountIn
           , tmp.AmountOut
           , tmp.AmountCurrency
           , tmp.AmountSumm
           , tmp.CurrencyValue_mi_calc
           , tmp.CurrencyValue_calc
           , tmp.ServiceDate
           , tmp.Comment
           , tmp.CashName
           , tmp.MoneyPlaceId
           , tmp.MoneyPlaceCode
           , tmp.MoneyPlaceName
           , tmp.OKPO
           , tmp.ItemName
           , tmp.InfoMoneyGroupName
           , tmp.InfoMoneyDestinationName
           , tmp.InfoMoneyCode
           , tmp.InfoMoneyName
           , tmp.InfoMoneyName_all
           , tmp.MemberName
           , tmp.PositionName
           , tmp.PersonalServiceListId
           , tmp.PersonalServiceListCode
           , tmp.PersonalServiceListName
           , tmp.ContractCode
           , tmp.ContractInvNumber
           , tmp.ContractTagName
           , tmp.UnitCode
           , tmp.UnitName
           , tmp.CarId
           , tmp.CarName
           , tmp.CarModelId
           , tmp.CarModelName
           , tmp.UnitId_Car
           , tmp.UnitName_Car
           , tmp.CurrencyName
           , tmp.CurrencyPartnerName
           , tmp.CurrencyValue
           , tmp.ParValue
           , tmp.CurrencyPartnerValue
           , tmp.ParPartnerValue
           , tmp.isLoad
           , tmp.PartionMovementName
           , tmp.MovementId_Invoice
           , tmp.InvNumber_Invoice
           , tmp.Comment_Invoice
           , tmp.InsertDate
           , tmp.InsertMobileDate
           , tmp.InsertName
           , tmp.UnitName_Mobile
           , tmp.PositionName_Mobile
           , tmp.GUID

           , tmp.CurrencyId_x 
           , tmp.MovementId_x
           , tmp.AmountSumm_x

           , tmp.ProfitLossGroupName     ::TVarChar
           , tmp.ProfitLossDirectionName ::TVarChar
           , tmp.ProfitLossName          ::TVarChar
           , tmp.ProfitLossName_all      ::TVarChar
       FROM tmpMovement AS tmp

       ;
       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash_srv_r (inStartDate:= ('09.09.2024')::TDateTime , inEndDate := ('10.09.2024')::TDateTime , inCashId := 14462 , inCurrencyId :=  zc_Enum_Currency_Basis() , inJuridicalBasisId := 0 , inIsErased := 'False' ,  inSession := '5');
