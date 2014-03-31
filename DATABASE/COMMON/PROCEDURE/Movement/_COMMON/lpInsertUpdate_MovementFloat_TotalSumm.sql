-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

-- DROP FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
--  RETURNS TABLE (vbOperCount_Master TFloat) AS
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
            tmpOperCount_Master
            -- ���������� �� ����� (����������� ��������)
          , tmpOperCount_Child
            -- ���������� �� �����������
          , tmpOperCount_Partner
            -- ���������� ���� !!!�� �����������!!!
          , tmpOperCount_Tare
            -- ���������� �� !!!�� �����������!!!
          , tmpOperCount_Sh
            -- ���������� ��-!!�� ��!!! + !!!�� �����������!!!
          , tmpOperCount_Kg
            -- ����� ��� ���
          , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� ��� ��� ��� %���=0
                    THEN (tmpOperSumm_Partner)
                 WHEN vbPriceWithVAT AND 1=1
                    -- ���� ���� c ���
                    THEN CAST ( (tmpOperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                    -- ���� ���� c ��� (������� ����� ���� ����  �������� ������ ��� =1/6 )
                    THEN tmpOperSumm_Partner - CAST ( (tmpOperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
            END
            -- ����� � ���
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ���
                    THEN (tmpOperSumm_Partner)
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���
                    THEN CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
            END
            -- ����� �� �����������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Partner_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
            END

            -- ���������� �� ������������
          , tmpOperCount_Packer
            -- ����� �� ������������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END
            -- ����� ����� �������
          , tmpOperSumm_Inventory
            INTO vbOperCount_Master, vbOperCount_Child, vbOperCount_Partner, vbOperCount_Tare, vbOperCount_Sh, vbOperCount_Kg, vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner, vbOperCount_Packer, vbOperSumm_Packer, vbOperSumm_Inventory
     FROM 
          (SELECT 
                 SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS tmpOperCount_Master
               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS tmpOperCount_Child
               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS tmpOperCount_Partner
               , SUM (CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                           ELSE 0
                      END
                     ) AS tmpOperCount_Tare
               , SUM (CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                THEN 0
                           WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                           ELSE 0
                      END
                     ) AS tmpOperCount_Sh
               , SUM (CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                THEN 0
                           WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                THEN 0 -- COALESCE (MIFloat_AmountPartner.ValueData, 0) * COALESCE (ObjectFloat_Weight.ValueData, 0)
                           ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0)
                      END
                     ) AS tmpOperCount_Kg
                 -- ����� �� ����������� - � ����������� �� 2-� ������
               , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                      END) AS tmpOperSumm_Partner
                 -- ����� �� ����������� � ������ ������ � ���� - � ����������� �� 2-� ������
               , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * (MIFloat_Price.ValueData - vbChangePrice) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * (MIFloat_Price.ValueData - vbChangePrice) AS NUMERIC (16, 2)), 0)
                      END) AS tmpOperSumm_Partner_ChangePrice

               , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS tmpOperCount_Packer
                 -- ������������� ����� �� ������������ - � ����������� �� 2-� ������
               , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                      END) AS tmpOperSumm_Packer
                 -- ����� ����� �������
               , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) as tmpOperSumm_Inventory

            FROM Movement
                 JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.isErased = FALSE

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

                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                      AND MovementItem.DescId = zc_MI_Master()
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                     AND MovementItem.DescId = zc_MI_Master()
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                      ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                     AND MovementItem.DescId = zc_MI_Master() 
                 LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            WHERE Movement.Id = inMovementId
          ) AS _tmp;

     -- ����
     -- RETURN QUERY 
     -- SELECT vbOperCount_Master;
     -- return;

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
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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
