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
RETURNS TABLE  (InvNumber Integer, MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, Comment TVarChar, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar

              , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
              , BusinessCode Integer, BusinessName TVarChar
              , PaidKindName TVarChar, ContractCode Integer, ContractName TVarChar

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
    
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


    RETURN QUERY
         SELECT tmp.InvNumber, tmp.MovementId, tmp.OperDate, tmp.OperDatePartner, tmp.Comment, tmp.MovementDescName
              , tmp.InfoMoneyCode, tmp.InfoMoneyGroupName, tmp.InfoMoneyDestinationName, tmp.InfoMoneyName

              , tmp.JuridicalBasisCode, tmp.JuridicalBasisName
              , tmp.BusinessCode, tmp.BusinessName
              , tmp.PaidKindName, tmp.ContractCode, tmp.ContractName

              , tmp.ObjectId_Direction, tmp.ObjectCode_Direction, tmp.ObjectName_Direction
              , tmp.ObjectCode_Destination, tmp.ObjectName_Destination
              , tmp.DescName_Direction
              , tmp.DescName_Destination
              , tmp.GoodsKindName

              , tmp.RouteCode_inf, tmp.RouteName_inf
              , tmp.UnitCode_inf, tmp.UnitName_inf
              , tmp.BranchCode_inf, tmp.BranchName_inf
              , tmp.BusinessCode_inf, tmp.BusinessName_inf
              , tmp.SummStart, tmp.SummIn, tmp.SummOut, tmp.SummEnd--, tmp.OperPrice
              , tmp.AccountGroupCode, tmp.AccountGroupName
              , tmp.AccountDirectionCode, tmp.AccountDirectionName
              , tmp.AccountCode, tmp.AccountName, tmp.AccountName_All
              , tmp.AccountGroupCode_inf, tmp.AccountGroupName_inf
              , tmp.AccountDirectionCode_inf, tmp.AccountDirectionName_inf
              , tmp.AccountCode_inf, tmp.AccountName_inf, tmp.AccountName_All_inf
              , tmp.ProfitLossName_All_inf

              , tmp.InfoMoneyId_Detail, tmp.InfoMoneyCode_Detail
              , tmp.InfoMoneyGroupName_Detail, tmp.InfoMoneyDestinationName_Detail
              , tmp.InfoMoneyName_Detail, tmp.InfoMoneyName_all_Detail
              
    FROM lpReport_AccountMotion (inStartDate             := inStartDate, 
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА,АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.18         * add inMovementDescId
 19.06.18         *  
*/

-- тест
-- SELECT * FROM gpReport_AccountMotion (inStartDate := ('01.11.2021')::TDateTime ,inEndDate := ('01.11.2021')::TDateTime ,inAccountGroupId := 9015 ,inAccountDirectionId := 9034 ,inInfoMoneyId := 0 ,inAccountId := 0 ,inBusinessId := 0 ,inProfitLossGroupId := 0 ,inProfitLossDirectionId := 0 ,inProfitLossId := 0 ,inBranchId := 0 ,inMovementDescId := 0 ,inIsMovement := 'False' ,inIsGoods := 'False' ,inIsGoodsKind := 'False' ,inIsDetail := False,inSession:= zfCalc_UserAdmin());
