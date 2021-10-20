-- Function: gpInsertUpdate_MI_Promo_PriceCalc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_PriceCalc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_PriceCalc(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMonthPromo TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbOperDate_Condition TDateTime;

   DECLARE vbContractCondition TFloat;
   DECLARE vbContractId_str TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());


     -- �������� ���� ������������
   --PERFORM lpUpdate_Movement_Promo_Auto (inMovementId:= inMovementId, inUserId:= vbUserId);

     -- ����� - �� ����� ���� ����� �������
     vbOperDate_Condition := (SELECT MovementDate_StartSale.ValueData
                              FROM MovementDate AS MovementDate_StartSale
                              WHERE MovementDate_StartSale.MovementId  = inMovementId
                                AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                             );

     -- ������ ��� �� ���������� ����� �� ���������� �����



     -- ������������ ����� ���� - ����� �����
     vbContractCondition := (
   --vbContractId_str := (
             WITH -- ��� ����������� �����
                  tmpPromoPartner_all AS (SELECT tmp.PartnerId
                                               , tmp.ContractId
                                          FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp
                                         )
                      -- ��� ��.���� ����� + ���� �������� �������
                    , tmpPromoPartner AS (SELECT DISTINCT
                                                 ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                               , tmpPromoPartner_all.ContractId
                                          FROM tmpPromoPartner_all
                                               INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                     ON ObjectLink_Partner_Juridical.ObjectId = tmpPromoPartner_all.PartnerId
                                                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                         )
                         -- ������ ��.���
                       , tmpJuridical AS (SELECT DISTINCT tmpPromoPartner.JuridicalId FROM tmpPromoPartner)
                     -- ��� �������� - ������ ��
                   , tmpContract_full AS (SELECT View_Contract.*
                                          FROM Object_Contract_View AS View_Contract
                                          WHERE View_Contract.JuridicalId IN (SELECT tmpJuridical.JuridicalId FROM tmpJuridical)
                                            AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                         )
                      -- ��� ��������
                    , tmpContract_all AS (SELECT * FROM tmpContract_full)
                     -- ��� �������� - �� ��������, ��� �������
                   , tmpContract_find AS (SELECT View_Contract.*
                                          FROM tmpContract_full AS View_Contract
                                          WHERE View_Contract.isErased = FALSE
                                            AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                              OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                             , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                              )
                                                )
                                         )
          -- ������� �������� �� ����
        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        , Object_ContractCondition_View.ContractConditionId
                                        , Object_ContractCondition_View.ContractConditionKindId
                                        , Object_ContractCondition_View.Value
                                   FROM Object_ContractCondition_View
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                     AND vbOperDate_Condition BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )
         -- ������ ���������, � ������� ���� ������� �� "�������"
       , tmpContractConditionKind AS (SELECT -- ������� ��������
                                             tmpContractCondition.ContractConditionKindId
                                           , View_Contract.JuridicalId
                                             -- �������, � ������� �������� �������
                                           , View_Contract.ContractId            AS ContractId_master
                                             -- ������ �� ��������
                                           , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                                             -- ������ �� ������� ����� ����� ����
                                           , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                    OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- ��������� + ������������� ������
                                                       THEN zc_Enum_InfoMoney_30101() -- ������� ���������
                                                  WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                                       THEN zc_Enum_InfoMoney_30201() -- ������ �����
                                                  -- !!!��� ������ ������ - ����� ����!!!
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                                                       THEN 0
                                                  -- !!!���� ��� ���� - ����� � ������ ���� ��������!!!
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                                       THEN 0
                                                  ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child

                                             -- !!!��������� - ��� ����� "����"!!!
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                                          , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                                                    , zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                                                                    , zc_Enum_InfoMoney_21512() -- ��������� + ������������� ������
                                                                                     )
                                                  THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                  ELSE 0
                                             END AS ContractId_baza

                                      FROM tmpContractCondition
                                           -- � ��� ��� �������, � ������� �������� �������
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           -- !!!��������� - ��� ����� "����" ��� ������-������� ����������!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- ��� ContractId_send
                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                                ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                               AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                      -- �������� - %
                                      WHERE tmpContractCondition.Value <> 0
                                     )
      -- ��� ���� �� ���, � ���� ���� "������" ����������� ������ ���� ������ ��������� (�� ��� ����� ������ ������ "����")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                      FROM tmpContractConditionKind
                      -- ��� ����� �� �������� �������� (�� � ��� ���� ������)
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child

                     UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId             AS ContractId_child
                      FROM tmpContractConditionKind
                           LEFT JOIN tmpContract_full AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- � �������� �������� ����� ������� ��� ����� ����
                        AND tmpContractConditionKind.ContractId_baza > 0

                     UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId             AS ContractId_child
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      -- ��� ����� �������� ��������
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- �� ������� ��� ����� ����
                        AND tmpContractConditionKind.ContractId_baza = 0
                     )
      -- ���������� ��������
    , tmpContractGroup AS (SELECT DISTINCT
                                  tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                           FROM tmpContract
                                -- ���� ��� ���������� �������
                                INNER JOIN tmpPromoPartner ON tmpPromoPartner.ContractId = tmpContract.ContractId_child
                          UNION
                           SELECT DISTINCT
                                  tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                           FROM tmpContract
                                -- ��� �� ����, ���� �� ��� ���������� �������
                                INNER JOIN tmpPromoPartner ON tmpPromoPartner.JuridicalId = tmpContract.JuridicalId
                                                          AND tmpPromoPartner.ContractId  = 0
                          )
       -- ������ ���������
     , tmpContractList AS (SELECT DISTINCT
                                  tmpContractGroup.ContractId_master AS ContractId
                           FROM tmpContractGroup
                          UNION
                           SELECT DISTINCT
                                  tmpContractGroup.ContractId_child  AS ContractId
                           FROM tmpContractGroup
                          )
    , tmpMI AS (SELECT MovementItem.*
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
  -- ������ � ���������(������������)
, tmpContractGoods_all AS (SELECT DISTINCT
                                  tmpContractList.ContractId
                           FROM tmpContractList
                                INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Contract
                                                      ON ObjectLink_ContractGoods_Contract.ChildObjectId = tmpContractList.ContractId
                                                     AND ObjectLink_ContractGoods_Contract.DescId        = zc_ObjectLink_ContractGoods_Contract()
                                INNER JOIN Object AS Object_ContractGoods ON Object_ContractGoods.Id       = ObjectLink_ContractGoods_Contract.ObjectId
                                                                         AND Object_ContractGoods.isErased = FALSE
                                INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                      ON ObjectLink_ContractGoods_Goods.ObjectId = ObjectLink_ContractGoods_Contract.ObjectId
                                                     AND ObjectLink_ContractGoods_Goods.DescId   = zc_ObjectLink_ContractGoods_Goods()
                                INNER JOIN tmpMI ON tmpMI.ObjectId = ObjectLink_ContractGoods_Goods.ChildObjectId
                          )
      -- ��������(������������) + ��������(��� ������������), ���� ����
    , tmpContractGoods AS (SELECT DISTINCT
                                  tmpContractList.ContractId
                           FROM tmpContractList
                                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Contract
                                                     ON ObjectLink_ContractGoods_Contract.ChildObjectId = tmpContractList.ContractId
                                                    AND ObjectLink_ContractGoods_Contract.DescId        = zc_ObjectLink_ContractGoods_Contract()
                                LEFT JOIN Object AS Object_ContractGoods ON Object_ContractGoods.Id       = ObjectLink_ContractGoods_Contract.ObjectId
                                                                        AND Object_ContractGoods.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                     ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                                    AND ObjectLink_ContractGoods_Goods.DescId   = zc_ObjectLink_ContractGoods_Goods()
                                LEFT JOIN tmpMI ON tmpMI.ObjectId = ObjectLink_ContractGoods_Goods.ChildObjectId
                                LEFT JOIN tmpContractGoods_all ON 1=1
                           -- ����� ��������, � ������� ��� ����������� �� �������
                           WHERE tmpMI.ObjectId IS NULL
                             -- ���� �� ����� ����� ��� ��� ���� ����������� �� �������
                             AND tmpContractGoods_all.ContractId IS NULL
                          UNION
                           -- ���� ����� ����� ��� ��� ���� ����������� �� �������
                           SELECT tmpContractGoods_all.ContractId
                           FROM tmpContractGoods_all
                          )
    , tmpContract_res AS (SELECT DISTINCT
                                 tmpContractGroup.ContractId_master
                             --, tmpContractGroup.ContractId_child
                           FROM tmpContractGroup
                                INNER JOIN tmpContractGoods ON tmpContractGoods.ContractId = tmpContractGroup.ContractId_master
                                                            OR tmpContractGoods.ContractId = tmpContractGroup.ContractId_child
                          )
       -- ���������
       SELECT MAX (tmp.Value) AS ContractCondition
       --SELECT STRING_AGG (tmp.ContractId_master :: TVarChar, ';')  AS ContractId_str
       FROM (SELECT tmpContract_res.ContractId_master
                  , SUM (COALESCE (tmpContractCondition.Value, 0)) AS Value

             FROM tmpContract_res
                 INNER JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId          = tmpContract_res.ContractId_master
                                                          AND Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                          AND Object_Contract_InvNumber_View.isErased            = FALSE
                                                          -- ������� ��������� OR  ��������� + ������ �� ��������� + ������������� ������
                                                          --AND Object_Contract_InvNumber_View.InfoMoneyId       IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21512())
                                                          
                 LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = tmpContract_res.ContractId_master

                 LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                      ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                     AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                 INNER JOIN Object AS Object_BonusKind
                                   ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
                                --AND Object_BonusKind.Id = 81959   ---�����

             GROUP BY tmpContract_res.ContractId_master
            ) AS tmp
       );


     -- ������������ ����� ���� - ������ �����
     IF COALESCE (vbContractCondition, 0) = 0
     THEN
         vbContractCondition := (-- ������� �������� �� ����
                                 WITH tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                                                    , Object_ContractCondition_View.ContractConditionId
                                                                    , Object_ContractCondition_View.ContractConditionKindId
                                                                    , Object_ContractCondition_View.Value
                                                               FROM Object_ContractCondition_View
                                                               WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                                              )
                                                                 AND Object_ContractCondition_View.Value <> 0
                                                                 AND vbOperDate_Condition BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                                            )
                                 -- ���������
                                 SELECT MAX (tmp.Value) AS ContractCondition
                                 FROM (SELECT COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId) AS ContractId
                                            , SUM (COALESCE (ObjectFloat_Value.ValueData, 0)) AS Value

                                       FROM Movement AS Movement_Promo
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                        ON MovementLinkObject_Contract.MovementId = Movement_Promo.Id
                                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                        ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                                       AND MovementLinkObject_Contract.ObjectId IS NULL

                                           LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                      ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ChildObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId)
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                                           INNER JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId          = COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                                                                    AND Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                                    AND Object_Contract_InvNumber_View.isErased            = FALSE
                                                                                    -- ������� ��������� OR  ��������� + ������ �� ��������� + ������������� ������
                                                                                  AND Object_Contract_InvNumber_View.InfoMoneyId         IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21512())
                                                                                  
                                           INNER JOIN tmpContractCondition ON tmpContractCondition.ContractId = COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                                                        --AND tmpContractCondition.isErased = FALSE
                                                                        /*AND tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                                              )*/

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                           INNER JOIN Object AS Object_BonusKind
                                                             ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
                                                          --AND Object_BonusKind.Id = 81959   ---�����

                                           INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                  ON ObjectFloat_Value.ObjectId = tmpContractCondition.ContractConditionId
                                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

                                       WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
                                         AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                                         AND Movement_Promo.ParentId = inMovementId  ---������ �� �������� �������� <�����> (zc_Movement_Promo)
                                       GROUP BY COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                       ) AS tmp
                                 );
     END IF;

     --
     IF COALESCE (vbContractCondition,0) <> 0
     THEN
        -- ���������
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), MovementItem.Id, vbContractCondition)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
       ;
     END IF;


    IF (1=0 AND vbUserId = 5) OR EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        RAISE EXCEPTION '������.�������� � ������� <%>. ��������: <%> <%>.'
          , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
          , (SELECT DISTINCT MIF.ValueData
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_ContractCondition()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
          -- ORDER BY MovementItem.Id LIMIT 1
            )
          , vbContractCondition
