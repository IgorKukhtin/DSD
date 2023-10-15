-- Function: _replica.gpInsertUpdate_CheckingHistoryCost_Master()

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_CheckingHistoryCost_Master (TDateTime, TDateTime, Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_CheckingHistoryCost_Master(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer   , --
    IN inItearationCount Integer   , --
    IN inDiffSumm        TFloat    , --
    IN inSession         TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
  RETURNS TABLE (RewiringUUId TVarChar) 
  
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;

   DECLARE vbRewiringUUId TVarChar;
BEGIN

     vbRewiringUUId := gen_random_uuid()::TVarChar;

     SELECT Host, DBName, Port, UserName, Password
     INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
     FROM _replica.gpSelect_MasterConnectParams(inSession);

     /*INSERT INTO _replica.HistoryCost_Rewiring (RewiringUUId, ContainerId, StartDate, EndDate
                                              , Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm
                                              , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm
                                              , MovementItemId_diff, Summ_diff)
     SELECT vbRewiringUUId
          , q.ContainerId, inStartDate AS StartDate , DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
          , q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm 
          , q.calcCount, q.calcSumm, q.calcCount_external, q.calcSumm_external, q.OutCount, q.OutSumm
          , 0 AS MovementItemId_diff, 0 AS Summ_diff
          
                  FROM gpInsertUpdate_HistoryCost(
                         inStartDate := inStartDate,
                         inEndDate := inEndDate,
                         inBranchId := inBranchId,
                         inItearationCount := inItearationCount,
                         inInsert := -1,
                         inDiffSumm := inDiffSumm,
                         inSession := inSession) AS  q         */
          
     INSERT INTO _replica.HistoryCost_Rewiring (RewiringUUId, ContainerId, StartDate, EndDate
                                              , Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm
                                              , CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm
                                              , MovementItemId_diff, Summ_diff)
     SELECT vbRewiringUUId
          , q.ContainerId, inStartDate AS StartDate , DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
          , q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm 
          , q.calcCount, q.calcSumm, q.calcCount_external, q.calcSumm_external, q.OutCount, q.OutSumm
          , 0 AS MovementItemId_diff, 0 AS Summ_diff
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT Price, PriceNext, Price_external, PriceNext_external, 
                     FromContainerId, ContainerId, isInfoMoney_80401, CalcSummCurrent, 
                     CalcSummNext, CalcSummCurrent_external, CalcSummNext_external, 
                     StartCount, StartSumm, IncomeCount, IncomeSumm, calcCount, 
                     calcSumm, calcCount_external, calcSumm_external, OutCount, OutSumm
                  FROM gpInsertUpdate_HistoryCost(
                         inStartDate := '''||TO_CHAR (inStartDate, 'DD.MM.YYYY')::TEXT||''',
                         inEndDate := '''||TO_CHAR (inEndDate, 'DD.MM.YYYY')::TEXT||''',
                         inBranchId := '||inBranchId::TEXT||',
                         inItearationCount := '||inItearationCount::TEXT||',
                         inInsert := -1,
                         inDiffSumm := '||inDiffSumm::TEXT||',
                         inSession := '''||inSession||''')') AS 
                   q(Price TFloat, PriceNext TFloat, Price_external TFloat, PriceNext_external TFloat, 
                     FromContainerId Integer, ContainerId Integer, isInfoMoney_80401 Boolean, CalcSummCurrent TFloat, 
                     CalcSummNext TFloat, CalcSummCurrent_external TFloat, CalcSummNext_external TFloat, 
                     StartCount TFloat, StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, calcCount TFloat, 
                     calcSumm TFloat, calcCount_external TFloat, calcSumm_external TFloat, OutCount TFloat, OutSumm TFloat);  

     RETURN QUERY
     SELECT vbRewiringUUId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 24.08.15                                        * add inBranchId

 08.11.14                                        * add zc_ObjectLink_Unit_HistoryCost
 13.08.14                                        * ObjectCostId -> ContainerId
 10.08.14                                        * add SendOnPrice
 15.09.13                                        * add zc_Container_CountSupplier and zc_Enum_Account_20901
 13.07.13                                        * add JOIN Container
 10.07.13                                        *
*/

-- SELECT * FROM _replica.HistoryCost_Rewiring
-- 7620680f-e57e-4d91-a52e-c3e90c4989b7
-- SELECT * FROM _replica.gpInsertUpdate_CheckingHistoryCost_Master (inStartDate:= '01.09.2023', inEndDate:= '30.09.2023', inBranchId:= 8379, inItearationCount:= 50, inDiffSumm:= 1, inSession:= zfCalc_UserAdmin());