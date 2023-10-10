-- Function: _replica.gpInsertUpdate_CheckingHistoryCost_Slave()

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_CheckingHistoryCost_Slave (TDateTime, TDateTime, Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_CheckingHistoryCost_Slave(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer   , --
    IN inItearationCount Integer   , --
    IN inDiffSumm        TFloat    , --
    IN inSession         TVarChar    -- сессия пользователя
)
  RETURNS TABLE (RewiringUUId TVarChar) 
  
AS
$BODY$
   DECLARE vbRewiringUUId TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());
     
     vbRewiringUUId := gen_random_uuid()::TVarChar;

     INSERT INTO _replica.HistoryCost_Rewiring (RewiringUUId, ContainerId, StartDate, EndDate
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
                         inSession := inSession) AS q;         
          
     
     -- Сохраним контейнера для последующего удвления на мастере     
     INSERT INTO _replica.Container_branch_Rewiring (RewiringUUId, ContainerId)
     SELECT vbRewiringUUId, _tmpContainer_branch.ContainerId FROM _tmpContainer_branch;

     RETURN QUERY
     SELECT vbRewiringUUId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.09.23                                                       * 
*/

-- SELECT * FROM _replica.HistoryCost_Rewiring
-- SELECT * FROM _replica.Container_branch_Rewiring
-- 7620680f-e57e-4d91-a52e-c3e90c4989b7
-- SELECT * FROM _replica.gpInsertUpdate_CheckingHistoryCost_Slave (inStartDate:= '01.09.2023', inEndDate:= '27.09.2023', inBranchId:= 8379, inItearationCount:= 50, inDiffSumm:= 1, inSession:= zfCalc_UserAdmin());