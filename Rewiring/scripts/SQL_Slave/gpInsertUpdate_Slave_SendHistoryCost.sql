-- Function: gpInsertUpdate_Slave_SendHistoryCost (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpInsertUpdate_Slave_SendHistoryCost (TVarChar, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpInsertUpdate_Slave_SendHistoryCost(
    IN inRewiringUUId    TVarChar,   -- UUId ��� �������� ������ 
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inBranchId        Integer   , --
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, HistoryCosDel Integer, HistoryCosCount Integer) 
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

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_MasterConnectParams(inSession);  
                          
   -- ��������� �� ������� � �������� ����� HistoryCost
   CREATE TEMP TABLE tmpHistoryCost ON COMMIT DROP AS
   SELECT Q.Id, q.ContainerId, q.StartDate, q.EndDate, q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm, q.CalcCount, 
          q.CalcSumm, q.CalcCount_external, q.CalcSumm_external, q.OutCount, q.OutSumm, q.MovementItemId_diff, q.Summ_diff
   FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
               'SELECT Id, ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, 
                       CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff 
                       FROM _replica.gpInsertUpdate_Master_LoadHistoryCost(inRewiringUUId := '''||inRewiringUUId||''',
                       inStartDate:= '''||TO_CHAR (inStartDate, 'yyyy-mm-dd')||''', 
                       inEndDate:= '''||TO_CHAR (inEndDate, 'yyyy-mm-dd')||''', 
                       inBranchId := '||inBranchId::Text||', 
                       inSession := '''||inSession||''')') AS 
                 q(Id Integer, ContainerId Integer, StartDate TDateTime, EndDate TDateTime, Price TFloat, Price_external TFloat, StartCount TFloat, 
                   StartSumm TFloat, IncomeCount TFloat, IncomeSumm TFloat, CalcCount TFloat, CalcSumm TFloat, CalcCount_external TFloat, 
                   CalcSumm_external TFloat, OutCount TFloat, OutSumm TFloat, MovementItemId_diff Integer, Summ_diff TFloat);  
      
   raise notice '�������� : %', (SELECT COUNT(*) FROM tmpHistoryCost);

   --  ��������� HistoryCost
   IF inBranchId > 0
   THEN
         -- ������� ���������� �/� - !!!��� 1-��� �������!!!
   
         DELETE FROM HistoryCost
         WHERE HistoryCost.StartDate   IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
           AND HistoryCost.ContainerId IN (SELECT q.ContainerId
                                           FROM _replica.Container_branch_Rewiring AS q WHERE q.RewiringUUId ILIKE inRewiringUUId);
                                                                  
   ELSE                                                                                                                                  
         -- ������� ���������� �/� - !!!����� ���� ��������!!!
         
         DELETE FROM HistoryCost
         WHERE HistoryCost.StartDate       IN (SELECT DISTINCT tmp.StartDate FROM HistoryCost AS tmp WHERE tmp.StartDate BETWEEN inStartDate AND inEndDate)
           AND HistoryCost.ContainerId NOT IN (SELECT q.ContainerId
                                           FROM _replica.Container_branch_Rewiring AS q WHERE q.RewiringUUId ILIKE inRewiringUUId);

   END IF; -- if inBranchId > 0

   GET DIAGNOSTICS vbHistoryCosDel = ROW_COUNT; 

   raise notice '������� HistoryCost <%>', vbHistoryCosDel;

   INSERT INTO HistoryCost (Id, ContainerId, StartDate, EndDate, Price, Price_external, StartCount, StartSumm, IncomeCount, IncomeSumm, 
                            CalcCount, CalcSumm, CalcCount_external, CalcSumm_external, OutCount, OutSumm, MovementItemId_diff, Summ_diff)
   SELECT q.Id, q.ContainerId, q.StartDate, q.EndDate, q.Price, q.Price_external, q.StartCount, q.StartSumm, q.IncomeCount, q.IncomeSumm, 
          q.CalcCount, q.CalcSumm, q.CalcCount_external, q.CalcSumm_external, q.OutCount, q.OutSumm, q.MovementItemId_diff, q.Summ_diff
   FROM tmpHistoryCost AS q 
   ON CONFLICT ON CONSTRAINT historycost_pkey 
   DO UPDATE SET ContainerId = EXCLUDED.ContainerId, StartDate = EXCLUDED.StartDate, EndDate = EXCLUDED.EndDate
               , Price = EXCLUDED.Price, Price_external = EXCLUDED.Price_external, StartCount = EXCLUDED.StartCount
               , StartSumm = EXCLUDED.StartSumm, IncomeCount = EXCLUDED.IncomeCount, IncomeSumm = EXCLUDED.IncomeSumm
               , CalcCount = EXCLUDED.CalcCount, CalcSumm = EXCLUDED.CalcSumm, CalcCount_external = EXCLUDED.CalcCount_external
               , CalcSumm_external = EXCLUDED.CalcSumm_external, OutCount = EXCLUDED.OutCount, OutSumm = EXCLUDED.OutSumm
               , MovementItemId_diff = EXCLUDED.MovementItemId_diff, Summ_diff = EXCLUDED.Summ_diff;  
                   
   GET DIAGNOSTICS vbHistoryCosCount = ROW_COUNT; 

   raise notice '������� HistoryCost <%>', vbHistoryCosCount;

   raise notice '��������� HistoryCost_Rewiring � Container_branch_Rewiring';
   
   DELETE FROM _replica.HistoryCost_Rewiring WHERE HistoryCost_Rewiring.RewiringUUId ILIKE inRewiringUUId;
   DELETE FROM _replica.Container_branch_Rewiring WHERE Container_branch_Rewiring.RewiringUUId ILIKE inRewiringUUId;

      -- ���������
   RETURN QUERY
   SELECT 1 AS Id, COALESCE(vbHistoryCosDel, 0) AS HistoryCosDel, COALESCE(vbHistoryCosCount, 0) AS HistoryCosCount;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.23                                                       * 
*/

-- ����

-- select * from _replica.gpInsertUpdate_Slave_SendHistoryCost(inRewiringUUId := '7620680f-e57e-4d91-a52e-c3e90c4989b7', inStartDate:= '01.09.2023', inEndDate:= '30.09.2023', inBranchId:= 8379, inSession:= zfCalc_UserAdmin());