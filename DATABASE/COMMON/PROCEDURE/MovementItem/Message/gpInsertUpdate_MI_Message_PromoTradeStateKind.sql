-- Function: gpInsertUpdate_MI_Message_PromoTradeStateKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Message_PromoTradeStateKind (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Message_PromoTradeStateKind(
 INOUT ioId                      Integer   , --
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inPromoTradeStateKindId   Integer   , -- Состояние
    IN inIsQuickly               Boolean   , -- Приоритет - срочно
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsInsert Boolean;
  DECLARE vbAmount_sign TFloat;
  DECLARE vbIsChange Boolean;
  DECLARE vbStrIdSignNo TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTradeStateKind());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Проверка
     IF COALESCE (inPromoTradeStateKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние не может быть пустым.';
     END IF;

     -- Проверка
     IF inPromoTradeStateKindId IN (zc_Enum_PromoTradeStateKind_Complete_1()
                                  , zc_Enum_PromoTradeStateKind_Complete_2()
                                  , zc_Enum_PromoTradeStateKind_Complete_3()
                                  , zc_Enum_PromoTradeStateKind_Complete_4()
                                  , zc_Enum_PromoTradeStateKind_Complete_5()
                                  , zc_Enum_PromoTradeStateKind_Complete_6()
                                  , zc_Enum_PromoTradeStateKind_Complete_7()
                                   )
        AND zc_Enum_Status_Complete() <> (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ должен быть в статусе<%>.Согласование заблокировано.'
                       , (SELECT lfGet_Object_ValueData_sh (zc_Enum_Status_Complete()) FROM Movement WHERE Movement.Id = inMovementId)
                     --, (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- кто последний подтвердил
     vbAmount_sign:= COALESCE ((SELECT MAX (gpSelect.Ord) FROM gpSelect_MI_Sign (inMovementId, FALSE, inSession) AS gpSelect WHERE gpSelect.isSign = TRUE), 0);


     -- Проверка
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect WHERE lpSelect.UserId = vbUserId)
      -- кроме первого
      AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Start()
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав для согласования.', lfGet_Object_ValueData_sh (vbUserId);
     END IF;

     -- Проверка
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect WHERE lpSelect.UserId = vbUserId AND lpSelect.Num = vbAmount_sign + 1)
      -- кроме первого
      AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Start()
      AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Return()
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав для согласования раньше чем <%>.'
                       , (SELECT gpSelect.UserName FROM gpSelect_MI_Sign (inMovementId, FALSE, inSession) AS gpSelect WHERE gpSelect.Ord = vbAmount_sign + 1);
     END IF;


     -- Проверка
     /*IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = zc_Enum_PromoTradeStateKind_Start())
        AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Start()
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть изменено на <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoTradeStateKind_Start()), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;

     -- Проверка - что б научились добавлять
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId IN (zc_Enum_PromoTradeStateKind_Complete_1(), zc_Enum_PromoTradeStateKind_Complete_2(), zc_Enum_PromoTradeStateKind_Complete_3(), zc_Enum_PromoTradeStateKind_Complete_4(), zc_Enum_PromoTradeStateKind_Complete_5(), zc_Enum_PromoTradeStateKind_Complete_6(), zc_Enum_PromoTradeStateKind_Complete_7()))
        AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = inPromoTradeStateKindId)
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть изменено на <%>.', lfGet_Object_ValueData_sh ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId)), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;*/


     -- определили
     -- vbIsChange:= inPromoTradeStateKindId <> COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId), 0);

     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), inPromoTradeStateKindId, inMovementId
                                       , 0
                                       , NULL
                                       );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;


     IF inPromoTradeStateKindId NOT IN (zc_Enum_PromoTradeStateKind_Start(), zc_Enum_PromoTradeStateKind_Return())
     THEN
         -- !!!пересчитали кто подписал/отменил!!!
         PERFORM lpInsertUpdate_MI_Sign_all (inMovementId     := inMovementId
                                           , inSignInternalId := 11307029 -- Трейд-маркетинг
                                           , inAmount         := CASE inPromoTradeStateKindId
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 1
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 2
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 3
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 4
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 5
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 6
                                                                      WHEN zc_Enum_PromoTradeStateKind_Complete_7() THEN 7
                                                                 END
                                           , inUserId         := vbUserId
                                            );

     ELSEIF inPromoTradeStateKindId = zc_Enum_PromoTradeStateKind_Return()
     THEN
         -- сняли ВСЕ подписи
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Sign()
           AND MovementItem.isErased   = FALSE
          ;

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 01.04.20         *
*/

-- тест
--