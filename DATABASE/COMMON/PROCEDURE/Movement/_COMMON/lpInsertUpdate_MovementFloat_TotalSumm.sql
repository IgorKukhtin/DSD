-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperCount_Master TFloat;
  DECLARE vbOperCount_Child TFloat;
  DECLARE vbOperCount_Partner TFloat;
  DECLARE vbOperCount_Packer TFloat;
  DECLARE vbOperCount_Second TFloat;
  DECLARE vbOperCount_Tare TFloat;
  DECLARE vbOperCount_Sh   TFloat;
  DECLARE vbOperCount_Kg   TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Packer TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT TFloat;
  DECLARE vbOperSumm_Inventory TFloat;

  DECLARE vbTotalSummToPay   TFloat;
  DECLARE vbTotalSummService TFloat;
  DECLARE vbTotalSummCard    TFloat;
  DECLARE vbTotalSummMinus   TFloat;
  DECLARE vbTotalSummAdd     TFloat;
  DECLARE vbTotalSummCardRecalc TFloat;
  DECLARE vbTotalSummSocialIn   TFloat;
  DECLARE vbTotalSummSocialAdd  TFloat;
  DECLARE vbTotalSummChild      TFloat;


  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;
  DECLARE vbPaidKindId Integer;
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и Заготовителю
     SELECT Movement.DescId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
          , COALESCE (MovementFloat_ChangePrice.ValueData, 0)
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)
            INTO vbMovementDescId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice, vbPaidKindId
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
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind())
      WHERE Movement.Id = inMovementId;


     -- Расчет Итоговых суммы
     SELECT 
            -- Количество по факту (главные элементы)
            OperCount_Master
            -- Количество по факту (подчиненные элементы)
          , OperCount_Child
            -- Количество по Контрагенту
          , OperCount_Partner
            -- Количество дозаказ
          , OperCount_Second
            -- Количество тары !!!по Контрагенту!!!
          , OperCount_Tare
            -- Количество шт !!!по Контрагенту!!!
          , OperCount_Sh
            -- Количество кг-!!не шт!!! + !!!по Контрагенту!!!
          , OperCount_Kg

            -- Сумма без НДС
          , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены без НДС или %НДС=0
                      THEN (OperSumm_Partner)
                 WHEN vbPriceWithVAT AND 1=1
                      -- если цены c НДС
                      THEN CAST ( (OperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                      -- если цены c НДС (Вариант может быть если  первичен расчет НДС =1/6 )
                      THEN OperSumm_Partner - CAST ( (OperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
            END AS OperSumm_MVAT

            -- Сумма с НДС
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС
                      THEN (OperSumm_Partner)
                 WHEN vbVATPercent > 0
                      -- если цены без НДС
                      THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2))
            END AS OperSumm_PVAT

            -- Сумма по Контрагенту
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Partner_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner

            -- Количество по Заготовителю
          , OperCount_Packer AS OperCount_Packer

            -- Сумма по Заготовителю
          , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- сумма ввода остатка
          , OperSumm_Inventory AS OperSumm_Inventory

            -- сумма начисления зп
          , OperSumm_ToPay
          , OperSumm_Service
          , OperSumm_Card
          , OperSumm_Minus
          , OperSumm_Add
          , OperSumm_CardRecalc
          , OperSumm_SocialIn
          , OperSumm_SocialAdd
          , OperSumm_Child

            INTO vbOperCount_Master, vbOperCount_Child, vbOperCount_Partner, vbOperCount_Second, vbOperCount_Tare, vbOperCount_Sh, vbOperCount_Kg
               , vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner, vbOperCount_Packer, vbOperSumm_Packer, vbOperSumm_Inventory
               , vbTotalSummToPay, vbTotalSummService, vbTotalSummCard, vbTotalSummMinus, vbTotalSummAdd, vbTotalSummCardRecalc, vbTotalSummSocialIn, vbTotalSummSocialAdd, vbTotalSummChild
     FROM 
           -- получили 1 запись
          (SELECT SUM (tmpMI.OperCount_Master)  AS OperCount_Master
                , SUM (tmpMI.OperCount_Child)   AS OperCount_Child
                , SUM (tmpMI.OperCount_Partner) AS OperCount_Partner
                , SUM (tmpMI.OperCount_Packer)  AS OperCount_Packer
                , SUM (tmpMI.OperCount_Second)  AS OperCount_Second

                , SUM (tmpMI.OperCount_Tare)     AS OperCount_Tare
                , SUM (tmpMI.OperCount_Sh)       AS OperCount_Sh
                , SUM (tmpMI.OperCount_Kg)       AS OperCount_Kg

                  -- сумма по Контрагенту - с округлением до 2-х знаков
                , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                            ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                       END) AS OperSumm_Partner
                   -- сумма по Контрагенту с учетом скидки в цене - с округлением до 2-х знаков
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                        END
                       ) AS OperSumm_Partner_ChangePrice
                   -- сумма по Заготовителю - с округлением до 2-х знаков
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_Packer * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_Packer * tmpMI.Price AS NUMERIC (16, 2))
                        END) AS OperSumm_Packer
                   -- сумма ввода остатка
                 , SUM (tmpMI.OperSumm_Inventory) AS OperSumm_Inventory

                  -- сумма начисления зп
                 , SUM (tmpMI.OperSumm_ToPay)      AS OperSumm_ToPay
                 , SUM (tmpMI.OperSumm_Service)    AS OperSumm_Service
                 , SUM (tmpMI.OperSumm_Card)       AS OperSumm_Card
                 , SUM (tmpMI.OperSumm_Minus)      AS OperSumm_Minus
                 , SUM (tmpMI.OperSumm_Add)        AS OperSumm_Add
                 , SUM (tmpMI.OperSumm_CardRecalc) AS OperSumm_CardRecalc
                 , SUM (tmpMI.OperSumm_SocialIn)   AS OperSumm_SocialIn
                 , SUM (tmpMI.OperSumm_SocialAdd)  AS OperSumm_SocialAdd
                 , SUM (tmpMI.OperSumm_Child)      AS OperSumm_Child

            FROM (SELECT tmpMI.GoodsId
                       , tmpMI.GoodsKindId
                       , tmpMI.Price
                       , tmpMI.CountForPrice

                         -- очень важное кол-во, для него расчет сумм
                       , tmpMI.OperCount_calc

                         -- кол-во Master (!!!без тары с ц=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Master
                         END AS OperCount_Master
                         -- кол-во Child (!!!без тары с ц=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Child
                         END AS OperCount_Child
                         -- кол-во Partner (!!!без тары с ц=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Partner
                         END AS OperCount_Partner
                       , tmpMI.OperCount_Packer
                       , tmpMI.OperCount_Second
                         -- тара (если цена=0)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               AND tmpMI.Price = 0
                                   THEN CASE WHEN tmpMI.MovementDescId = zc_Movement_WeighingPartner()
                                                  THEN tmpMI.OperCount_Master
                                             ELSE tmpMI.OperCount_calc
                                        END
                              ELSE 0
                         END AS OperCount_Tare
                         -- ШТ
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Sh
                         -- ВЕС
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calc * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Kg

                        -- сумма ввода остатка
                      , tmpMI.OperSumm_Inventory

                        -- сумма начисления зп
                      , tmpMI.OperSumm_ToPay
                      , tmpMI.OperSumm_Service
                      , tmpMI.OperSumm_Card
                      , tmpMI.OperSumm_Minus
                      , tmpMI.OperSumm_Add
                      , tmpMI.OperSumm_CardRecalc
                      , tmpMI.OperSumm_SocialIn
                      , tmpMI.OperSumm_SocialAdd
                      , tmpMI.OperSumm_Child

                  FROM (SELECT Movement.DescId AS MovementDescId
                             , MovementItem.DescId
                             , MovementItem.ObjectId AS GoodsId
                             , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                             , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                         THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                         THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
                               END AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

                               -- !!!очень важное кол-во, для него расчет сумм!!!
                             , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_EDI(), zc_Movement_WeighingPartner())
                                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                         ELSE MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                    END) AS OperCount_calc

                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS OperCount_Master
                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Child
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner
                             , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0))  AS OperCount_Packer
                             , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))  AS OperCount_Second

                             , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN MIFloat_Summ.ValueData ELSE 0 END, 0)) AS OperSumm_Inventory

                             , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0))   AS OperSumm_ToPay
                             , SUM (COALESCE (MIFloat_SummService.ValueData, 0)) AS OperSumm_Service
                             , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))    AS OperSumm_Card
                             , SUM (COALESCE (MIFloat_SummMinus.ValueData, 0))   AS OperSumm_Minus
                             , SUM (COALESCE (MIFloat_SummAdd.ValueData, 0))     AS OperSumm_Add

                             , SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0)) AS OperSumm_CardRecalc
                             , SUM (COALESCE (MIFloat_SummSocialIn.ValueData, 0))   AS OperSumm_SocialIn
                             , SUM (COALESCE (MIFloat_SummSocialAdd.ValueData, 0))  AS OperSumm_SocialAdd
                             , SUM (COALESCE (MIFloat_SummChild.ValueData, 0))      AS OperSumm_Child

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
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                                        AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal()) 

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                         ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                         ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                         ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                                         ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                         ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                         ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                                         ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                         ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                         ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                                                        AND Movement.DescId = zc_Movement_PersonalService()

                        WHERE Movement.Id = inMovementId
                        GROUP BY Movement.DescId
                               , MovementItem.DescId
                               , MovementItem.ObjectId
                               , MILinkObject_GoodsKind.ObjectId
                               , MIFloat_Price.ValueData
                               , MIFloat_CountForPrice.ValueData
                       ) AS tmpMI

                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                            AND tmpMI.DescId = zc_MI_Master()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                 ) AS tmpMI
          ) AS _tmp;

     -- Тест
     -- RAISE EXCEPTION '%', vbOperCount_Master;

     IF vbMovementDescId = zc_Movement_PersonalSendCash() OR vbMovementDescId = zc_Movement_PersonalAccount()
     THEN
         -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
     ELSE
     IF vbMovementDescId = zc_Movement_PersonalService()
     THEN
         -- Сохранили свойство <Итого  Сумма (затраты) >
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
         -- Сохранили свойство <Итого Сумма (к выплате)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummToPay(), inMovementId, vbTotalSummToPay);
         -- Сохранили свойство <Итого Сумма начислено>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummService(), inMovementId, vbTotalSummService);
         -- Сохранили свойство <Итого Сумма на карточку (БН)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCard(), inMovementId, vbTotalSummCard);
         -- Сохранили свойство <Итого Сумма удержания>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinus(), inMovementId, vbTotalSummMinus);
         -- Сохранили свойство <Итого Сумма премия>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAdd(), inMovementId, vbTotalSummAdd);
         -- Сохранили свойство <Итого Сумма на карточку (БН) для распределения>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardRecalc(), inMovementId, vbTotalSummCardRecalc);
         -- Сохранили свойство <Итого Сумма соц выплаты (из зарплаты)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialIn(), inMovementId, vbTotalSummSocialIn);
         -- Сохранили свойство <Итого Сумма соц выплаты (доп. к зарплате)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialAdd(), inMovementId, vbTotalSummSocialAdd);
         -- Сохранили свойство <Итого Сумма алименты (удержание)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChild(), inMovementId, vbTotalSummChild);
     ELSE
         -- Сохранили свойство <Итого количество("главные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master + vbOperCount_Packer);
         -- Сохранили свойство <Итого количество("подчиненные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
         -- Сохранили свойство <Итого количество у контрагента>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner);
         -- Сохранили свойство <Итого количество, тары>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountTare(), inMovementId, vbOperCount_Tare);
         -- Сохранили свойство <Итого количество, шт>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountSh(), inMovementId, vbOperCount_Sh);
         -- Сохранили свойство <Итого количество, кг>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKg(), inMovementId, vbOperCount_Kg);
         -- Сохранили свойство <Итого сумма по накладной (без НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- Сохранили свойство <Итого сумма по накладной (с НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
         -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_Partner + vbOperSumm_Inventory);
         -- Сохранили свойство <Итого сумма заготовителю по накладной (с учетом НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPacker(), inMovementId, vbOperSumm_Packer);
     END IF;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.14                                        * add vbOperCount_Second
 09.08.14                                        * add zc_Movement_SendOnPrice
 19.07.14                                        * add zc_Movement_EDI
 22.05.14                                        * modify - очень важное кол-во, для него расчет сумм
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
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT * FROM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= 162323)
