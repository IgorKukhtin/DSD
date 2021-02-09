-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalCountRemains TFloat;
  DECLARE vbTotalSumm TFloat;
  DECLARE vbTotalSummPriceList TFloat;
  DECLARE vbTotalSummRemainsPriceList TFloat;
  DECLARE vbTotalSummJur TFloat;

  DECLARE vbTotalCountSecond TFloat;
  DECLARE vbTotalCountSecondRemains TFloat;
  DECLARE vbTotalSummSecondPriceList TFloat;
  DECLARE vbTotalSummSecondRemainsPriceList TFloat;

  DECLARE vbTotalSummChange TFloat;
  DECLARE vbTotalSummPay TFloat;

  DECLARE vbTotalSummChangePay TFloat;
  DECLARE vbTotalSummPayOth TFloat;
  DECLARE vbTotalCountReturn TFloat;
  DECLARE vbTotalSummReturn TFloat;
  DECLARE vbTotalSummPayReturn TFloat;
  DECLARE vbTotalSummBalance TFloat;

  DECLARE vbTotalSummPriceList_curr TFloat;
  DECLARE vbTotalSummChange_curr TFloat;
  DECLARE vbTotalSummChangePay_curr TFloat;
  DECLARE vbTotalSummPay_curr TFloat;
  DECLARE vbTotalSummPayOth_curr TFloat;
  DECLARE vbTotalSumm_curr TFloat;
  
  DECLARE vbTotalSummPriceListTo_start TFloat;
  DECLARE vbTotalSummPriceListTo TFloat;
  
/*  DECLARE vbTotalCountSecond TFloat;
*/
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;


     -- Эти параметры нужны для расчета конечных сумм
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     --
     SELECT SUM (COALESCE(MovementItem.Amount, 0))                                                                      AS TotalCount
            -- Сумма по Вх. в Валюте - с округлением до 2-х знаков
          , SUM (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData,1) ))    AS TotalSumm
          , SUM (COALESCE (MIFloat_ChangePercent.ValueData, 0)) AS TotalSummChange

            INTO vbTotalCount, vbTotalSumm
               , vbTotalSummChange
       
       FROM MovementItem
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
            
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()

            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                       
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased = false;


  
             -- Сохранили свойство <Итого количество("главные элементы")>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
             -- Сохранили свойство <Итого Сумма>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.20         *
 14.02.19         * add TotalSummJur
 21.07.17         *
 15.06.17         *
 28.04.15                         *
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Income() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
