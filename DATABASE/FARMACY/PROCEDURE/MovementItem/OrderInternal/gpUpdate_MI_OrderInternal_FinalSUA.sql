-- Function: gpUpdate_MI_OrderInternal_FinalSUA()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_FinalSUA (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_FinalSUA(
    IN inMovementId          Integer   , -- Ключ объекта <документ>
    IN inUnitId              Integer   , -- подразделение
    IN inOperDate            TDateTime , -- подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- строки заказа
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, AmountSUA TFloat, AmountManual TFloat, Comment TVarChar) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, AmountSUA, AmountManual, Comment)
             WITH
                  tmpMI AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            )
                  -- сохраненные данные кол-во СУА
                , tmpMIFloat_AmountSUA AS (SELECT MovementItemFloat.*
                                           FROM MovementItemFloat
                                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             AND MovementItemFloat.DescId = zc_MIFloat_AmountSUA()
                                             AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                           )
                  -- сохраненные данные <Ручное количество>
                , tmpMIFloat_AmountManual AS (SELECT MovementItemFloat.*
                                              FROM MovementItemFloat
                                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                AND MovementItemFloat.DescId = zc_MIFloat_AmountManual()
                                                AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                              )
                , tmpMI_String AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                  )
                
             SELECT tmpMI.Id
                  , tmpMI.GoodsId
                  , COALESCE (MIFloat_AmountSUA.ValueData, 0)        AS AmountSUA
                  , COALESCE (MIFloat_AmountManual.ValueData, 0)     AS AmountManual
                  , COALESCE (tmpMI_String.ValueData, '') ::TVarChar AS Comment
             FROM tmpMI
                  LEFT JOIN tmpMIFloat_AmountSUA    AS MIFloat_AmountSUA    ON MIFloat_AmountSUA.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMIFloat_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMI_String            AS tmpMI_String         ON tmpMI_String.MovementItemId = tmpMI.Id
                  ;
                  
             
     -- Данные из док. отказ
     CREATE TEMP TABLE _tmpFinalSUA_MI (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
       INSERT INTO _tmpFinalSUA_MI (GoodsId, Amount)
              WITH    
                  -- документ финальный СУН
                  tmpFinalSUA AS (SELECT Movement.id
                                  FROM Movement
                                       LEFT JOIN MovementDate AS MovementDate_Calculation
                                                              ON MovementDate_Calculation.MovementId = Movement.Id
                                                             AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()
                                       LEFT JOIN MovementDate AS MovementDate_DateOrder
                                                              ON MovementDate_DateOrder.MovementId = Movement.Id
                                                             AND MovementDate_DateOrder.DescId = zc_MovementDate_Order()

                                       LEFT JOIN MovementBoolean AS MovementBoolean_OnlyOrder
                                                                 ON MovementBoolean_OnlyOrder.MovementId = Movement.Id
                                                                AND MovementBoolean_OnlyOrder.DescId = zc_MovementBoolean_OnlyOrder()

                                  WHERE Movement.OperDate = inOperDate - ((date_part('DOW', inOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
                                    AND Movement.DescId = zc_Movement_FinalSUA()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                    AND (COALESCE (MovementBoolean_OnlyOrder.ValueData, FALSE) = TRUE OR MovementDate_Calculation.ValueData IS NOT NULL) 
                                    AND COALESCE(MovementDate_DateOrder.ValueData, MovementDate_Calculation.ValueData) = inOperDate
                                 )
                 , MI_Master AS (SELECT MovementItem.ObjectId                   AS GoodsId
                                      , SUM(MovementItem.Amount)                AS Amount
                                      , SUM(MIFloat_SendSUN.ValueData)          AS SendSUN
                                 FROM MovementItem

                                     INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                      AND MILinkObject_Unit.ObjectId = inUnitId

                                     LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                                 ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()

                                 WHERE MovementItem.MovementId in (SELECT tmpFinalSUA.Id FROM tmpFinalSUA)
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = False
                                   AND MovementItem.Amount > 0
                                  GROUP BY MovementItem.ObjectId 
                                 )
                 , tmpContainer AS (SELECT MI_Master.GoodsId                  AS GoodsId
                                         , Sum(Container.Amount)::TFloat      AS Amount
                                    FROM MI_Master
                                      
                                         INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                             AND Container.ObjectId = MI_Master.GoodsId
                                                             AND Container.WhereObjectId = inUnitId
                                                             AND Container.Amount <> 0
                                                             
                                    GROUP BY MI_Master.GoodsId
                                    )
                 , tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        )

                                 
                  -- строки финальный СУН
                SELECT MI_Master.GoodsId                                                                                     AS GoodsId
                     , CEIL(MI_Master.Amount - COALESCE (MI_Master.SendSUN, 0) - COALESCE (Container.Amount, 0))            AS Amount

                FROM MI_Master
                
                     LEFT JOIN tmpContainer AS Container
                                            ON Container.GoodsId = MI_Master.GoodsId
                                           
                     LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = MI_Master.GoodsId
                     
                WHERE CEIL(MI_Master.Amount - COALESCE (MI_Master.SendSUN, 0) - COALESCE (Container.Amount, 0)) > 0
                  AND COALESCE(tmpObject_Price.MCSIsClose, FALSE) = False
                ;
                
     IF NOT EXISTS(SELECT * FROM _tmpFinalSUA_MI)
     THEN
       RAISE EXCEPTION 'Ошибка. Итоговый СУА для подразделения не найден.';
     END IF;
     
           
     -- сохраняем свойства, если такого товара нет в заказе дописываем
     PERFORM lpInsertUpdate_MI_OrderInternal_FinalSUA (inId             := COALESCE (_tmp_MI.Id, 0)
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := COALESCE ( _tmp_MI.GoodsId, tmpFinalSUA_MI.GoodsId)
                                                     , inAmountManual   := CASE WHEN COALESCE (_tmp_MI.AmountManual,0) >= COALESCE (tmpFinalSUA_MI.Amount, 0)    -- ренее была сумма этих значений
                                                                                THEN COALESCE (_tmp_MI.AmountManual,0)
                                                                                ELSE COALESCE (tmpFinalSUA_MI.Amount, 0)
                                                                           END ::TFloat
                                                     , inAmountSUA      := COALESCE (tmpFinalSUA_MI.Amount, 0)::TFloat

                                                     , inUserId         := vbUserId
                                                     )
     FROM _tmp_MI
          FULL JOIN (SELECT _tmpFinalSUA_MI.GoodsId      AS GoodsId
                          , _tmpFinalSUA_MI.Amount       AS Amount
                     FROM _tmpFinalSUA_MI
                     WHERE _tmpFinalSUA_MI.Amount > 0
                     ) AS tmpFinalSUA_MI ON tmpFinalSUA_MI.GoodsId = _tmp_MI.GoodsId
     WHERE COALESCE (_tmp_MI.AmountSUA,0) <> COALESCE (tmpFinalSUA_MI.Amount, 0)
     ;
     
                  
     -- Правим по сроку годности
     PERFORM lpInsertUpdate_MI_OrderInternal_FinalSUA (inId             := tmpOrderInternalAll.Id
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := tmpOrderInternalAll.GoodsId
                                                     , inAmountManual   := 0
                                                     , inAmountSUA      := 0
                                                     , inUserId         := vbUserId
                                                     )
     FROM (SELECT * FROM gpSelect_MovementItem_OrderInternal_Master(inMovementId := inMovementId 
                                                                  , inShowAll    := False 
                                                                  , inIsErased   := False 
                                                                  , inIsLink     := False
                                                                  , inSession    := inSession)) AS tmpOrderInternalAll
                  -- ранее сохраненные данные
          LEFT JOIN _tmp_MI ON _tmp_MI.Id = tmpOrderInternalAll.Id                                     

     WHERE COALESCE (tmpOrderInternalAll.AmountSUA, 0) > 0
       AND COALESCE (_tmp_MI.AmountManual, 0) = 0
       AND (COALESCE(tmpOrderInternalAll.ContractId, 0) = 0
        OR COALESCE(tmpOrderInternalAll.PartionGoodsDate, zc_DateEnd()) <= CASE WHEN COALESCE (tmpOrderInternalAll.Layout, 0) > 0 
                                                                                THEN  CURRENT_DATE + INTERVAL '9 MONTH' 
                                                                                ELSE CURRENT_DATE + INTERVAL '1 YEAR' END)
     ;     
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.03.21                                                       *
*/

-- тест
-- select * from gpUpdate_MI_OrderInternal_FinalSUA(inMovementId := 22630094 , inUnitId := 16240371 , inOperDate := ('23.03.2021')::TDateTime ,  inSession := '3');
-- select * from gpUpdate_MI_OrderInternal_FinalSUA(inMovementId := 22922846 , inUnitId := 16240371 , inOperDate := ('12.04.2021')::TDateTime ,  inSession := '3');