--          , vbContractId_str
            ;
    END IF;



     -- ������ ������� �/�

     -- ����� �����
     vbMonthPromo := (SELECT CASE WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 1 AND 9
                                       THEN DATE_TRUNC ('MONTH', (MovementDate_Insert.ValueData - INTERVAL '1 MONTH'))
                                  WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 10 AND 31
                                       THEN DATE_TRUNC ('MONTH', MovementDate_Insert.ValueData)
                                  ELSE DATE_TRUNC ('MONTH', MovementDate_Month.ValueData)
                        END :: TDateTime
                      FROM Movement
                           LEFT JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                           LEFT JOIN MovementDate AS MovementDate_Month
                                                  ON MovementDate_Month.MovementId = Movement.Id
                                                 AND MovementDate_Month.DescId = zc_MovementDate_Month()
                      WHERE Movement.Id = inMovementId
                     );

     -- ������ ��� �� ���������� ����� �� ���������� �����
     vbEndDate   := (vbMonthPromo - INTERVAL '1 DAY') :: TDateTime;
     vbStartDate := DATE_TRUNC ('MONTH', vbEndDate) :: TDateTime;


     CREATE TEMP TABLE _tmpData (GoodsId Integer, Price3_cost TFloat, PriceSale_cost TFloat, Price_cost TFloat) ON COMMIT DROP;

     INSERT INTO _tmpData (GoodsId, Price3_cost, PriceSale_cost, Price_cost)
     WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                          FROM Constant_ProfitLoss_AnalyzerId_View
                          WHERE DescId = zc_Object_AnalyzerId()
                         )

        , tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       )

        -- ��� ���������
        , tmpChildReceiptTable AS (SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                                        , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
                                        , COALESCE(PriceList3.Price, 0) AS Price3
                                   FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 18885             --����� - ���� ����������� ��� �������
                                                                                                AND PriceList3.GoodsId = lpSelect.GoodsId_out
                                                                                                AND vbEndDate >= PriceList3.StartDate AND vbEndDate < PriceList3.EndDate
                                  )

        , tmpReceipt AS (SELECT tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS  GoodsKindId
                              , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                         GROUP BY tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                        )

        , tmpMIContainer AS (SELECT tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , SUM (tmpContainer.OperCountPartner)  AS OperCount_sale
                                  , SUM (tmpContainer.SummInPartner)     AS SummIn_sale
                             FROM
                                 (SELECT MIContainer.ObjectId_Analyzer       AS GoodsId
                                       , CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer, 0) = 0 THEN zc_GoodsKind_Basis() ELSE MIContainer.ObjectIntId_analyzer END AS GoodsKindId
                                         -- 1.1. ���-��, ��� AnalyzerId
                                       , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCount
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCountPartner
                                         -- 1.2. �������������, ��� AnalyzerId
                                       , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                                    -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SaleSumm_10500(), zc_Enum_AnalyzerId_SaleSumm_40200())
                                                        THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                                    -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ReturnInSumm_40200()
                                                        THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummIn
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()
                                                        THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800()
                                                        THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummInPartner

                                         -- 2.1. ���-�� - ������ �� ���
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCount_Change
                                         -- 2.2. ������������� - ������ �� ���
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummIn_Change

                                         -- 3.1. ���-�� ������� � ����
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount  -- !!! �� �������� ����, �.�. ���� �������� +/-!!!
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount -- !!! ��� �������� �� ������ - ��������, �.�. ������!!!
                                                   ELSE 0
                                              END) AS OperCount_40200
                                         -- 3.2. ������������� - ������� � ����
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN 1 * MIContainer.Amount -- !!! �� �������� ����, �.�. ���� �������� +/-!!!
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN 1 * MIContainer.Amount -- !!! ��� �������� �� ������ - ��������, �.�. ������!!!
                                                   ELSE 0
                                              END) AS SummIn_40200

                                  FROM tmpAnalyzer
                                       INNER JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate--inStartDate AND inEndDate
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.MovementDescId = zc_Movement_Sale()
                                  GROUP BY MIContainer.ObjectId_Analyzer
                                         , MIContainer.ObjectIntId_analyzer
                                  ) AS tmpContainer
                             GROUP BY tmpContainer.GoodsId
                                    , tmpContainer.GoodsKindId
                             )

        , tmpReceiptCost AS (SELECT tmp.ReceiptId
                                  , MAX (tmp.GoodsId_isCost) AS GoodsId_isCost
                                  , tmpMI.GoodsId
                                  , tmpMI.GoodsKindId
                                  , 0 AS OperCount_sale
                                  , 0 AS SummIn_sale
                                  , SUM (tmp.Summ3_cost) AS Summ3_cost
                             FROM (SELECT tmpChildReceiptTable.ReceiptId
                                        , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                                        , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                                        , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                                   FROM tmpChildReceiptTable
                                   WHERE tmpChildReceiptTable.ReceiptId_from = 0
                                   GROUP BY  tmpChildReceiptTable.ReceiptId
                                  ) AS tmp
                                  LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                       ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                                      AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                                      AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                                  INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                              FROM tmpMIContainer
                                              WHERE tmpMIContainer.OperCount_sale <> 0
                                              GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                             ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                       AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                             GROUP BY tmp.ReceiptId
                                    , tmpMI.GoodsId
                                    , tmpMI.GoodsKindId
                             )

        , tmpAll AS (SELECT COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId
                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId
                          , SUM (tmpMIContainer.OperCount_sale)         AS OperCount_sale
                          , SUM (tmpMIContainer.SummIn_sale)            AS SummIn_sale
                          , 0 AS Summ3_cost
                     FROM tmpMIContainer
                          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMIContainer.GoodsId
                                              AND tmpReceipt.GoodsKindId = tmpMIContainer.GoodsKindId
                     GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                            , tmpMIContainer.GoodsId
                            , tmpMIContainer.GoodsKindId
                    UNION ALL
                     SELECT tmp.ReceiptId
                          , tmpMI.GoodsId
                          , tmpMI.GoodsKindId
                          , 0 AS OperCount_sale
                          , 0 AS SummIn_sale
                          , SUM (tmp.Summ3_cost) AS Summ3_cost
                     FROM (SELECT tmpChildReceiptTable.ReceiptId
                                , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                                , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                           FROM tmpChildReceiptTable
                           WHERE tmpChildReceiptTable.ReceiptId_from = 0
                           GROUP BY  tmpChildReceiptTable.ReceiptId
                          ) AS tmp
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                               ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                               ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                      FROM tmpMIContainer
                                      WHERE tmpMIContainer.OperCount_sale <> 0
                                      GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                     ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                               AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                     GROUP BY tmp.ReceiptId
                            , tmpMI.GoodsId
                            , tmpMI.GoodsKindId
                    )

       SELECT tmp.GoodsId
            , tmp.Price3_cost   -- ���� �������
            , CASE WHEN tmp.OperCount_sale <> 0 THEN CAST ( tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END AS PriceSale_cost
            , COALESCE (tmp.Price3_cost,0) + COALESCE (CASE WHEN tmp.OperCount_sale <> 0 THEN CAST ( tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END,0) AS Price_cost
       FROM (SELECT tmpAll.GoodsId
                  , SUM (tmpAll.OperCount_sale) AS OperCount_sale
                  , SUM (tmpAll.SummIn_sale)    AS SummIn_sale
                  , SUM (tmpAll.Summ3_cost)     AS Summ3_cost
                  , MAX (CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 2)) ELSE 0 END) AS Price3_cost
             FROM tmpAll
                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                         ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                        AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
             GROUP BY tmpAll.GoodsId
             ) AS tmp;

        -- ��������� ���������� �/�
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), MovementItem.Id, COALESCE (_tmpData.Price_cost,0) ::TFloat ) -- ����
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), MovementItem.Id, (CAST (COALESCE (_tmpData.Price_cost,0) * 1.1 AS NUMERIC (16, 2))) ::TFloat) -- ����   = ���� + 10 %
        FROM MovementItem
             LEFT JOIN _tmpData ON _tmpData.GoodsId = MovementItem.ObjectId
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
       ;

    IF vbUserId = 5
    THEN
        RAISE EXCEPTION '������.Admin <%> <%> <%>   <%> <%>   <%> <%> <%>'
          , (SELECT DISTINCT MIF.ValueData
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_ContractCondition()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
          -- ORDER BY MovementItem.Id LIMIT 1
            )
          , (SELECT STRING_AGG (zfConvert_FloatToString (MIF.ValueData), ' ; ')
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_PriceIn1()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
             --ORDER BY MovementItem.Id
           --LIMIT 1
            )
          , (SELECT STRING_AGG (zfConvert_FloatToString (MIF.ValueData), ' ; ')
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_PriceIn2()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
             -- ORDER BY MovementItem.Id
           --LIMIT 1
            )

          , zfConvert_DateToString (vbStartDate)
          , zfConvert_DateToString (vbEndDate)

          , (SELECT STRING_AGG (zfConvert_FloatToString (Price3_cost), ' ; ')
             FROM _tmpData
            )
          , (SELECT STRING_AGG (zfConvert_FloatToString (PriceSale_cost), ' ; ')
             FROM _tmpData
            )
          , (SELECT STRING_AGG (zfConvert_FloatToString (Price_cost), ' ; ')
             FROM _tmpData
            )
            ;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.09.20         *
*/

-- ����
--