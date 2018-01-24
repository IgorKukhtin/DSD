-- Function: gpComplete_Movement_Promo()

DROP FUNCTION IF EXISTS gpComplete_Movement_Promo  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Promo());


     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                GROUP BY MovementItem.ObjectId
                HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
               )
     THEN 
         RAISE EXCEPTION 'Ошибка.Для товара <%> введен разный Процент скидки : <%> и <%>.'
                       , lfGet_Object_ValueData(
                         (SELECT MovementItem.ObjectId
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId
                          LIMIT 1
                         ))
                       , zfConvert_FloatToString(
                         (SELECT MIN (MovementItem.Amount)
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId
                          LIMIT 1
                         ))
                       , zfConvert_FloatToString(
                         (SELECT MAX (MovementItem.Amount)
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId
                          LIMIT 1
                         ))
               ;
     END IF;

     -- сохранение "новых" контрагентов + по продажам за аналогичный период
     PERFORM lpUpdate_Movement_Promo_Auto (inMovementId := inMovementId
                                         , inUserId     := vbUserId
                                          );

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Promo()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 29.11.15                                        * add lpUpdate_Movement_Promo_Auto
 13.10.15                                                         *
 */