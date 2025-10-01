-- Function: gpInsert_bi_Table_JuridicalSold

DROP FUNCTION IF EXISTS gpInsert_bi_Table_JuridicalSold (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_JuridicalSold(
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
          DELETE FROM _bi_Table_JuridicalSold WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- ���������
      INSERT INTO _bi_Table_JuridicalSold (--
                                           OperDate
                                           -- Id ������
                                         , ContainerId
                                           -- ����
                                         , AccountId
                                           -- ��.�.
                                         , JuridicalId
                                           -- ����������
                                         , PartnerId
                                           -- �������
                                         , ContractId
                                           -- ��
                                         , PaidKindId
                                           -- �� ������
                                         , InfoMoneyId
                                           -- ������
                                         , BranchId
                                           -- ���������� ����
                                         , PartionMovementId

                                           -- ��������� ���� ���������� - ���� ���
                                         , StartSumm_a
                                           -- �������� ���� ���������� - ���� ���
                                         , EndSumm_a
                                           -- ��������� ���� ��������� - ���� ��
                                         , StartSumm_p
                                           -- �������� ���� ��������� - ���� ��
                                         , EndSumm_p

                                           -- Debet
                                         , DebetSumm
                                           -- Kredit
                                         , KreditSumm

                                           -- ������ �� ���������� - ���� ��
                                         , IncomeSumm_p
                                           -- ������� ���������� - ���� ��
                                         , ReturnOutSumm_p

                                           -- ������� (���� ��� ��. ������) - ���� ���
                                         , SaleRealSumm_total_a
                                           -- ������� �� ���. (���� ��� ��. ������) - ���� ���
                                         , ReturnInRealSumm_total_a
                                           -- ������� (���� � ��. ������) - ���� ���
                                         , SaleRealSumm_a
                                           -- ������� �� ���. (���� � ��. ������) - ���� ���
                                         , ReturnInRealSumm_a

                                           -- ������ ���� ������. - ���� ���
                                         , ServiceRealSumm_a
                                           -- ������ ���� �����. - ���� ��
                                         , ServiceRealSumm_p
                                           -- ������ ���� - ���� ���
                                         , MoneySumm_a
                                           -- ������ ���� - ���� ��
                                         , MoneySumm_p
                                           -- ����. ���� - ���� ���
                                         , PriceCorrectiveSumm_p
                                           -- ��-�����
                                         , SendDebtSumm_a
                                         , SendDebtSumm_p
                                           -- ������
                                         , OthSumm_a
                                         , OthSumm_p
                                          )
              -- 1.1. ��������� - 30101 - �������� + ���������� + ���������
              SELECT tmpReport.OperDate
                   , tmpReport.ContainerId
                   , tmpReport.AccountId
                   , tmpReport.JuridicalId
                   , tmpReport.PartnerId
                   , tmpReport.ContractId
                   , tmpReport.PaidKindId
                   , tmpReport.InfoMoneyId
                   , tmpReport.BranchId

                     -- ��������� ���� ���������� - ���� ���
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- �������� ���� ���������� - ���� ���
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- ��������� ���� ��������� - ���� ��
                   , 0 AS StartSumm_p
                     -- �������� ���� ��������� - ���� ��
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- ������ �� ���������� - ���� �� * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- ������� ���������� - ���� ��
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- ������� (���� ��� ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- ������� �� ���. (���� ��� ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- ������� (���� � ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- ������� �� ���. (���� � ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- ������ ���� ������. - ���� ��� * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- ������ ���� �����. - ���� ��
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- ������ ���� - ���� ��� * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- ������ ���� - ���� ��
                   , 0                                        AS MoneySumm_p

                     -- ����. ���� - ���� ���
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- ����. ���� - ���� ��
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- ��-����� - ���� ��� -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- ��-����� - ���� ��
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- ������ - ���� ���
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- ������ - ���� ��
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30101 - �������� + ���������� + ���������
                                            , inAccountId              := zc_Enum_Account_30101()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 1.2. ��������� - 30102 - �������� + ���������� + ������ �����
              SELECT tmpReport.OperDate
                   , tmpReport.ContainerId
                   , tmpReport.AccountId
                   , tmpReport.JuridicalId
                   , tmpReport.PartnerId
                   , tmpReport.ContractId
                   , tmpReport.PaidKindId
                   , tmpReport.InfoMoneyId
                   , tmpReport.BranchId

                     -- ��������� ���� ���������� - ���� ���
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- �������� ���� ���������� - ���� ���
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- ��������� ���� ��������� - ���� ��
                   , 0 AS StartSumm_p
                     -- �������� ���� ��������� - ���� ��
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- ������ �� ���������� - ���� �� * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- ������� ���������� - ���� ��
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- ������� (���� ��� ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- ������� �� ���. (���� ��� ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- ������� (���� � ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- ������� �� ���. (���� � ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- ������ ���� ������. - ���� ��� * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- ������ ���� �����. - ���� ��
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- ������ ���� - ���� ��� * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- ������ ���� - ���� ��
                   , 0                                        AS MoneySumm_p

                     -- ����. ���� - ���� ���
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- ����. ���� - ���� ��
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- ��-����� - ���� ��� -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- ��-����� - ���� ��
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- ������ - ���� ���
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- ������ - ���� ��
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30102 - �������� + ���������� + ������ �����
                                            , inAccountId              := zc_Enum_Account_30102()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 1.3. ��������� - 30151 - �������� + ���������� ��� + ���������
              SELECT tmpReport.OperDate
                   , tmpReport.ContainerId
                   , tmpReport.AccountId
                   , tmpReport.JuridicalId
                   , tmpReport.PartnerId
                   , tmpReport.ContractId
                   , tmpReport.PaidKindId
                   , tmpReport.InfoMoneyId
                   , tmpReport.BranchId

                     -- ��������� ���� ���������� - ���� ���
                   , SUM (tmpReport.StartSumm) AS StartSumm_a
                     -- �������� ���� ���������� - ���� ���
                   , SUM (tmpReport.EndSumm)   AS EndSumm_a

                    -- ��������� ���� ��������� - ���� ��
                   , 0 AS StartSumm_p
                     -- �������� ���� ��������� - ���� ��
                   , 0 AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- ������ �� ���������� - ���� �� * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- ������� ���������� - ���� ��
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- ������� (���� ��� ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- ������� �� ���. (���� ��� ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- ������� (���� � ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- ������� �� ���. (���� � ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- ������ ���� ������. - ���� ��� * -1
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_a
                     -- ������ ���� �����. - ���� ��
                   , SUM (CASE WHEN tmpReport.ServiceRealSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS ServiceRealSumm_p

                     -- ������ ���� - ���� ��� * -1
                   , SUM (tmpReport.MoneySumm)                AS MoneySumm_a
                     -- ������ ���� - ���� ��
                   , 0                                        AS MoneySumm_p

                     -- ����. ���� - ���� ���
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- ����. ���� - ���� ��
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- ��-����� - ���� ��� -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- ��-����� - ���� ��
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- ������ - ���� ���
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_a
                     -- ������ - ���� ��
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm + tmpReport.ServiceSumm_pls) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- 30151 - �������� + ���������� ��� + ���������
                                            , inAccountId              := zc_Enum_Account_30151()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

             UNION ALL
              -- 2.1. ��������� - �� - 50401 - ������� ������� �������� + ������ �� ���������� + ���������
              SELECT tmpReport.OperDate
                   , tmpReport.ContainerId
                   , tmpReport.AccountId
                   , tmpReport.JuridicalId
                   , tmpReport.PartnerId
                   , tmpReport.ContractId
                   , tmpReport.PaidKindId
                   , tmpReport.InfoMoneyId
                   , tmpReport.BranchId

                     -- ��������� ���� ���������� - ���� ���
                   , 0 AS StartSumm_a
                     -- �������� ���� ���������� - ���� ���
                   , 0 AS EndSumm_a

                    -- ��������� ���� ��������� - ���� ��
                   , -1 * SUM (tmpReport.StartSumm) AS StartSumm_p
                     -- �������� ���� ��������� - ���� ��
                   , -1 * SUM (tmpReport.EndSumm)   AS EndSumm_p

                     -- Debet
                   , SUM (tmpReport.DebetSumm)   AS DebetSumm
                     -- Kredit
                   , SUM (tmpReport.KreditSumm)  AS KreditSumm

                     -- ������ �� ���������� - ���� �� * -1
                   , SUM (tmpReport.IncomeSumm)   AS IncomeSumm_p
                     -- ������� ���������� - ���� ��
                   , SUM (tmpReport.ReturnOutSumm)   AS ReturnOutSumm_p

                     -- ������� (���� ��� ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm_total)       AS SaleRealSumm_total_a
                     -- ������� �� ���. (���� ��� ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm_total)   AS ReturnInRealSumm_total_a
                     -- ������� (���� � ��. ������) - ���� ���
                   , SUM (tmpReport.SaleRealSumm)             AS SaleRealSumm_a
                     -- ������� �� ���. (���� � ��. ������) - ���� ��� * -1
                   , SUM (tmpReport.ReturnInRealSumm)         AS ReturnInRealSumm_a

                     -- ������ ���� ������. - ���� ��� * -1
                   , 0 AS ServiceRealSumm_a
                     -- ������ ���� �����. - ���� ��
                   , SUM (tmpReport.ServiceSumm_pls) AS ServiceRealSumm_p

                     -- ������ ���� - ���� ��� * -1
                   , 0                               AS MoneySumm_a
                     -- ������ ���� - ���� ��
                   , -1 * SUM (tmpReport.MoneySumm)  AS MoneySumm_p

                     -- ����. ���� - ���� ���
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm > 0 THEN  1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_a
                     -- ����. ���� - ���� ��
                   , SUM (CASE WHEN tmpReport.PriceCorrectiveSumm < 0 THEN -1 * tmpReport.PriceCorrectiveSumm ELSE 0 END) AS PriceCorrectiveSumm_p

                     -- ��-����� - ���� ��� -1
                   , SUM (CASE WHEN tmpReport.SendDebtSumm < 0 THEN -1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_a
                     -- ��-����� - ���� ��
                   , SUM (CASE WHEN tmpReport.SendDebtSumm > 0 THEN  1 * tmpReport.ServiceRealSumm ELSE 0 END) AS SendDebtSumm_p

                     -- ������ - ���� ���
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm > 0 THEN  1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm) ELSE 0 END) AS OthSumm_a
                     -- ������ - ���� ��
                   , SUM (CASE WHEN tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm < 0 THEN -1 * (tmpReport.ChangeCurrencySumm + tmpReport.OtherSumm - tmpReport.ServiceRealSumm) ELSE 0 END) AS OthSumm_p

              FROM lpReport_bi_JuridicalSold (inStartDate              := inStartDate
                                            , inEndDate                := inEndDate
                                              -- �� - 50401 - ������� ������� �������� + ������ �� ���������� + ���������
                                            , inAccountId              := zc_Enum_Account_50401()
                                            , inInfoMoneyId            := 0
                                            , inInfoMoneyGroupId       := 0
                                            , inInfoMoneyDestinationId := 0
                                            , inPaidKindId             := 0
                                            , inIsPartionMovement      := FALSE
                                            , inUserId                 := zfCalc_UserAdmin() :: Integer
                                             ) AS tmpReport
              GROUP BY tmpReport.ContainerId
                     , tmpReport.AccountId
                     , tmpReport.OperDate
                     , tmpReport.JuridicalId
                     , tmpReport.PartnerId
                     , tmpReport.InfoMoneyId
                     , tmpReport.ContractId
                     , tmpReport.PaidKindId
                     , tmpReport.BranchId

-- 30101 - �������� + ���������� + ���������
-- 30102 - �������� + ���������� + ������ �����
-- 30151 - �������� + ���������� ��� + ���������

-- �� - 50401 - ������� ������� �������� + ������ �� ���������� + ���������
-- ��� - 70301 - ������ �� ����������	���������


             ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.25                                        * all
*/

-- ����
-- DELETE FROM  _bi_Table_JuridicalSold WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT OperDate, AccountName_all, sum(StartSumm_a), sum(StartSumm_p)  FROM _bi_Table_JuridicalSold left join _bi_Guide_Account_View on _bi_Guide_Account_View.Id = _bi_Table_JuridicalSold.AccountId where OperDate between '01.09.2025' and '01.09.2025' GROUP BY OperDate, AccountName_all ORDER BY 1 DESC, 2
-- SELECT * FROM gpInsert_bi_Table_JuridicalSold (inStartDate:= '01.09.2025', inEndDate:= '30.09.2025', inSession:= zfCalc_UserAdmin())
