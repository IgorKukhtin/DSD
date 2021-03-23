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
                                  WHERE Movement.OperDate = inOperDate - ((date_part('DOW', inOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
                                    AND Movement.DescId = zc_Movement_FinalSUA()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                    AND MovementDate_Calculation.ValueData = inOperDate
                                 )
                  -- строки финальный СУН
                SELECT MovementItem.ObjectId                                              AS GoodsId
                     , SUM(MovementItem.Amount - COALESCE (MIFloat_SendSUN.ValueData, 0)) AS Amount

                FROM tmpFinalSUA
                     INNER JOIN MovementItem ON MovementItem.MovementId = tmpFinalSUA.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                              
                     INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                      AND MILinkObject_Unit.ObjectId = inUnitId

                     LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                 ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()
                GROUP BY MovementItem.ObjectId 
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
                     ) AS tmpFinalSUA_MI ON tmpFinalSUA_MI.GoodsId = _tmp_MI.GoodsId
     WHERE COALESCE (_tmp_MI.AmountSUA,0) <> COALESCE (tmpFinalSUA_MI.Amount, 0)
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