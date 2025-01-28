-- Function: gpSelect_Movement_BankAccount_srv_r()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount_srv_r (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount_srv_r(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- Главное юр.лицо 
    IN inAccountId         Integer   , -- (Павильоны) -  10895486   ()
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_Parent TVarChar, BankSInvNumber_Parent TVarChar, ParentId Integer
             , OperDate TDateTime
             , ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat
             , AmountOut TFloat
             , AmountSumm TFloat
             , AmountCurrency TFloat
             , Comment TVarChar
             , BankAccountName TVarChar, BankName TVarChar, MFO TVarChar
             , JuridicalName TVarChar, OKPO_BankAccount TVarChar
             , MoneyPlaceId Integer , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, ItemName TVarChar, OKPO TVarChar, OKPO_Parent TVarChar 
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , PartnerBankName TVarChar, PartnerBankMFO TVarChar, PartnerBankAccountName TVarChar
             , isCopy Boolean
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar

             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsIrna   Boolean;
   DECLARE vbMemberId Integer;
   DECLARE vbIsExists Boolean;
   DECLARE vbCount    Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
       WITH 
       tmpMovement AS (SELECT spSelect.*
                       FROM gpSelect_Movement_BankAccount(inStartDate, inEndDate, inJuridicalBasisId, inAccountId, inIsErased, inSession) AS spSelect 
                       )

       SELECT
             tmp.Id
           , tmp.InvNumber             ::TVarChar
           , tmp.InvNumber_Parent      ::TVarChar
           , tmp.BankSInvNumber_Parent ::TVarChar
           , tmp.ParentId
           , tmp.OperDate       ::TDateTime
           , tmp.ServiceDate
           , tmp.StatusCode
           , tmp.StatusName
           , tmp.AmountIn       ::TFloat
           , tmp.AmountOut      ::TFloat
           , tmp.AmountSumm     ::TFloat
           , tmp.AmountCurrency ::TFloat
           , tmp.Comment        ::TVarChar
           , tmp.BankAccountName::TVarChar
           , tmp.BankName       ::TVarChar
           , tmp.MFO            ::TVarChar
           , tmp.JuridicalName  ::TVarChar
           , tmp.OKPO_BankAccount ::TVarChar
           , tmp.MoneyPlaceId
           , tmp.MoneyPlaceCode
           , tmp.MoneyPlaceName           ::TVarChar
           , tmp.ItemName                 ::TVarChar
           , tmp.OKPO                     ::TVarChar
           , tmp.OKPO_Parent              ::TVarChar
           , tmp.PartnerId
           , tmp.PartnerName              ::TVarChar
           , tmp.InfoMoneyGroupName       ::TVarChar
           , tmp.InfoMoneyDestinationName ::TVarChar
           , tmp.InfoMoneyCode
           , tmp.InfoMoneyName            ::TVarChar
           , tmp.InfoMoneyName_all        ::TVarChar
           , tmp.ContractCode
           , tmp.ContractInvNumber        ::TVarChar
           , tmp.ContractTagName          ::TVarChar
           , tmp.UnitCode
           , tmp.UnitName                 ::TVarChar
           , tmp.CurrencyName             ::TVarChar
           , tmp.CurrencyValue            ::TFloat
           , tmp.ParValue                 ::TFloat
           , tmp.CurrencyPartnerValue     ::TFloat
           , tmp.ParPartnerValue          ::TFloat
           , tmp.BankName                 ::TVarChar
           , tmp.MFO                      ::TVarChar
           , tmp.PartnerBankAccountName   ::TVarChar
           , tmp.isCopy                   ::Boolean
           , tmp.MovementId_Invoice       ::Integer
           , tmp.InvNumber_Invoice        ::TVarChar
           , tmp.Comment_Invoice          ::TVarChar
           , tmp.ProfitLossGroupName      ::TVarChar
           , tmp.ProfitLossDirectionName  ::TVarChar
           , tmp.ProfitLossName           ::TVarChar
           , tmp.ProfitLossName_all       ::TVarChar
       FROM tmpMovement AS tmp
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.25         *
 */

-- тест
-- select * from gpSelect_Movement_BankAccount_srv_r (inStartDate := ('01.12.2024')::TDateTime , inEndDate := ('01.12.2024')::TDateTime , inJuridicalBasisId := 9399 , inAccountId := -10895486 , inIsErased := 'False' ,  inSession := '9457');