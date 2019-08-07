-- Function: gpUpdate_MI_OrderInternal_AmountReal_RemainsSun()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_AmountReal_RemainsSun (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_AmountReal_RemainsSun(
    IN inMovementId          Integer   , -- Ключ объекта <документ>
    IN inUnitId              Integer   , -- подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- Данные
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- Данные по остаткам сроковых товаров на подразделении
     CREATE TEMP TABLE _tmpRemainsGoodsPartionDate (GoodsId Integer, Amount TFloat, AmountRemains TFloat) ON COMMIT DROP;
       INSERT INTO _tmpRemainsGoodsPartionDate (GoodsId, Amount, AmountRemains)
          SELECT tmp.GoodsId              AS GoodsId
               , SUM (tmp.Amount)         AS Amount
               , SUM (tmp.AmountRemains)  AS AmountRemains
          FROM gpReport_GoodsPartionDate( inUnitId := inUnitId , inGoodsId := 0, inIsDetail := False ,  inSession := inSession) AS tmp
          WHERE tmp.Amount <> 0
            AND tmp.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_6())
          GROUP BY tmp.GoodsId;


     -- строки заказа
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, Amount TFloat, AmountReal TFloat, RemainsSUN TFloat, SendSUN TFloat, SendDefSUN TFloat) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, Amount, AmountReal, RemainsSUN, SendSUN, SendDefSUN)
             WITH tmpSend AS (SELECT MovementItem.ObjectId     AS GoodsId
                                   , SUM (MovementItem.Amount) AS SendSUN
                                   , 0                         AS SendDefSUN
                              FROM Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                AND MovementLinkObject_To.ObjectId   = inUnitId
                                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                             AND MovementBoolean_SUN.ValueData  = TRUE
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                              WHERE Movement.OperDate = vbOperDate
                                AND Movement.DescId   = zc_Movement_Send()
                                AND Movement.StatusId = zc_Enum_Status_Erased()
                                AND vbOperDate >= '30.07.2019'
                              GROUP BY MovementItem.ObjectId

                             UNION ALL
                              SELECT MovementItem.ObjectId     AS GoodsId
                                   , 0                         AS SendSUN
                                   , SUM (MovementItem.Amount) AS SendDefSUN
                              FROM Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                AND MovementLinkObject_To.ObjectId   = inUnitId
                                   INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                              ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                             AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                             AND MovementBoolean_DefSUN.ValueData = TRUE
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                              WHERE Movement.OperDate = vbOperDate
                                AND Movement.DescId   = zc_Movement_Send()
                                AND Movement.StatusId = zc_Enum_Status_Erased()
                                AND vbOperDate >= '30.07.2019'
                              GROUP BY MovementItem.ObjectId
                             )
             -- Результат
             SELECT MovementItem.Id
                  , MovementItem.ObjectId AS GoodsId
               -- , MovementItem.Amount
                  , COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount
                  , COALESCE (MIFloat_AmountReal.ValueData, 0)   AS AmountReal
                  , COALESCE (MIFloat_RemainsSUN.ValueData, 0)   AS RemainsSUN
                  , COALESCE (tmpSend.SendSUN, 0)                AS SendSUN
                  , COALESCE (tmpSend.SendDefSUN, 0)             AS SendDefSUN
             FROM MovementItem

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                              ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountReal.DescId         = zc_MIFloat_AmountReal()
                  LEFT JOIN MovementItemFloat AS MIFloat_RemainsSUN
                                              ON MIFloat_RemainsSUN.MovementItemId = MovementItem.Id
                                             AND MIFloat_RemainsSUN.DescId         = zc_MIFloat_RemainsSUN()
                  LEFT JOIN tmpSend ON tmpSend.GoodsId = MovementItem.ObjectId
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE;


     -- сохраняем свойства,
     /*заказ без учета СУН - это то что сейчас в эмаунте, но только в том случае если есть сроковый, а в Амоунт пишешь ноль*/
     PERFORM lpInsertUpdate_MI_OrderInternal_SUN (inId             := COALESCE (_tmp_MI.Id, 0)
                                                , inMovementId     := inMovementId
                                                , inGoodsId        := _tmp_MI.GoodsId
                                                , inAmount         := CASE WHEN _tmpRemains.Amount     <> 0
                                                                             OR _tmp_MI.SendSUN    <> 0
                                                                             OR _tmp_MI.SendDefSUN <> 0
                                                                           THEN 0
                                                                           WHEN _tmp_MI.Amount     <> 0 THEN _tmp_MI.Amount
                                                                           ELSE _tmp_MI.AmountReal
                                                                      END :: TFloat
                                                , inAmountReal     := CASE WHEN (_tmpRemains.Amount <> 0 OR _tmp_MI.SendSUN <> 0 OR _tmp_MI.SendDefSUN <> 0)
                                                                            AND _tmp_MI.Amount <> 0
                                                                           THEN _tmp_MI.Amount

                                                                           WHEN _tmpRemains.Amount <> 0  OR _tmp_MI.SendSUN <> 0 OR _tmp_MI.SendDefSUN <> 0
                                                                                THEN _tmp_MI.AmountReal
                                                                           ELSE 0
                                                                      END :: TFloat
                                                , inRemainsSUN     := COALESCE (_tmpRemains.Amount, 0) :: TFloat
                                                , inSendSUN        := _tmp_MI.SendSUN
                                                , inSendDefSUN     := _tmp_MI.SendDefSUN
                                                , inUserId         := vbUserId
                                                 )
     FROM _tmp_MI
          LEFT JOIN _tmpRemainsGoodsPartionDate AS _tmpRemains ON _tmpRemains.GoodsId = _tmp_MI.GoodsId
          -- AND 1=0
     ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.19         *
*/

-- тест
--