-- Function: gpUpdate_MI_OrderInternalPromo_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbisSIP     Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     SELECT CASE WHEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0) <> 0
                 THEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0)
                 ELSE COALESCE (MovementFloat_TotalSummSIP.ValueData,0)
            END :: TFloat    AS TotalSumm
          , CASE WHEN COALESCE (MovementFloat_TotalSummPrice.ValueData,0) <> 0 THEN FALSE
                 ELSE TRUE
            END     AS vbisSIP
    INTO vbTotalSumm, vbisSIP
     FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrice
                                ON MovementFloat_TotalSummPrice.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPrice.DescId = zc_MovementFloat_TotalSummPrice()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSIP
                                ON MovementFloat_TotalSummSIP.MovementId = Movement.Id
                               AND MovementFloat_TotalSummSIP.DescId = zc_MovementFloat_TotalSummSIP()
     WHERE Movement.Id = inMovementId;

    IF COALESCE (vbTotalSumm,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Один из реквизитов Сумма по ценам райса или Сумма по ценам СИП должен быть оличен от Нуля.';
    END IF;
    
    CREATE TEMP TABLE tmpData (Id Integer, GoodsId Integer, AmountCalc TFloat) ON COMMIT DROP;
          INSERT INTO tmpData (Id, GoodsId, AmountCalc)
          WITH 
               -- строки мастера с кол-вом для распределения
               tmpMI_Price AS (SELECT MovementItem.Id
                                    , MovementItem.ObjectId             AS GoodsId
                                    , MIFloat_PromoMovementId.ValueData :: Integer AS PromoMovementId
                                    , MIFloat_Price.ValueData  ::TFloat AS Price
                                    , SUM (MIFloat_Price.ValueData) OVER (PARTITION BY MovementItem.MovementId) AS Price_SUM
                               FROM MovementItem
                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE
                               )
                                
                                
             , tmpMI_PriceSIP AS (SELECT tmpMI_Price.Id
                                       , tmpMI_Price.GoodsId
                                       , MIFloat_Price.ValueData     ::TFloat AS Price
                                       , SUM (MIFloat_Price.ValueData) OVER (ORDER BY tmpMI_Price.Id) AS Price_SUM
                                  FROM tmpMI_Price
                                     LEFT JOIN MovementItem AS MI_Promo 
                                                            ON MI_Promo.MovementId = tmpMI_Price.PromoMovementId
                                                           AND MI_Promo.DescId   = zc_MI_Master()
                                                           AND MI_Promo.ObjectId = tmpMI_Price.GoodsId
                                                           AND MI_Promo.isErased = FALSE
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MI_Promo.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 )

             , tmpMI_Master AS (SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_Price AS tmp
                                WHERE vbisSIP = FALSE
                               UNION
                                SELECT tmp.Id
                                     , tmp.GoodsId
                                     , tmp.Price
                                     , tmp.Price_SUM
                                FROM tmpMI_PriceSIP AS tmp
                                WHERE vbisSIP = TRUE
                               )
                      
             -- расчет коэфф.
             , tmpData AS (SELECT tmpMI_Master.*
                                , (tmpMI_Master.Price / tmpMI_Master.Price_SUM) :: TFloat AS Koeff 
                                , ((tmpMI_Master.Price / tmpMI_Master.Price_SUM) * vbTotalSumm) AS AmountOut
                                , SUM ((tmpMI_Master.Price / tmpMI_Master.Price_SUM) * vbTotalSumm) OVER (PARTITION BY tmpMI_Master.Id) AS AmountOutSUM
                           FROM tmpMI_Master
                           )

             , tmpData1 AS (SELECT tmpData.*
                                  , (ROUND (tmpData.AmountOutSUM / tmpData.Price, 0) * tmpData.Price) AS Amount_Calc
                            FROM tmpData
                            )

              -- вспомогательные расчеты для распределения заказа
             , tmpData11 AS (SELECT tmpData1.*
                                  , SUM (tmpData1.Amount_Calc) OVER (ORDER BY /*tmpData1.AmountOut, */tmpData1.Price DESC) AS Amount_CalcSUM
                                  , ROW_NUMBER() OVER (ORDER BY tmpData1.Price ASC) AS DOrd
                             FROM tmpData1
                             )
           -- непосредственно распределение 
           SELECT DD.Id
                , DD.GoodsId
                , CASE WHEN vbTotalSumm - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                            THEN Round (DD.Amount_Calc / DD.Price)                                    ---ceil
                       ELSE CEIL ( (vbTotalSumm - DD.Amount_CalcSUM + DD.Amount_Calc) /  DD.Price)
                  END AS AmountCalc
           FROM tmpData11 AS DD
           WHERE vbTotalSumm - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0
          ;
           
    --- сохраняем данные мастера      
    PERFORM lpInsertUpdate_MovementItem (tmpData.Id, zc_MI_Master(), tmpData.GoodsId, inMovementId, tmpData.AmountCalc, NULL)
    FROM tmpData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.19         *

*/
--select * from gpUpdate_MI_OrderInternalPromo_Amount(inMovementId := 14257740 ,  inSession := '3');