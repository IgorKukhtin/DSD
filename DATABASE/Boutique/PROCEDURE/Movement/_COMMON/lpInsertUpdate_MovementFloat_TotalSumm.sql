-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSale (Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummIncome (Integer);
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
     SELECT SUM(COALESCE(MovementItem.Amount, 0))             AS TotalCount
          , SUM(COALESCE(MIFloat_AmountRemains.ValueData, 0)) AS TotalCountRemains

          , SUM(zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)) AS TotalSumm
          , SUM(zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)) AS TotalSummPriceList
          , SUM(zfCalc_SummPriceList (MIFloat_AmountRemains.ValueData, MIFloat_OperPriceList.ValueData)) AS TotalSummRemainsPriceList
          ---
          , SUM(COALESCE(MIFloat_AmountSecond.ValueData, 0))        AS TotalCountSecond
          , SUM(COALESCE(MIFloat_AmountSecondRemains.ValueData, 0)) AS TotalCountSecondRemains
          , SUM(zfCalc_SummPriceList (MIFloat_AmountSecond.ValueData, MIFloat_OperPriceList.ValueData)) AS TotalSummSecondPriceList      
          , SUM(zfCalc_SummPriceList (MIFloat_AmountSecondRemains.ValueData, MIFloat_OperPriceList.ValueData)) AS TotalSummSecondRemainsPriceList
          
          , SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_ChangePercent.ValueData, 0)) :: TFloat AS TotalSummChange
          , SUM (COALESCE (MIFloat_TotalPay.ValueData,0))                                                            :: TFloat AS TotalSummPay

          , SUM (COALESCE (MIFloat_TotalChangePercentPay.ValueData,0)) ::TFloat AS TotalSummChangePay
          , SUM (COALESCE (MIFloat_TotalPayOth.ValueData,0))           ::TFloat AS TotalSummPayOth
          , SUM (COALESCE (MIFloat_TotalCountReturn.ValueData,0))      ::TFloat AS TotalCountReturn
          , SUM (COALESCE (MIFloat_TotalReturn.ValueData,0))           ::TFloat AS TotalSummReturn
          , SUM (COALESCE (MIFloat_TotalPayReturn.ValueData,0))        ::TFloat AS TotalSummPayReturn

          --, COALESCE (MIFloat_CurrencyValue.ValueData, 0)              ::TFloat AS CurrencyValue
          --, COALESCE (MIFloat_ParValue.ValueData, 0)                   ::TFloat AS ParValue
          , SUM (CAST (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)
                        * COALESCE (MIFloat_CurrencyValue.ValueData, 0) / CASE WHEN COALESCE (MIFloat_ParValue.ValueData, 0) <> 0
                                                                               THEN COALESCE (MIFloat_ParValue.ValueData, 0) ELSE 1
                                                                          END AS NUMERIC (16, 2))   ) :: TFloat AS TotalSummBalance
    INTO vbTotalCount, vbTotalCountRemains, vbTotalSumm, vbTotalSummPriceList, vbTotalSummRemainsPriceList
       , vbTotalCountSecond, vbTotalCountSecondRemains, vbTotalSummSecondPriceList, vbTotalSummSecondRemainsPriceList
       , vbTotalSummChange, vbTotalSummPay, vbTotalSummChangePay, vbTotalSummPayOth, vbTotalCountReturn, vbTotalSummReturn, vbTotalSummPayReturn
       , vbTotalSummBalance
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()    
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecondRemains
                                        ON MIFloat_AmountSecondRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecondRemains.DescId = zc_MIFloat_AmountSecondRemains()

            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()    
                                       AND vbMovementDescId                     = zc_Movement_GoodsAccount()    

            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                        ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                        ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                        ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                        ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                        ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()    

            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
      WHERE MovementItem.MovementId = inMovementId 
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased = false;

      IF vbMovementDescId IN (zc_Movement_Send(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Loss())
         THEN
             -- Сохранили свойство <Итого сумма вх. в ГРН>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummBalance(), inMovementId, vbTotalSummBalance);
      END IF;

      IF vbMovementDescId IN (zc_Movement_Inventory())
         THEN
             -- Сохранили свойство <Итого количество("главные элементы")>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount + vbTotalCountSecond);
             -- Сохранили свойство <Итого Сумма реализации>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList(), inMovementId, vbTotalSummPriceList + vbTotalSummSecondPriceList);

             -- Сохранили свойство <Итого количество остатка>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountRemains(), inMovementId, vbTotalCountRemains + vbTotalCountSecondRemains);
             -- Сохранили свойство <Итого Сумма реализации остатка>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummRemainsPriceList(), inMovementId, vbTotalSummRemainsPriceList + vbTotalSummSecondRemainsPriceList);
      ELSE
      
             -- Сохранили свойство <Итого количество("главные элементы")>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
             -- Сохранили свойство <Итого Сумма>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
             -- Сохранили свойство <Итого Сумма реализации>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList(), inMovementId, vbTotalSummPriceList);

             -- Сохранили свойство <Итого количество остатка>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountRemains(), inMovementId, vbTotalCountRemains);
             -- Сохранили свойство <Итого Сумма реализации остатка>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummRemainsPriceList(), inMovementId, vbTotalSummRemainsPriceList);

             -- Сохранили свойство <Итого сумма скидки в ГРН>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange(), inMovementId, vbTotalSummChange);
             -- Сохранили свойство <Итого сумма оплаты (в ГРН)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPay(), inMovementId, vbTotalSummPay);
             -- Сохранили свойство <Итого сумма скидки в ГРН>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChangePay(), inMovementId, vbTotalSummChangePay);
             -- Сохранили свойство <Итого сумма оплаты (в ГРН)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), inMovementId, vbTotalSummPayOth);
             -- Сохранили свойство <Итого количество возврата>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountReturn(), inMovementId, vbTotalCountReturn);
             -- Сохранили свойство <Итого сумма возврата со скидкой (в ГРН)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummReturn(), inMovementId, vbTotalSummReturn);
             -- Сохранили свойство <Итого сумма возврата оплаты (в ГРН)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayReturn(), inMovementId, vbTotalSummPayReturn);

      END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.17         *
 15.06.17         *
 28.04.15                         * 
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Income() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
