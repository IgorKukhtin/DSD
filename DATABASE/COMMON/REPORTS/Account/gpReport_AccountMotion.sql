-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_AccountMotion (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_AccountMotion (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_AccountMotion (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_AccountMotion (
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
    IN inMovementDescId         Integer ,
    IN inIsMovement             Boolean ,
    IN inIsGoods                Boolean ,
    IN inIsGoodsKind            Boolean ,
    IN inIsDetail               Boolean ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber Integer, MovementId Integer, OperDate TDateTime, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar

              , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
              , BusinessCode Integer, BusinessName TVarChar
              , PaidKindName TVarChar, ContractName TVarChar

              , ObjectId_Direction Integer, ObjectCode_Direction Integer, ObjectName_Direction TVarChar
              , ObjectCode_Destination Integer, ObjectName_Destination TVarChar
              , DescName_Direction TVarChar
              , DescName_Destination TVarChar
              , GoodsKindName TVarChar

              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinessCode_inf Integer, BusinessName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat--, OperPrice TFloat
              , AccountGroupCode Integer, AccountGroupName TVarChar
              , AccountDirectionCode Integer, AccountDirectionName TVarChar
              , AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
              , AccountGroupCode_inf Integer, AccountGroupName_inf TVarChar
              , AccountDirectionCode_inf Integer, AccountDirectionName_inf TVarChar
              , AccountCode_inf Integer, AccountName_inf TVarChar, AccountName_All_inf TVarChar
              , ProfitLossName_All_inf TVarChar

              , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer
              , InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar
              , InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Account());
     vbUserId:= lpGetUserBySession (inSession);
    
     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


    RETURN QUERY
    SELECT * FROM lpReport_AccountMotion (inStartDate             := inStartDate,  
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
                                          inMovementDescId        := inMovementDescId,
                                          inUserId                := vbUserId,
                                          inIsMovement            := inIsMovement,
                                          inIsGoods               := inIsGoods,
                                          inIsGoodsKind           := inIsGoodsKind,
                                          inIsDetail              := inIsDetail
                                          ) AS tmp
    WHERE tmp.SummStart <> 0 OR tmp.SummIn <> 0 OR tmp.SummOut <> 0 OR tmp.SummEnd <> 0
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.18         * add inMovementDescId
 19.06.18         *  
*/

-- тест
-- SELECT * FROM gpReport_AccountMotion (inStartDate:= '01.12.2015', inEndDate:= '31.12.2015', inAccountGroupId:= 0, inAccountDirectionId:= 0, inInfoMoneyId:= 0, inAccountId:= 9128, inBusinessId:= 0, inProfitLossGroupId:= 0,  inProfitLossDirectionId:= 0,  inProfitLossId:= 0,  inBranchId:= 0, inMovementDescId:=0, inSession:= zfCalc_UserAdmin());
