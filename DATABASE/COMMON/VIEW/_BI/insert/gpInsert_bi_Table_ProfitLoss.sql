-- Function: gpInsert_bi_Table_ProfitLoss

DROP FUNCTION IF EXISTS gpInsert_bi_Table_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_ProfitLoss(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_ProfitLoss WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- ���������
      INSERT INTO _bi_Table_ProfitLoss (-- Id ������
                                        ContainerId_pl
                                        -- ����
                                      , OperDate
                                        -- Id ���������
                                      , MovementId
                                        -- ��� ���������
                                      , MovementDescId
                                        -- � ���������
                                      , InvNumber
                                        -- ���������� ��������
                                      , MovementId_comment

                                        -- ������ ����
                                      , ProfitLossId
                                        -- ������
                                      , BusinessId

                                        -- ������ ������ (Գ��)
                                      , BranchId_pl
                                        -- ������������� ������ (ϳ������)
                                      , UnitId_pl

                                        -- ������ ��
                                      , InfoMoneyId

                                        -- ������������� ����� (̳��� �����)
                                      , UnitId
                                        -- ������������ (����������� ������)
                                      , AssetId
                                        -- ���������� (����������� ������, ����� �����)
                                      , CarId
                                        -- ��� ����
                                      , MemberId
                                        -- ������ �������� (������ ��������, ����������� ������)
                                      , ArticleLossId

                                        -- ��'��� �����������
                                      , DirectionId
                                        -- ��'��� �����������
                                      , DestinationId

                                        -- �� ���� (����� �����) - ������������
                                      , FromId
                                        -- ���� (����� �����, ����������� ������) - ������������
                                      , ToId

                                        -- �����
                                      , GoodsId
                                        -- ��� ������
                                      , GoodsKindId
                                        -- ��� ������ (������ ��� ������������ ����� ��)
                                      , GoodsKindId_gp

                                        -- ���-�� (���)
                                      , OperCount
                                        -- ���-�� (��.)
                                      , OperCount_sh
                                        -- �����
                                      , OperSumm
                                       )
              -- ���������
              SELECT ContainerId_pl
                     -- ����
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN inEndDate ELSE tmpReport.OperDate END AS OperDate
                     -- Id ���������
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE MovementId END AS MovementId
                     -- ��� ���������
                   , tmpReport.MovementDescId
                     -- � ���������
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE zfConvert_StringToNumber (Movement.InvNumber) END AS InvNumber
                     -- ���������� ��������
                   , MovementId_comment

                     -- ������ ����
                   , ProfitLossId
                     -- ������
                   , BusinessId

                     -- ������ ������ (Գ��)
                   , BranchId_pl
                     -- ������������� ������ (ϳ������)
                   , UnitId_pl

                     -- ������ ��
                   , InfoMoneyId

                     -- ������������� ����� (̳��� �����)
                   , UnitId
                     -- ������������ (����������� ������)
                   , AssetId
                     -- ���������� (����������� ������, ����� �����)
                   , CarId
                     -- ��� ����
                   , MemberId
                     -- ������ �������� (������ ��������, ����������� ������)
                   , ArticleLossId

                     -- ��'��� �����������
                   , DirectionId
                     -- ��'��� �����������
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE DestinationId END AS DestinationId

                     -- �� ���� (����� �����) - ������������
                   , FromId
                     -- ���� (����� �����, ����������� ������) - ������������
                   , ToId

                     -- �����
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsId END AS GoodsId
                     -- ��� ������
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId END AS GoodsKindId
                     -- ��� ������ (������ ��� ������������ ����� ��)
                   , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId_gp END AS GoodsKindId_gp

                     -- ���-�� (���)
                   , SUM (OperCount)
                     -- ���-�� (��.)
                   , SUM (OperCount_sh)
                     -- �����
                   , SUM (OperSumm)

              FROM lpReport_bi_ProfitLoss (inStartDate              := inStartDate
                                         , inEndDate                := inEndDate
                                         , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
                   LEFT JOIN Movement ON Movement.Id = MovementId
              GROUP BY ContainerId_pl
                       -- ����
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN inEndDate ELSE tmpReport.OperDate END
                       -- Id ���������
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE MovementId END
                       -- ��� ���������
                     , tmpReport.MovementDescId
                       -- � ���������
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE zfConvert_StringToNumber (Movement.InvNumber) END
                       -- ���������� ��������
                     , MovementId_comment
  
                       -- ������ ����
                     , ProfitLossId
                       -- ������
                     , BusinessId
  
                       -- ������ ������ (Գ��)
                     , BranchId_pl
                       -- ������������� ������ (ϳ������)
                     , UnitId_pl
  
                       -- ������ ��
                     , InfoMoneyId
  
                       -- ������������� ����� (̳��� �����)
                     , UnitId
                       -- ������������ (����������� ������)
                     , AssetId
                       -- ���������� (����������� ������, ����� �����)
                     , CarId
                       -- ��� ����
                     , MemberId
                       -- ������ �������� (������ ��������, ����������� ������)
                     , ArticleLossId
  
                       -- ��'��� �����������
                     , DirectionId
                       -- ��'��� �����������
                     , DestinationId
  
                       -- �� ���� (����� �����) - ������������
                     , FromId
                       -- ���� (����� �����, ����������� ������) - ������������
                     , ToId
  
                       -- �����
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsId END
                       -- ��� ������
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId END
                       -- ��� ������ (������ ��� ������������ ����� ��)
                     , CASE WHEN ProfitLossCode < 11100 AND 1=0 THEN 0 ELSE GoodsKindId_gp END

                 HAVING SUM (OperCount) <> 0 OR SUM (OperSumm) <> 0
                ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.25                                        * all
*/

/*
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.08.2025', inEndDate:= '31.08.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.07.2025', inEndDate:= '31.07.2025', inSession:= zfCalc_UserAdmin())


SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.01.2025', inEndDate:= '31.01.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.02.2025', inEndDate:= '28.02.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.03.2025', inEndDate:= '31.03.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.04.2025', inEndDate:= '30.04.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.05.2025', inEndDate:= '31.05.2025', inSession:= zfCalc_UserAdmin())
SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.06.2025', inEndDate:= '30.06.2025', inSession:= zfCalc_UserAdmin())
*/
-- ����
-- DELETE FROM  _bi_Table_ProfitLoss WHERE OperDate between '20.07.2025' and '20.07.2025'
-- SELECT OperDate, AccountName_all, sum(StartSumm_a), sum(StartSumm_p)  FROM _bi_Table_ProfitLoss left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_ProfitLoss.AccountId where OperDate between '01.09.2025' and '01.09.2025' GROUP BY OperDate, AccountName_all ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_ProfitLoss (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
