-- Function: _replica.gpSelect_CheckingHistoryCost()

DROP FUNCTION IF EXISTS _replica.gpSelect_CheckingHistoryCost (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_CheckingHistoryCost(
    IN inMasterUUId        TVarChar   , --
    IN inSlaveUUId         TVarChar   , --
    IN inSession           TVarChar    -- сессия пользователя
)
  RETURNS TABLE (ContainerId            Integer
               , StartDate              TDateTime
               , EndDate                TDateTime
               
               , MPrice                 TFloat
               , MStartCount            TFloat
               , MStartSumm             TFloat
               , MIncomeCount           TFloat
               , MIncomeSumm            TFloat
               , MCalcCount             TFloat
               , MCalcSumm              TFloat
               , MOutCount              TFloat
               , MOutSumm               TFloat
               , MPrice_external        TFloat
               , MCalcCount_external    TFloat
               , MCalcSumm_external     TFloat
               
               , SPrice                 TFloat
               , SStartCount            TFloat
               , SStartSumm             TFloat
               , SIncomeCount           TFloat
               , SIncomeSumm            TFloat
               , SCalcCount             TFloat
               , SCalcSumm              TFloat
               , SOutCount              TFloat
               , SOutSumm               TFloat
               , SPrice_external        TFloat
               , SCalcCount_external    TFloat
               , SCalcSumm_external     TFloat) 
  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession::Integer;

   -- Результат
   RETURN QUERY 
   SELECT COALESCE(MasterHC.ContainerId, MasterHC.ContainerId)  AS ContainerId
        , COALESCE(MasterHC.StartDate, MasterHC.StartDate)      AS StartDate
        , COALESCE(MasterHC.EndDate, MasterHC.EndDate)          AS EndDate
   
        , MasterHC.Price
        , MasterHC.StartCount
        , MasterHC.StartSumm
        , MasterHC.IncomeCount
        , MasterHC.IncomeSumm
        , MasterHC.CalcCount
        , MasterHC.CalcSumm
        , MasterHC.OutCount
        , MasterHC.OutSumm
        , MasterHC.Price_external
        , MasterHC.CalcCount_external
        , MasterHC.CalcSumm_external

        , (SlaveHC.Price- 1)::TFloat
        , SlaveHC.StartCount
        , (SlaveHC.StartSumm - 1)::TFloat
        , SlaveHC.IncomeCount
        , SlaveHC.IncomeSumm
        , SlaveHC.CalcCount
        , (SlaveHC.CalcSumm - 1)::TFloat
        , SlaveHC.OutCount
        , SlaveHC.OutSumm
        , SlaveHC.Price_external
        , SlaveHC.CalcCount_external
        , SlaveHC.CalcSumm_external
   
   FROM _replica.HistoryCost_Rewiring AS MasterHC
   
       FULL JOIN _replica.HistoryCost_Rewiring AS SlaveHC
                                               ON SlaveHC.RewiringUUId ILIKE inSlaveUUId
                                              AND SlaveHC.ContainerId = MasterHC.ContainerId
                                              AND SlaveHC.StartDate = MasterHC.StartDate
   
   WHERE MasterHC.RewiringUUId ILIKE inMasterUUId
     AND (COALESCE(MasterHC.Price, 0) <> COALESCE(SlaveHC.Price, 0)
      OR COALESCE(MasterHC.StartSumm, 0) <> COALESCE(SlaveHC.StartSumm, 0)
      OR COALESCE(MasterHC.IncomeCount, 0) <> COALESCE(SlaveHC.IncomeCount, 0)
      OR COALESCE(MasterHC.IncomeSumm, 0) <> COALESCE(SlaveHC.IncomeSumm, 0)
      OR COALESCE(MasterHC.CalcCount, 0) <> COALESCE(SlaveHC.CalcCount, 0)
      OR COALESCE(MasterHC.CalcSumm, 0) <> COALESCE(SlaveHC.CalcSumm, 0)
      OR COALESCE(MasterHC.OutCount, 0) <> COALESCE(SlaveHC.OutCount, 0)
      OR COALESCE(MasterHC.OutSumm, 0) <> COALESCE(SlaveHC.OutSumm, 0)
      OR COALESCE(MasterHC.Price_external, 0) <> COALESCE(SlaveHC.Price_external, 0)
      OR COALESCE(MasterHC.CalcCount_external, 0) <> COALESCE(SlaveHC.CalcCount_external, 0)
      OR COALESCE(MasterHC.CalcSumm_external, 0) <> COALESCE(SlaveHC.CalcSumm_external, 0))
   ;
   
   DELETE FROM _replica.HistoryCost_Rewiring WHERE HistoryCost_Rewiring.RewiringUUId ILIKE inMasterUUId;
   DELETE FROM _replica.Container_branch_Rewiring WHERE Container_branch_Rewiring.RewiringUUId ILIKE inMasterUUId;

   DELETE FROM _replica.HistoryCost_Rewiring WHERE HistoryCost_Rewiring.RewiringUUId ILIKE inSlaveUUId;
   DELETE FROM _replica.Container_branch_Rewiring WHERE Container_branch_Rewiring.RewiringUUId ILIKE inSlaveUUId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.09.23                                                       * 
*/

-- SELECT DISTINCT RewiringUUId FROM _replica.Container_branch_Rewiring
-- SELECT DISTINCT RewiringUUId FROM _replica.HistoryCost_Rewiring where RewiringUUId ILIKE ''
-- 7620680f-e57e-4d91-a52e-c3e90c4989b7
-- SELECT * FROM _replica.gpSelect_CheckingHistoryCost (inMasterUUId:= 'd8e4c361-b03b-4361-9090-dbdc7c009c61', inSlaveUUId:= 'd54f8267-ad0d-41bb-81ae-68fedd7aa78b', inSession:= zfCalc_UserAdmin());