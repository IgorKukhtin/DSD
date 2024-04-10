-- Function: gpReport_Account_noBalance ()

DROP FUNCTION IF EXISTS gpReport_Account_noBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account_noBalance (
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
    SELECT * FROM lpReport_Account_noBalance (inStartDate             := inStartDate,  
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


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.21                                        *
*/

-- тест
-- SELECT * FROM gpReport_Account_noBalance(inStartDate := ('01.12.2020')::TDateTime , inEndDate := ('31.12.2020')::TDateTime , inAccountGroupId := 9014 , inAccountDirectionId := 9025 , inInfoMoneyId := 0 , inAccountId := 0 , inBusinessId := 0 , inProfitLossGroupId := 9215 , inProfitLossDirectionId := 9244 , inProfitLossId := 0 , inBranchId := 0 ,  inSession := '5');
