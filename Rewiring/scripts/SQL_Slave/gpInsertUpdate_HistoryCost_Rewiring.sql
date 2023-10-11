-- Function: _replica.gpInsertUpdate_HistoryCost_Rewiring()

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_HistoryCost_Rewiring (TDateTime, TDateTime, Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_HistoryCost_Rewiring(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer   , --
    IN inItearationCount Integer   , --
    IN inDiffSumm        TFloat    , --
    IN inisMICSlave      Boolean, --
    IN inSession         TVarChar    -- сессия пользователя
)
  RETURNS TABLE (Error TBlob
               , CountRecord    INTEGER
               , CountDelete    INTEGER
               , CountInsert    INTEGER  
                ) 
  
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;

   DECLARE vbTransaction_Id BIGINT;
   DECLARE vbCountRecord    INTEGER;
   DECLARE vbCountDelete    INTEGER;
   DECLARE vbCountInsert    INTEGER;
   DECLARE text_var1   Text;
   DECLARE text_var2   Text;
BEGIN

   text_var1 := '';
   vbTransaction_Id := 0;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_MasterConnectParams(inSession);


          
   BEGIN
   
     -- Выполняем расчет на мастере
     SELECT q.Transaction_Id, q.CountRecord
     INTO vbTransaction_Id, vbCountRecord
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT Transaction_Id, CountRecord
                  FROM _replica.gpInsertUpdate_RewiringHistoryCost(
                         inStartDate := '''||TO_CHAR (inStartDate, 'DD.MM.YYYY')::TEXT||''',
                         inEndDate := '''||TO_CHAR (inEndDate, 'DD.MM.YYYY')::TEXT||''',
                         inBranchId := '||inBranchId::TEXT||',
                         inItearationCount := '||inItearationCount::TEXT||',
                         inInsert := 1,
                         inDiffSumm := '||inDiffSumm::TEXT||',
                         inisMICSlave := '||inisMICSlave::TEXT||',
                         inSession := '''||inSession||''')') AS 
                   q(Transaction_Id BIGINT, CountRecord Integer);  

     -- Удаляем старые значения
     DELETE FROM HistoryCost
     WHERE HistoryCost.Id IN (SELECT q.pk_values
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT UD.pk_values::INTEGER
                  FROM _replica.table_update_data AS UD 
                  WHERE UD.Last_Modified >= CURRENT_DATE
                    AND UD.table_name ILIKE ''HistoryCost''
                    AND UD.Operation ILIKE ''delete''
                    AND UD.transaction_id = '||vbTransaction_Id::TEXT) AS 
                   q(pk_values Integer));  

     GET DIAGNOSTICS vbCountDelete = ROW_COUNT;

     -- Вставляем новые
     INSERT INTO HistoryCost (Id, ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, 
                              CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
     SELECT q.Id, q.ContainerId, q.StartDate, q.EndDate, q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm, 
            q.CalcCount, q.CalcSumm, q.CalcCount_external, q.CalcSumm_external, q.OutCount, q.OutSumm, q.MovementItemId_diff, q.Summ_diff
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT HC.Id, HC.ContainerId, HC.StartDate, HC.EndDate, HC.Price, HC.Price_external, HC.StartCount, 
                         HC.StartSumm, HC.IncomeCount, HC.IncomeSumm, HC.CalcCount, HC.CalcSumm, HC.CalcCount_external, 
                         HC.CalcSumm_external, HC.OutCount, HC.OutSumm, HC.MovementItemId_diff, HC.Summ_diff
                  FROM _replica.table_update_data AS UD 
                  
                       INNER JOIN HistoryCost AS HC ON HC.ID = UD.pk_values::INTEGER
                  
                  WHERE UD.Last_Modified >= CURRENT_DATE
                    AND UD.table_name ILIKE ''HistoryCost''
                    AND UD.Operation ILIKE ''insert''
                    AND UD.transaction_id = '||vbTransaction_Id::TEXT) AS 
                   q(Id Integer, ContainerId Integer, StartDate TDateTime, EndDate TDateTime, Price TFloat, Price_external TFloat, StartCount TFloat, 
                     StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, 
                     CalcSumm_external TFloat, OutCount TFloat, OutSumm TFloat, MovementItemId_diff Integer, Summ_diff TFloat)
     ON CONFLICT ON CONSTRAINT historycost_pkey 
     DO UPDATE SET ContainerId = EXCLUDED.ContainerId, StartDate = EXCLUDED.StartDate, EndDate = EXCLUDED.EndDate
                 , Price = EXCLUDED.Price, Price_external = EXCLUDED.Price_external, StartCount = EXCLUDED.StartCount
                 , StartSumm = EXCLUDED.StartSumm, IncomeCount = EXCLUDED.IncomeCount, IncomeSumm = EXCLUDED.IncomeSumm
                 , CalcCount = EXCLUDED.CalcCount, CalcSumm = EXCLUDED.CalcSumm, CalcCount_external = EXCLUDED.CalcCount_external
                 , CalcSumm_external = EXCLUDED.CalcSumm_external, OutCount = EXCLUDED.OutCount, OutSumm = EXCLUDED.OutSumm
                 , MovementItemId_diff = EXCLUDED.MovementItemId_diff, Summ_diff = EXCLUDED.Summ_diff;  
                 
     GET DIAGNOSTICS vbCountInsert = ROW_COUNT;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT, text_var2 = PG_EXCEPTION_DETAIL;
   END;
   
   RETURN QUERY
   SELECT (text_var1||COALESCE('; '||text_var2, ''))::TBlob, vbCountRecord, vbCountDelete, vbCountInsert;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.09.23                                                       * 
*/

-- SELECT * FROM _replica.HistoryCost_Rewiring
-- 7620680f-e57e-4d91-a52e-c3e90c4989b7
-- SELECT * FROM _replica.gpInsertUpdate_HistoryCost_Rewiring (inStartDate:= '01.09.2023', inEndDate:= '27.09.2023', inBranchId:= 8379, inItearationCount:= 50, inDiffSumm:= 1, inisMICSlave := True, inSession:= zfCalc_UserAdmin());