-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperCount_Master TFloat;
  DECLARE vbOperCount_Child TFloat;
  DECLARE vbOperCount_Partner TFloat;
  DECLARE vbOperCount_Tare TFloat;
  DECLARE vbOperCount_Sh   TFloat;
  DECLARE vbOperCount_Kg   TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Packer TFloat;
  DECLARE vbOperCount_Packer TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT TFloat;
  DECLARE vbOperSumm_Inventory TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� � ������������
     SELECT Movement.DescId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
          , COALESCE (MovementFloat_ChangePrice.ValueData, 0)
            INTO vbMovementDescId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice
      FROM Movement
           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                    ON MovementFloat_ChangePercent.MovementId = Movement.Id
                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                   ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                  AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()
      WHERE Movement.Id = inMovementId;


     -- ������ �������� �����
     SELECT 
            -- ���������� �� ����� (������� ��������)
            OperCount_Master
            -- ���������� �� ����� (����������� ��������)
          , OperCount_Child
            -- ���������� �� �����������
          , OperCount_Partner
            -- ���������� ���� !!!�� �����������!!!
          , OperCount_Tare
            -- ���������� �� !!!�� �����������!!!
          , OperCount_Sh
            -- ���������� ��-!!�� ��!!! + !!!�� �����������!!!
          , OperCount_Kg

            -- ����� ��� ���
          , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� ��� ��� ��� %���=0
                      THEN (OperSumm_Partner)
                 WHEN vbPriceWithVAT AND 1=1
                      -- ���� ���� c ���
                      THEN CAST ( (OperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                      -- ���� ���� c ��� (������� ����� ���� ����  �������� ������ ��� =1/6 )
                      THEN OperSumm_Partner - CAST ( (OperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
            END AS OperSumm_MVAT

            -- ����� � ���
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ���
                      THEN (OperSumm_Partner)
                 WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���
                      THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2))
            END AS OperSumm_PVAT

            -- ����� �� �����������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Partner_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner

            -- ���������� �� ������������
          , OperCount_Packer AS OperCount_Packer

            -- ����� �� ������������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- ����� ����� �������
          , OperSumm_Inventory AS OperSumm_Inventory

            INTO vbOperCount_Master, vbOperCount_Child, vbOperCount_Partner, vbOperCount_Tare, vbOperCount_Sh, vbOperCount_Kg
               , vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner, vbOperCount_Packer, vbOperSumm_Packer, vbOperSumm_Inventory
     FROM 
          (SELECT SUM (tmpMI.OperCount_Master)  AS OperCount_Master
                , SUM (tmpMI.OperCount_Child)   AS OperCount_Child
                , SUM (tmpMI.OperCount_Partner) AS OperCount_Partner
                , SUM (tmpMI.OperCount_Packer)  AS OperCount_Packer

                , SUM (tmpMI.OperCount_Tare)     AS OperCount_Tare
                , SUM (tmpMI.OperCount_Sh)       AS OperCount_Sh
                , SUM (tmpMI.OperCount_Kg)       AS OperCount_Kg

                  -- ����� �� ����������� - � ����������� �� 2-� ������
                , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                            ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                       END) AS OperSumm_Partner
                   -- ����� �� ����������� � ������ ������ � ���� - � ����������� �� 2-� ������
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                        END
                       ) AS OperSumm_Partner_ChangePrice
                   -- ����� �� ������������ - � ����������� �� 2-� ������
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_Packer * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_Packer * tmpMI.Price AS NUMERIC (16, 2))
                        END) AS OperSumm_Packer
                   -- ����� ����� �������
                 , SUM (tmpMI.OperSumm_Inventory) AS OperSumm_Inventory

            FROM (SELECT tmpMI.GoodsId
                       , tmpMI.GoodsKindId
                       , tmpMI.Price
                       , tmpMI.CountForPrice

                         -- ����� ������ ���-��, ��� ���� ������ ����
                       , tmpMI.OperCount_calc

                       , tmpMI.OperCount_Master
                       , tmpMI.OperCount_Child
                       , tmpMI.OperCount_Partner
                       , tmpMI.OperCount_Packer

                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Tare
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                   THEN 0
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                               AND tmpMI.Price <> 0
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Sh
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                   THEN 0
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   -- AND tmpMI.Price <> 0
                                        THEN 0 -- tmpMI.OperCount_calc * COALESCE (ObjectFloat_Weight.ValueData, 0)
                                   ELSE tmpMI.OperCount_calc
                         END AS OperCount_Kg

                        -- ����� ����� �������
                      , tmpMI.OperSumm_Inventory

                  FROM (SELECT MovementItem.ObjectId AS GoodsId
                             , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                             , CASE WHEN vbDiscountPercent <> 0
                                         THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    WHEN vbExtraChargesPercent <> 0
                                         THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
                               END AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

                               -- ����� ������ ���-��, ��� ���� ������ ����
                             , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                         ELSE MovementItem.Amount
                                    END) AS OperCount_calc

                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Master
                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Child
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner
                             , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0))  AS OperCount_Packer

                             , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) as OperSumm_Inventory
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased = FALSE
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                         ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                        WHERE Movement.Id = inMovementId
                        GROUP BY MovementItem.ObjectId
                               , MILinkObject_GoodsKind.ObjectId
                               , MIFloat_Price.ValueData
                               , MIFloat_CountForPrice.ValueData
                       ) AS tmpMI

                       /*LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                            AND MovementItem.DescId = zc_MI_Master()*/
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                 ) AS tmpMI
          ) AS _tmp;

     -- ����
     -- RAISE EXCEPTION '%', vbOperCount_Master;

     IF vbMovementDescId = zc_Movement_PersonalSendCash() OR vbMovementDescId = zc_Movement_PersonalAccount()
     THEN
         -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
     ELSE
         -- ��������� �������� <����� ����������("������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master);
         -- ��������� �������� <����� ����������("����������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
         -- ��������� �������� <����� ���������� � �����������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner + vbOperCount_Packer);
         -- ��������� �������� <����� ����������, ����>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountTare(), inMovementId, vbOperCount_Tare);
         -- ��������� �������� <����� ����������, ��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountSh(), inMovementId, vbOperCount_Sh);
         -- ��������� �������� <����� ����������, ��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKg(), inMovementId, vbOperCount_Kg);
         -- ��������� �������� <����� ����� �� ��������� (��� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- ��������� �������� <����� ����� �� ��������� (� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
         -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_Partner + vbOperSumm_Inventory);
         -- ��������� �������� <����� ����� ������������ �� ��������� (� ������ ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPacker(), inMovementId, vbOperSumm_Packer);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.05.14                                        * modify - ����� ������ ���-��, ��� ���� ������ ����
 08.05.14                                        * all
 03.05.14                                        * add zc_Movement_TransferDebtIn and zc_Movement_TransferDebtOut
 31.03.14                                        * add TotalCount...
 20.10.13                                        * add vbChangePrice
 03.10.13                                        * add zc_Movement_PersonalSendCash
 22.08.13                                        * add vbOperSumm_Inventory
 13.08.13                                        * add vbOperCount_Master and vbOperCount_Child
 16.07.13                                        * add COALESCE (MIFloat_AmountPartner... and MIFloat_AmountPacker...
 07.07.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= 162323)
