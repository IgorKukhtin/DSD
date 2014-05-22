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
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и Заготовителю
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


     -- Расчет Итоговых суммы
     SELECT 
            -- Количество по факту (главные элементы)
            OperCount_Master
            -- Количество по факту (подчиненные элементы)
          , OperCount_Child
            -- Количество по Контрагенту
          , OperCount_Partner
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
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Partner_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner

            -- Количество по Заготовителю
          , OperCount_Packer AS OperCount_Packer

            -- Сумма по Заготовителю
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- сумма ввода остатка
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

            FROM (SELECT tmpMI.GoodsId
                       , tmpMI.GoodsKindId
                       , tmpMI.Price
                       , tmpMI.CountForPrice

                         -- очень важное кол-во, для него расчет сумм
                       , tmpMI.OperCount_calc

                       , tmpMI.OperCount_Master
                       , tmpMI.OperCount_Child
                       , tmpMI.OperCount_Partner
                       , tmpMI.OperCount_Packer

                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Tare
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                   THEN 0
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                               AND tmpMI.Price <> 0
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Sh
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                   THEN 0
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   -- AND tmpMI.Price <> 0
                                        THEN 0 -- tmpMI.OperCount_calc * COALESCE (ObjectFloat_Weight.ValueData, 0)
                                   ELSE tmpMI.OperCount_calc
                         END AS OperCount_Kg

                        -- сумма ввода остатка
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

                               -- очень важное кол-во, для него расчет сумм
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

     -- Тест
     -- RAISE EXCEPTION '%', vbOperCount_Master;

     IF vbMovementDescId = zc_Movement_PersonalSendCash() OR vbMovementDescId = zc_Movement_PersonalAccount()
     THEN
         -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
     ELSE
         -- Сохранили свойство <Итого количество("главные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master);
         -- Сохранили свойство <Итого количество("подчиненные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
         -- Сохранили свойство <Итого количество у контрагента>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner + vbOperCount_Packer);
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


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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

-- тест
-- SELECT * FROM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= 162323)
