-- Function: lpComplete_Movement_Sale_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId_ProfitLoss_20200 Integer, ContainerId Integer, AccountId Integer
                                   , ContainerId_Transit Integer
                                   , ContainerId_Transit_01 Integer, ContainerId_Transit_02 Integer
                                   , ContainerId_Transit_51 Integer, ContainerId_Transit_52 Integer, ContainerId_Transit_53 Integer
                                   , OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat, isLossMaterials Boolean
                                    ) ON COMMIT DROP;
     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemPartnerFrom (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10400 Integer, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_Count Integer, ContainerId_GoodsPartner Integer
                               , ContainerId_GoodsTransit Integer
                               , ContainerId_GoodsTransit_01 Integer, ContainerId_GoodsTransit_02 Integer, ContainerId_GoodsTransit_53 Integer
                               , ObjectDescId Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, ChangePercent TFloat, isChangePrice Boolean
                               , OperCount TFloat, OperCountCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_PriceListJur TFloat, OperSumm_PriceListJur TFloat
                               , tmpOperSumm_Partner TFloat, tmpOperSumm_Partner_original      TFloat, tmpOperSumm_PartnerVirt            TFloat, tmpOperSumm_Partner_Currency TFloat
                               , OperSumm_Partner TFloat,    OperSumm_Partner_ChangePercent TFloat,    OperSumm_PartnerVirt_ChangePercent TFloat,            OperSumm_Currency TFloat, OperSumm_Partner_ChangePromo TFloat, OperSumm_80103 TFloat, OperSumm_51201 TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10250 Integer, ContainerId_ProfitLoss_10300 Integer, ContainerId_ProfitLoss_80103 Integer
                               , ContainerId_Partner Integer, ContainerId_Currency Integer, AccountId_Partner Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean, isPromo Boolean
                               , PartionGoodsId Integer, PartionGoodsId_Item Integer
                               , PriceListPrice TFloat, PriceListJurPrice TFloat, Price TFloat, Price_Currency TFloat, Price_original TFloat, CountForPrice TFloat
                               , isPartion_container Boolean
                               , OperCount_start TFloat, OperCountCount_start TFloat, OperCount_ChangePercent_start TFloat, OperCount_Partner_start TFloat
                                ) ON COMMIT DROP;

     -- ������� - 
     IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_Promo_recalc')
     THEN
         -- ������� - Promo-recalc
         CREATE TEMP TABLE _tmpItem_Promo_recalc (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperPrice TFloat, MovementId_promo Integer, OperPrice_promo TFloat, CountForPrice_promo TFloat, isChangePercent_promo Boolean) ON COMMIT DROP;
     ELSE
         DELETE FROM _tmpItem_Promo_recalc;
     END IF;

     -- ������� - 
     IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpList_Goods_1942')
     THEN
         CREATE TEMP TABLE _tmpList_Goods_1942 ON COMMIT DROP
            AS SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1942) AS lfSelect -- ��-��������
        ;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.02.15                                        * add _tmpItemPartnerFrom
 16.01.15                                        * add !!!�����, ����������� � �������� �����!!!
 30.11.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Sale_CreateTemp ()
