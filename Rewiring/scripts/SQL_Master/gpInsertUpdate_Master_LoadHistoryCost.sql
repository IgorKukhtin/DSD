-- Function: gpInsertUpdate_Master_LoadHistoryCost (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_Master_LoadHistoryCost (TVarChar, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_Master_LoadHistoryCost(
    IN inRewiringUUId    TVarChar,   -- UUId Для переносы данных 
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer   , --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                    Integer, 
               StartDate             TDateTime,
               EndDate               TDateTime,
               Price                 TFloat,
               StartCount            TFloat,
               StartSumm             TFloat,
               IncomeCount           TFloat,
               IncomeSumm            TFloat,
               CalcCount             TFloat,
               CalcSumm              TFloat,
               OutCount              TFloat,
               OutSumm               TFloat,

               ContainerId           Integer,
               Price_external        TFloat,
               CalcCount_external    TFloat,
               CalcSumm_external     TFloat,
               MovementItemId_diff   Integer,
               Summ_diff             TFloat   
               ) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
      
   DECLARE vbHistoryCosDel Integer;
   DECLARE vbHistoryCosCount Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_ReplicaConnectParams(inSession);     

   --  Обновляем HistoryCost
   IF inBranchId > 0
   THEN
         -- Удаляем предыдущую с/с - !!!для 1-ого Филиала!!!
   
         DELETE FROM HistoryCost 
         WHERE HistoryCost.StartDate   IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
           AND HistoryCost.ContainerId IN (SELECT q.ContainerId
                                           FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                                                       'SELECT Container_branch_Rewiring.ContainerId 
                                                        FROM _replica.Container_branch_Rewiring WHERE RewiringUUId ILIKE '''||inRewiringUUId||'''') AS q(ContainerId Integer));
                                                                  
   ELSE                                                                                                                                  
         -- Удаляем предыдущую с/с - !!!кроме всех Филиалов!!!
         
         DELETE FROM HistoryCost 
         WHERE HistoryCost.StartDate       IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
           AND HistoryCost.ContainerId NOT IN (SELECT q.ContainerId
                                               FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                                                           'SELECT Container_branch_Rewiring.ContainerId 
                                                           FROM _replica.Container_branch_Rewiring WHERE RewiringUUId ILIKE '''||inRewiringUUId||'''') AS q(ContainerId Integer));

   END IF; -- if inBranchId > 0

   GET DIAGNOSTICS vbHistoryCosDel = ROW_COUNT; 


   CREATE TEMP TABLE tmpHistoryCost ON COMMIT DROP AS
   SELECT q.ContainerId, q.StartDate, q.EndDate, q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm, q.CalcCount, 
          q.CalcSumm, q.CalcCount_external, q.CalcSumm_external, q.OutCount, q.OutSumm, q.MovementItemId_diff, q.Summ_diff
   FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
               'SELECT ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, 
                       CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff 
                       FROM _replica.HistoryCost_Rewiring
                       WHERE HistoryCost_Rewiring.RewiringUUId ILIKE '''||inRewiringUUId||'''') AS 
                 q(ContainerId Integer, StartDate TDateTime, EndDate TDateTime, Price TFloat, Price_external TFloat, StartCount TFloat, 
                   StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, 
                   CalcSumm_external TFloat, OutCount TFloat, OutSumm TFloat, MovementItemId_diff Integer, Summ_diff TFloat);  
                   
   INSERT INTO HistoryCost (ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, CalcCount, 
                            CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
   SELECT q.ContainerId, q.StartDate, q.EndDate, q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm, q.CalcCount, 
          q.CalcSumm, q.CalcCount_external, q.CalcSumm_external, q.OutCount, q.OutSumm, q.MovementItemId_diff, q.Summ_diff
   FROM tmpHistoryCost AS q;

   GET DIAGNOSTICS vbHistoryCosCount = ROW_COUNT; 
   
   raise notice 'Обработали : %  %', vbHistoryCosDel, vbHistoryCosCount;

      -- Результат
   RETURN QUERY
   SELECT q.Id
        , q.StartDate
        , q.EndDate
        , q.Price
        , q.StartCount
        , q.StartSumm
        , q.IncomeCount
        , q.IncomeSumm
        , q.CalcCount
        , q.CalcSumm
        , q.OutCount
        , q.OutSumm
        , q.ContainerId
        , q.Price_external
        , q.CalcCount_external
        , q.CalcSumm_external
        , q.MovementItemId_diff
        , q.Summ_diff
   FROM HistoryCost AS q
   
        INNER JOIN tmpHistoryCost ON tmpHistoryCost.ContainerId = q.ContainerId
                                 AND tmpHistoryCost.StartDate = q.StartDate
                                 AND tmpHistoryCost.EndDate = q.EndDate
   ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.23                                                       * 
*/

-- Тест

-- select * from _replica.gpInsertUpdate_Master_LoadHistoryCost(inRewiringUUId := '7620680f-e57e-4d91-a52e-c3e90c4989b7', inStartDate:= '01.09.2023', inEndDate:= '30.09.2023', inBranchId:= 8379, inSession:= zfCalc_UserAdmin());