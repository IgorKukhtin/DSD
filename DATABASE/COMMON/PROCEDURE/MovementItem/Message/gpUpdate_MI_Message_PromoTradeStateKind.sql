-- Function: gpUpdate_MI_Message_PromoTradeStateKind()

DROP FUNCTION IF EXISTS gpUpdate_MI_Message_PromoTradeStateKind (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Message_PromoTradeStateKind(
 INOUT ioId                      Integer   , --
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inPromoTradeStateKindId   Integer   , -- Состояние
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTradeStateKind());
     
     
     IF inPromoTradeStateKindId = -1
     THEN

         IF COALESCE (ioId, 0) = 0
         THEN 
             RAISE EXCEPTION 'Ошибка.Элемент не найден.';
         END IF;

         IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = zc_Enum_PromoTradeStateKind_Start())
         THEN 
             RAISE EXCEPTION 'Ошибка.Нет прав для удаления <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoTradeStateKind_Start());
         END IF;


         IF NOT EXISTS (SELECT MovementItem.Id
                        FROM MovementItem
                        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Sign() AND MovementItem.isErased = FALSE
                          AND MovementItem.Amount = CASE (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId)
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 1
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 2
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 3
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 4
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 5
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 6
                                                         WHEN zc_Enum_PromoTradeStateKind_Complete_7() THEN 7
                                                    END
                       )
         THEN 
             RAISE EXCEPTION 'Ошибка.Не найден элемент  для отмены согласования № п/п = <%>'
                            , (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId)
                             ;
         END IF;


         -- !!!убрать подпись!!!
         PERFORM lpSetErased_MovementItem (inMovementItemId:= (SELECT MovementItem.Id
                                                               FROM MovementItem
                                                               WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Sign() AND MovementItem.isErased = FALSE
                                                               AND MovementItem.Amount = CASE (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId)
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 1
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 2
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 3
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 4
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 5
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 6
                                                                                              WHEN zc_Enum_PromoTradeStateKind_Complete_7() THEN 7
                                                                                         END
                                                              )
                                         , inUserId        := vbUserId
                                          );
         -- удалили состояние
         PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId
                                         , inUserId        := vbUserId
                                          );

     ELSE
          -- добавили состояние
          ioId:= gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := ioId
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := inPromoTradeStateKindId
                                                              , inIsQuickly             := TRUE
                                                              , inComment               := inComment
                                                              , inSession               := inSession
                                                               );
     END IF;

     -- нашли последний - и сохранили в шапку
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, COALESCE (tmp.ObjectId, zc_Enum_PromoTradeStateKind_Start()))
              -- сохранили свойство <Дата согласования>
           , lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId
                                        , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() THEN CURRENT_DATE ELSE NULL END
                                         )
              -- сохранили свойство <Согласовано>
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId
                                           , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() THEN TRUE ELSE FALSE END
                                            )
     FROM (SELECT 1 AS x) AS xx
          CROSS JOIN
          (SELECT MI.ObjectId, MI.Amount
           FROM MovementItem AS MI
                JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
           WHERE MI.MovementId = inMovementId
             AND MI.DescId     = zc_MI_Message()
             AND MI.isErased   = FALSE
           ORDER BY MI.Id DESC
           LIMIT 1
          ) AS tmp;


     -- RAISE EXCEPTION 'Ошибка.OK';

     IF inComment ILIKE 'тест'
     THEN 
         RAISE EXCEPTION 'Ошибка.тест.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 27.06.20                                       *
*/

-- тест
--