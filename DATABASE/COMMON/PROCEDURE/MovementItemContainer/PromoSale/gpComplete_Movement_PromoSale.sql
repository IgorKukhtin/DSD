-- Function: gpComplete_Movement_PromoSale()

DROP FUNCTION IF EXISTS gpComplete_Movement_PromoSale  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PromoSale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoSale());


     -- нашли
     vbStartSale:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_StartSale());
     vbEndSale  := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_EndSale());

    -- Проверили - Ви товара
    IF EXISTS (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                          ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                         AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                        , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                        , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                         )
                                         AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
                 AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
              )
    THEN
        RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
    END IF;


     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> <%> введен разный Процент скидки : <%> и <%>.'
                       , lfGet_Object_ValueData(
                         (SELECT MovementItem.ObjectId
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          LIMIT 1
                         ))
                       , lfGet_Object_ValueData(
                         (SELECT COALESCE (MILinkObject_GoodsKind.ObjectId)
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
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
     PERFORM lpUpdate_Movement_PromoSale_Auto (inMovementId := inMovementId
                                             , inUserId     := vbUserId
                                              );

      -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PromoSale()
                                , inUserId     := vbUserId
                                 );

     if vbUserId = 5 AND 1=0 then RAISE EXCEPTION 'Нет Прав - что б ничего не делать'; end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.26         *
 */