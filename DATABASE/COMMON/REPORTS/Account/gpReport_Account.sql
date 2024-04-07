-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_Account_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Account_no_otomize (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Account (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Account (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account (
    IN inStartDate              TDateTime ,  
    IN inEndDate                TDateTime ,
    IN inAccountGroupId         Integer , 
    IN inAccountDirectionId     Integer , 
    IN inInfoMoneyId            Integer , 
    IN inAccountId              Integer ,
    IN inBusinessId             Integer ,
    IN inProfitLossGroupId      Integer ,
    IN inProfitLossDirectionId  Integer , 
    IN inProfitLossId           Integer ,
    IN inBranchId               Integer ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber Integer, MovementId Integer, OperDate TDateTime, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
              , PersonalCode Integer, PersonalName TVarChar
              , JuridicalCode Integer, JuridicalName TVarChar
              , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
              , BusinessCode Integer, BusinessName TVarChar
              , PaidKindName TVarChar, ContractName TVarChar
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar
              , ObjectId_Direction Integer, ObjectCode_Direction Integer, ObjectName_Direction TVarChar
              , ObjectCode_Destination Integer, ObjectName_Destination TVarChar
              , DescName_Direction TVarChar
              , DescName_Destination TVarChar

              , PersonalCode_inf Integer, PersonalName_inf TVarChar
              , CarModelName_inf TVarChar, CarCode_inf Integer, CarName_inf TVarChar
              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinessCode_inf Integer, BusinessName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat, OperPrice TFloat
              , AccountGroupCode Integer, AccountGroupName TVarChar
              , AccountDirectionCode Integer, AccountDirectionName TVarChar
              , AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
              , AccountGroupCode_inf Integer, AccountGroupName_inf TVarChar
              , AccountDirectionCode_inf Integer, AccountDirectionName_inf TVarChar
              , AccountCode_inf Integer, AccountName_inf TVarChar, AccountName_All_inf TVarChar
              , ProfitLossName_All_inf TVarChar
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Account());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


    RETURN QUERY
    SELECT * FROM lpReport_Account (
         inStartDate             := inStartDate,  
         inEndDate               := inEndDate,
         inAccountGroupId        := inAccountGroupId, 
         inAccountDirectionId    := inAccountDirectionId, 
         inInfoMoneyId           := inInfoMoneyId, 
         inAccountId             := inAccountId,
         inBusinessId            := inBusinessId,
         inProfitLossGroupId     := inProfitLossGroupId,
         inProfitLossDirectionId := inProfitLossDirectionId, 
         inProfitLossId          := inProfitLossId,
         inBranchId              := inBranchId,
         inUserId                := vbUserId
       ) AS tmp
    WHERE tmp.SummStart <> 0 OR tmp.SummIn <> 0 OR tmp.SummOut <> 0 OR tmp.SummEnd <> 0
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Account (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.09.14                          * add lpReport_Account
 15.09.14                          * add ObjectId_Direction
 04.05.14                                        * add BankAccountId and CashId
 25.03.14                                        * !!!ONLY!!! inAccountId OR inAccountGroupId OR inAccountDirectionId
 20.03.14                          * add Params                          
 17.03.14                          * add MovementId                          
 18.03.14                                        * add zc_ObjectLink_BankAccount_Bank
 27.01.14                                        * add zc_ContainerLinkObject_JuridicalBasis
 21.01.14                                        * add CarId
 21.12.13                                        * Personal -> Member
 02.11.13                                        * add Account...
 01.11.13                                        * all
 29.10.13                                        * err InfoManey
 07.10.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Account (inStartDate:= '01.12.2015', inEndDate:= '31.12.2015', inAccountGroupId:= 0, inAccountDirectionId:= 0, inInfoMoneyId:= 0, inAccountId:= 9128, inBusinessId:= 0, inProfitLossGroupId:= 0,  inProfitLossDirectionId:= 0,  inProfitLossId:= 0,  inBranchId:= 0, inSession:= zfCalc_UserAdmin());
