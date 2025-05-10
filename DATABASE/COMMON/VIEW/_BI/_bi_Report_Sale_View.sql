-- View: _bi_Report_Sale_View

DROP VIEW IF EXISTS _bi_Report_Sale_View;

-- ��������� - �������
CREATE OR REPLACE VIEW _bi_Report_Sale_View
AS

   WITH -- ��������� ��� �������
        tmpAnalyzer AS (SELECT -- ���������
                               Constant_ProfitLoss_AnalyzerId_View.AnalyzerId, Constant_ProfitLoss_AnalyzerId_View.ValueData AS AnalyzerName
                               -- ��� ������� ��� �������
                             , Constant_ProfitLoss_AnalyzerId_View.isSale
                               -- ��� �/� ��/���
                             , Constant_ProfitLoss_AnalyzerId_View.isCost
                               -- ��� ����� ��� ���-��
                             , Constant_ProfitLoss_AnalyzerId_View.isSumm
                        FROM Constant_ProfitLoss_AnalyzerId_View
                       )
        -- ���� ��� ����� + ���
     /*, tmpGoodsByGoodsKind AS (SELECT
                                      ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS Id
                                    , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                    , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               )*/
        -- ���������
              -- ������� / �������
              SELECT -- Id ���������
                     MIContainer.MovementId
                     -- , tmpAnalyzer.AnalyzerId
                     -- ��� ���������
                   , MIContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- ���� ����������
                   , MIContainer.OperDate
                     -- ���� �����
                   , Movement.OperDate AS OperDate_sklad
                     -- � ���������
                   , Movement.InvNumber

                     -- ��. ����
                   , CLO_Juridical.ObjectId                AS JuridicalId
                     -- ����������
                   , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service()
                               THEN MIContainer.ObjectId_Analyzer
                          ELSE MIContainer.ObjectExtId_Analyzer
                          --ELSE MovementLinkObject_Partner.ObjectId
                     END :: Integer AS PartnerId

                     -- �� ������ ����������
                   , CLO_InfoMoney.ObjectId                      AS InfoMoneyId
                     -- ����� ������
                   , CLO_PaidKind.ObjectId                       AS PaidKindId
                     -- ����� ������ - ������� ���������� �����
                   , CLO_PaidKind.ObjectId                       AS PaidKindId_bonus
                     -- ������
                   , MILinkObject_Branch.ObjectId                AS BranchId
                     -- �������
                   , CLO_Contract.ObjectId                       AS ContractId

                     -- �����
                   , MIContainer.ObjectId_Analyzer               AS GoodsId
                   , Object_Goods.ObjectCode                     AS GoodsCode
                   , Object_Goods.ValueData                      AS GoodsName
                     -- ��� ������
                   , MIContainer.ObjectIntId_Analyzer            AS GoodsKindId
                   , Object_GoodsKind.ObjectCode                 AS GoodsKindCode
                   , Object_GoodsKind.ValueData                  AS GoodsKindName
                     -- ��.���. ������
                   , Object_Measure.ObjectCode                   AS MeasureCode
                   , Object_Measure.ValueData                    AS MeasureName

                     -- �������� �����
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- ������� ����� ��/���
                   , CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- ���� ������� ����� - ���
                   , 0  :: Integer  AS ContractConditionKindId
                   , '' :: TVarChar AS ContractConditionKindName
                     -- ��� ������ - ���
                   , 0  :: Integer  AS BonusKindId
                   , '' :: TVarChar AS BonusKindName
                     -- % ������ - ���
                   , 0  :: TFloat   AS BonusTax


                     -- ��� ������� - �� ������
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                              THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_sh

                     -- ��� ������� - �� �����
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_Amount
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                              THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_Amount_sh


                     -- ����� - ��� �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END
                         ) :: TFloat AS AmountPartner_promo
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * MIContainer.Amount
                               ELSE 0
                          END
                         ) :: TFloat AS AmountPartner_promo_sh

                     -- ��� ������� � ����������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_AmountPartner
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                                                                                      THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_AmountPartner_sh

                     -- ��� ������� � ����������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_AmountPartner
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_AmountPartner_sh

                     -- ��� ������ �� ��� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     THEN -1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_10500
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN -1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_10500_sh

                     -- ��� ������ - ������� � ���� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_40200
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Sale_Amount_40200_sh

                     -- ��� ������ - ������� � ���� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN  1 * MIContainer.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Return_Amount_40200
                     -- ��.
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                                      THEN  1 * MIContainer.Amount
                               ELSE 0
                          END) :: TFloat AS Return_Amount_40200_sh


                     -- ����� - ����� �������
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE AND MIFloat_PromoMovement.ValueData > 0 THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_promo
                     -- ����� �������
                   , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ
                     -- ����� �������
                   , SUM (CASE WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ

                     -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10200() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10200
                     -- ����� ������� - ������-�����
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10250() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10250
                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10300

                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10300() THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ_10300
                     -- ����� ������� - ???���� ������ ���???
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10700() THEN 1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Return_Summ_10700

                     -- ����� - ����� �/� �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN -1 * COALESCE (MIContainer.Amount, 0)
                               ELSE 0
                          END) :: TFloat AS Sale_SummCost_promo


                     -- ����� �/� �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost
                     -- ����� �/� ������ �� ��� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost_10500
                     -- ����� �/� ������ - ������� � ���� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() THEN      COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Sale_SummCost_40200

                     -- ����� �/� �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Return_SummCost
                     -- ����� �/� ������ - ������� � ���� - �������
                   , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) :: TFloat AS Return_SummCost_40200


                     -- ������� - ����� ����� �� �������� - ���
                   , 0 :: TFloat  AS BonusBasis
                     -- ������� - ����� ����� "������"
                   , 0 :: TFloat  AS Bonus

              FROM tmpAnalyzer
                   -- ��������
                   INNER JOIN MovementItemContainer AS MIContainer
                                                    ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                 --AND MIContainer.OperDate   BETWEEN inStartDate AND inEndDate
                   -- ��. ����
                   INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                  ON CLO_Juridical.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                   -- �� ������ ����������
                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                  ON CLO_InfoMoney.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                   -- ����� ������
                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                  ON CLO_PaidKind.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                 AND CLO_PaidKind.DescId       = zc_ContainerLinkObject_PaidKind()
                   -- �������
                   LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                 ON CLO_Contract.ContainerId = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Service(), zc_Movement_PriceCorrective()) THEN MIContainer.ContainerId ELSE MIContainer.ContainerId_Analyzer END
                                                AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                   -- ������ - �� �� �������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                    ON MILinkObject_Branch.MovementItemId = MIContainer.MovementItemId
                                                   AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                   -- �������� ����� - �� �� �������
                   LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                               ON MIFloat_PromoMovement.MovementItemId = MIContainer.MovementItemId
                                              AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                   -- ��������
                   LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                   -- ��� ���������
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                   -- �����
                   LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MIContainer.ObjectId_Analyzer
                   -- ��� ������
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MIContainer.ObjectIntId_Analyzer

                   -- ��.���. ������
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                   -- ��� ������
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

              GROUP BY MIContainer.MovementId
                       --, tmpAnalyzer.AnalyzerId
                     , MIContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MIContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service()
                                 THEN MIContainer.ObjectId_Analyzer
                            ELSE MIContainer.ObjectExtId_Analyzer
                            --ELSE MovementLinkObject_Partner.ObjectId
                       END
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , MILinkObject_Branch.ObjectId
                     , CLO_Contract.ObjectId
                     , MIContainer.ObjectId_Analyzer
                     , Object_Goods.ObjectCode
                     , Object_Goods.ValueData
                     , MIContainer.ObjectIntId_Analyzer
                     , Object_GoodsKind.ObjectCode
                     , Object_GoodsKind.ValueData
                     , Object_Measure.ObjectCode
                     , Object_Measure.ValueData
                     , MIFloat_PromoMovement.ValueData

             UNION ALL
              -- ���������� ������� - �������
              SELECT -- Id ���������
                     MovementItemContainer.MovementId
                     --, 0 :: Integer AS AnalyzerId
                     -- ��� ���������
                   , MovementItemContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- ���� ���������
                   , MovementItemContainer.OperDate
                     -- ���� ���������
                   , Movement.OperDate AS OperDate_sklad
                     -- � ���������
                   , Movement.InvNumber

                     -- ��. ����
                   , CLO_Juridical.ObjectId          AS JuridicalId
                   , 0                               AS PartnerId
                     -- �� ������ ����������
                   , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                     -- ����� ������ - ������� ������� / �������� ���������� �����
                   , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                     -- ����� ������ - �������� ���������� �����
                   , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                     -- ������
                   , 0                               AS BranchId
                     -- ������� ������� / ������� ���������� �����
                   , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                     -- ����� - ���
                   , 0  :: Integer  AS GoodsId
                   , 0  :: Integer  AS GoodsCode
                   , '' :: TVarChar AS GoodsName
                     -- ��� ������ - ���
                   , 0  :: Integer  AS GoodsKindId
                   , 0  :: Integer  AS GoodsKindCode
                   , '' :: TVarChar AS GoodsKindName
                     -- ��.���. ������ - ���
                   , 0  :: Integer  AS MeasureCode
                   , '' :: TVarChar AS MeasureName

                     -- �������� ����� - ���
                   , 0 :: Integer AS MovementId_promo
                     -- ������� ����� ��/���
                   , FALSE :: Boolean AS isPromo

                     -- ��� ������� �����
                   , Object_ContractConditionKind.Id                      AS ContractConditionKindId
                   , Object_ContractConditionKind.ValueData               AS ContractConditionKindName
                     -- ��� ������
                   , Object_BonusKind.Id                                  AS BonusKindId
                   , Object_BonusKind.ValueData                           AS BonusKindName
                     -- % ������
                   , COALESCE (MIFloat_BonusValue.ValueData,0)  :: TFloat AS BonusTax

                     -- ���-�� ������� - �� ������
                   , 0 :: TFloat AS Sale_Amount
                   , 0 :: TFloat 
                     -- ���-�� ������� - �� �����
                   , 0 :: TFloat AS Return_Amount
                   , 0 :: TFloat 

                     -- ����� - ���-�� �������
                   , 0 :: TFloat AS AmountPartner_promo
                   , 0 :: TFloat 
                     -- ���-�� ������� � ����������
                   , 0 :: TFloat AS Sale_AmountPartner
                   , 0 :: TFloat 
                     -- ���-�� ������� � ����������
                   , 0 :: TFloat AS Return_AmountPartner
                   , 0 :: TFloat 

                     -- ���-�� ������ �� ��� - �������
                   , 0 :: TFloat AS Sale_Amount_10500
                   , 0 :: TFloat 
                     -- ���-�� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Sale_Amount_40200
                   , 0 :: TFloat 
                     -- ���-�� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Return_Amount_40200
                   , 0 :: TFloat 

                     -- ����� - ����� �������
                   , 0 :: TFloat AS Sale_Summ_promo
                     -- ����� �������
                   , 0 :: TFloat AS Sale_Summ
                     -- ����� �������
                   , 0 :: TFloat AS Return_Summ

                     -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
                   , 0 :: TFloat AS Sale_Summ_10200
                     -- ����� ������� - ������-�����
                   , 0 :: TFloat AS Sale_Summ_10250
                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , 0 :: TFloat AS Sale_Summ_10300

                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , 0 :: TFloat AS Return_Summ_10300
                     -- ����� ������� - ???���� ������ ���???
                   , 0 :: TFloat AS Return_Summ_10700

                     -- ����� - ����� �/� �������
                   , 0 :: TFloat AS Sale_SummCost_promo
                     -- ����� �/� �������
                   , 0 :: TFloat AS Sale_SummCost
                     -- ����� �/� ������ �� ��� - �������
                   , 0 :: TFloat AS Sale_SummCost_10500
                     -- ����� �/� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Sale_SummCost_40200

                     -- ����� �/� �������
                   , 0 :: TFloat AS Return_SummCost
                     -- ����� �/� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Return_SummCost_40200

                     -- ������� - ����� ����� �� ��������
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                  --THEN COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                                    THEN -1 * MovementItemContainer.Amount
                               ELSE 0
                          END) AS BonusBasis
                     -- ������� - ����� ����� "������"
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN 0
                             --ELSE COALESCE (MovementItem.Amount, -1 * MovementItemContainer.Amount)
                               ELSE -1 * MovementItemContainer.Amount
                          END) AS Bonus
              -- ��������
              FROM Movement
                   -- ��������
                   INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                   AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                                                 --AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                   -- !!!������� ������� �������� + ������ �� ����������!!!
                   INNER JOIN Container ON Container.Id       = MovementItemContainer.ContainerId
                                       AND Container.ObjectId = zc_Enum_Account_50401()

                   -- ��. ���� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                   -- ����� ������ - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_PaidKind  ON CLO_PaidKind.ContainerId  = Container.Id AND CLO_PaidKind.DescId  = zc_ContainerLinkObject_PaidKind()
                   -- ������� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                   -- �� ������ ���������� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()

                   -- ������� �������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                    ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                   AND MILinkObject_ContractChild.DescId         = zc_MILinkObject_ContractChild()
                   -- ����� ������ - ������� �������
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                        ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                       AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                   -- �������������� ������������
                   LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                             ON MovementBoolean_isLoad.MovementId = Movement.Id
                                            AND MovementBoolean_isLoad.DescId     = zc_MovementBoolean_isLoad()

                   -- ������ ���������
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE

                   -- ��� ������� �����
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                    ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_ContractConditionKind.DescId         = zc_MILinkObject_ContractConditionKind()
                   LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

                   -- ��� ������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                    ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()
                   LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

                   -- % ������
                   LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                               ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_BonusValue.DescId         = zc_MIFloat_BonusValue()
                   -- ��� ���������
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

              WHERE Movement.DescId = zc_Movement_ProfitLossService()
              GROUP BY MovementItemContainer.MovementId
                     , MovementItemContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MovementItemContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , CLO_Contract.ObjectId
                     , MILinkObject_ContractChild.ObjectId
                     , Object_ContractConditionKind.Id
                     , Object_ContractConditionKind.ValueData
                     , Object_BonusKind.Id
                     , Object_BonusKind.ValueData
                     , MIFloat_BonusValue.ValueData
                     , ObjectLink_Contract_PaidKind.ChildObjectId

             -- ���������� ����� - �������
             UNION ALL
              SELECT -- Id ���������
                     MovementItemContainer.MovementId
                     --, 0 :: Integer AS AnalyzerId
                     -- ��� ���������
                   , MovementItemContainer.MovementDescId
                   , MovementDesc.ItemName
                     -- ���� ���������
                   , MovementItemContainer.OperDate
                     -- ���� ���������
                   , Movement.OperDate AS OperDate_sklad
                     -- � ���������
                   , Movement.InvNumber

                     -- ��. ����
                   , CLO_Juridical.ObjectId          AS JuridicalId
                   , CLO_Partner.ObjectId            AS PartnerId
                     -- �� ������ ����������
                   , CLO_InfoMoney.ObjectId          AS InfoMoneyId
                     -- ����� ������ - ������� ������� / �������� ���������� �����
                   , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, CLO_PaidKind.ObjectId) AS PaidKindId
                     -- ����� ������ - �������� ���������� �����
                   , CLO_PaidKind.ObjectId           AS PaidKindId_bonus
                     -- ������
                   , CLO_Branch.ObjectId             AS BranchId
                     -- ������� ������� / ������� ���������� �����
                   , COALESCE (MILinkObject_ContractChild.ObjectId, CLO_Contract.ObjectId) AS ContractId

                     -- ����� - ���
                   , 0  :: Integer  AS GoodsId
                   , 0  :: Integer  AS GoodsCode
                   , '' :: TVarChar AS GoodsName
                     -- ��� ������ - ���
                   , 0  :: Integer  AS GoodsKindId
                   , 0  :: Integer  AS GoodsKindCode
                   , '' :: TVarChar AS GoodsKindName
                     -- ��.���. ������ - ���
                   , 0  :: Integer  AS MeasureCode
                   , '' :: TVarChar AS MeasureName

                     -- �������� ����� - ���
                   , 0 :: Integer AS MovementId_promo
                     -- ������� ����� ��/���
                   , FALSE :: Boolean AS isPromo

                     -- ��� ������� �����
                   , Object_ContractConditionKind.Id                      AS ContractConditionKindId
                   , Object_ContractConditionKind.ValueData               AS ContractConditionKindName
                     -- ��� ������
                   , Object_BonusKind.Id                                  AS BonusKindId
                   , Object_BonusKind.ValueData                           AS BonusKindName
                     -- % ������
                   , COALESCE (MIFloat_BonusValue.ValueData,0)  :: TFloat AS BonusTax

                     -- ���-�� ������� - �� ������
                   , 0 :: TFloat AS Sale_Amount
                   , 0 :: TFloat 
                     -- ���-�� ������� - �� �����
                   , 0 :: TFloat AS Return_Amount
                   , 0 :: TFloat 

                     -- ����� - ���-�� �������
                   , 0 :: TFloat AS AmountPartner_promo
                   , 0 :: TFloat 
                     -- ���-�� ������� � ����������
                   , 0 :: TFloat AS Sale_AmountPartner
                   , 0 :: TFloat 
                     -- ���-�� ������� � ����������
                   , 0 :: TFloat AS Return_AmountPartner
                   , 0 :: TFloat 

                     -- ���-�� ������ �� ��� - �������
                   , 0 :: TFloat AS Sale_Amount_10500
                   , 0 :: TFloat 
                     -- ���-�� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Sale_Amount_40200
                   , 0 :: TFloat 
                     -- ���-�� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Return_Amount_40200
                   , 0 :: TFloat 

                     -- ����� - ����� �������
                   , 0 :: TFloat AS Sale_Summ_promo
                     -- ����� �������
                   , 0 :: TFloat AS Sale_Summ
                     -- ����� �������
                   , 0 :: TFloat AS Return_Summ

                     -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
                   , 0 :: TFloat AS Sale_Summ_10200
                     -- ����� ������� - ������-�����
                   , 0 :: TFloat AS Sale_Summ_10250
                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , 0 :: TFloat AS Sale_Summ_10300

                     -- ����� ������� - ������-�������������� (% � �.�.)
                   , 0 :: TFloat AS Return_Summ_10300
                     -- ����� ������� - ???���� ������ ���???
                   , 0 :: TFloat AS Return_Summ_10700

                     -- ����� - ����� �/� �������
                   , 0 :: TFloat AS Sale_SummCost_promo
                     -- ����� �/� �������
                   , 0 :: TFloat AS Sale_SummCost
                     -- ����� �/� ������ �� ��� - �������
                   , 0 :: TFloat AS Sale_SummCost_10500
                     -- ����� �/� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Sale_SummCost_40200

                     -- ����� �/� �������
                   , 0 :: TFloat AS Return_SummCost
                     -- ����� �/� ������ - ������� � ���� - �������
                   , 0 :: TFloat AS Return_SummCost_40200

                     -- ������� - ����� ����� �� ��������
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN -1 * MovementItemContainer.Amount
                               ELSE 0
                          END) AS BonusBasis
                     -- ������� - ����� ����� "������"
                   , SUM (CASE WHEN MILinkObject_ContractChild.ObjectId > 0 OR MovementBoolean_isLoad.ValueData = TRUE
                                    THEN 0
                               ELSE -1 * MovementItemContainer.Amount
                          END) AS Bonus

              -- ��������
              FROM Movement
                   -- ��������
                   INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                   AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                                                 --AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                   -- !!! ������ �� ���������� + ���������
                   INNER JOIN Container ON Container.Id       = MovementItemContainer.ContainerId
                                       AND Container.ObjectId = zc_Enum_Account_70301()
                   -- ����� ������ - �������� ���������� ����� - ���
                   INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                  ON CLO_PaidKind.ContainerId = Container.Id
                                                 AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                 -- !!! ������ ���!!!
                                                 AND CLO_PaidKind.ObjectId    = zc_Enum_PaidKind_SecondForm()

                   -- ��. ���� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_Juridical ON CLO_Juridical.ContainerId = Container.Id AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                   -- ������� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_Contract  ON CLO_Contract.ContainerId  = Container.Id AND CLO_Contract.DescId  = zc_ContainerLinkObject_Contract()
                   -- �� ������ ���������� - �������� ���������� �����
                   LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                   --
                   LEFT JOIN ContainerLinkObject AS CLO_Partner   ON CLO_Partner.ContainerId   = Container.Id AND CLO_Partner.DescId   = zc_ContainerLinkObject_Partner()
                   --
                   LEFT JOIN ContainerLinkObject AS CLO_Branch    ON CLO_Branch.ContainerId    = Container.Id AND CLO_Branch.DescId    = zc_ContainerLinkObject_Branch()

                   -- ������� �������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                    ON MILinkObject_ContractChild.MovementItemId = MovementItemContainer.MovementItemId
                                                   AND MILinkObject_ContractChild.DescId         = zc_MILinkObject_ContractChild()
                   -- ����� ������ - ������� �������
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                        ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                                       AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                   -- �������������� ������������
                   LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                             ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                            AND MovementBoolean_isLoad.DescId     = zc_MovementBoolean_isLoad()

                   -- ������ ���������
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   -- ��� ������� �����
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                    ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_ContractConditionKind.DescId         = zc_MILinkObject_ContractConditionKind()
                   LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

                   -- ��� ������
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                    ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()
                   LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

                   -- % ������
                   LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                               ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_BonusValue.DescId         = zc_MIFloat_BonusValue()

                   -- ��� ���������
                   LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

              WHERE Movement.DescId = zc_Movement_ProfitLossService()
              GROUP BY MovementItemContainer.MovementId
                     , MovementItemContainer.MovementDescId
                     , MovementDesc.ItemName
                     , MovementItemContainer.OperDate
                     , Movement.OperDate
                     , Movement.InvNumber

                     , CLO_Juridical.ObjectId
                     , CLO_Partner.ObjectId
                     , CLO_InfoMoney.ObjectId
                     , CLO_PaidKind.ObjectId
                     , CLO_Contract.ObjectId
                     , CLO_Branch.ObjectId
                     , MILinkObject_ContractChild.ObjectId

                     , Object_ContractConditionKind.Id
                     , Object_ContractConditionKind.ValueData
                     , Object_BonusKind.Id
                     , Object_BonusKind.ValueData
                     , MIFloat_BonusValue.ValueData
                     , ObjectLink_Contract_PaidKind.ChildObjectId
        ;

ALTER TABLE _bi_Report_Sale_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Report_Sale_View WHERE OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE
