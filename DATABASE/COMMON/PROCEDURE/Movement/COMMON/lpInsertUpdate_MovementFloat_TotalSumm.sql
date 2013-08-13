-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

-- DROP FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
--  RETURNS TABLE () AS
$BODY$
  DECLARE vbOperCount_Master TFloat;
  DECLARE vbOperCount_Child TFloat;
  DECLARE vbOperCount_Partner TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperCount_Packer TFloat;
  DECLARE vbOperSumm_Packer TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
BEGIN

     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и Заготовителю
     SELECT
           COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
         , COALESCE (MovementFloat_VATPercent.ValueData, 0)
         , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END
         , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
           INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
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
     WHERE Movement.Id = inMovementId;


     -- Расчет Итоговых суммы
     SELECT 
            -- Количество по факту (главные элементы)
            tmpOperCount_Master
          , -- Количество по факту (подчиненные элементы)
            tmpOperCount_Child
          , -- Количество по Контрагенту
            tmpOperCount_Partner
            -- Сумма без НДС
          , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены без НДС или %НДС=0
                    THEN (tmpOperSumm_Partner)
                 WHEN vbPriceWithVAT AND 1=1
                    -- если цены c НДС
                    THEN CAST ( (tmpOperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                    -- если цены c НДС (Вариант может быть если  первичен расчет НДС =1/6 )
                    THEN tmpOperSumm_Partner - CAST ( (tmpOperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
            END
            -- Сумма с НДС
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС
                    THEN (tmpOperSumm_Partner)
                 WHEN vbVATPercent > 0
                    -- если цены без НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
            END
            -- Сумма по Контрагенту
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Partner)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                         END
            END

            -- Количество по Заготовителю
          , tmpOperCount_Packer
            -- Сумма по Заготовителю
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperCount_Partner, vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner, vbOperCount_Packer, vbOperSumm_Packer
     FROM 
          (SELECT 
                 SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS tmpOperCount_Master
               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS tmpOperCount_Child
               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS tmpOperCount_Partner
                 -- сумма по Контрагенту - с округлением до 2-х знаков
               , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                      END) AS tmpOperSumm_Partner

               , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0)) AS tmpOperCount_Packer
                 -- промежуточная сумма по Заготовителю - с округлением до 2-х знаков
               , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                      END) AS tmpOperSumm_Packer
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

            WHERE Movement.Id = inMovementId
          ) AS _tmp;


     -- Сохранили свойство <Итого количество("главные элементы")>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master);
     -- Сохранили свойство <Итого количество("подчиненные элементы")>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
     -- Сохранили свойство <Итого количество у контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner + vbOperCount_Packer);
     -- Сохранили свойство <Итого сумма по накладной (без НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
     -- Сохранили свойство <Итого сумма по накладной (с НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
     -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_Partner);
     -- Сохранили свойство <Итого сумма заготовителю по накладной (с учетом НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPacker(), inMovementId, vbOperSumm_Packer);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.13                                        * add vbOperCount_Master and vbOperCount_Child
 16.07.13                                        * add COALESCE (MIFloat_AmountPartner... and MIFloat_AmountPacker...
 07.07.13                                        *
*/

-- тест
-- SELECT * FROM Send (inMovementId:= 5028)
