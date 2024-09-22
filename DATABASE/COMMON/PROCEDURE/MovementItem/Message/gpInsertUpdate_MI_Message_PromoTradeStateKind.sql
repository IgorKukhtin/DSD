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
  DECLARE vbAmount   TFloat;
  DECLARE vbIsChange Boolean;
  DECLARE vbStrIdSignNo TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- определяется
     vbAmount := 0; -- (CASE WHEN inIsQuickly = TRUE THEN 1 ELSE 0 END);


     -- Проверка
     IF COALESCE (inPromoTradeStateKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние не может быть пустым.';
     END IF;

     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = zc_Enum_PromoTradeStateKind_Start())
        AND inPromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Start()
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть изменено на <%>.', lfGet_Object_ValueData_sh (zc_Enum_PromoTradeStateKind_Start()), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;

     -- Проверка - что б научились добавлять
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId IN (zc_Enum_PromoTradeStateKind_Complete_1(), zc_Enum_PromoTradeStateKind_Complete_2(), zc_Enum_PromoTradeStateKind_Complete_3(), zc_Enum_PromoTradeStateKind_Complete_4(), zc_Enum_PromoTradeStateKind_Complete_5(), zc_Enum_PromoTradeStateKind_Complete_6(), zc_Enum_PromoTradeStateKind_Complete_7()))
        AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = inPromoTradeStateKindId)
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть изменено на <%>.', lfGet_Object_ValueData_sh ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId)), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;


     -- определили
     vbIsChange:= inPromoTradeStateKindId <> COALESCE ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = ioId), 0);

     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), inPromoTradeStateKindId, inMovementId
                                       , COALESCE ((SELECT MI.Amount
                                                    FROM MovementItem AS MI
                                                         JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                                                    WHERE MI.MovementId = inMovementId
                                                      AND MI.DescId     = zc_MI_Message()
                                                      AND MI.isErased   = FALSE
                                                      AND (MI.Id        < ioId
                                                        OR ioId         = 0
                                                          )
                                                    ORDER BY MI.Id DESC
                                                    LIMIT 1
                                                   ), vbAmount)
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


     IF vbIsChange = TRUE
     THEN
         -- если последний
         IF ioId = (SELECT MAX (MI.Id)
                    FROM MovementItem AS MI
                         JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                    WHERE MI.MovementId = inMovementId
                      AND MI.DescId     = zc_MI_Message()
                      AND MI.isErased   = FALSE
                   )
         THEN
             -- !!!пересчитали кто подписал/отменил + изменение модели!!!
             PERFORM lpUpdate_MI_Sign_Promo_recalc (inMovementId, inPromoTradeStateKindId, vbUserId);
         END IF;


     END IF;

     -- данные - кто подписал/не подписал - MovementItemId
     vbStrIdSignNo:= (SELECT tmp.StrIdSignNo FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp);

     -- нашли последний - и сохранили в шапку
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, tmp.ObjectId)
              -- сохранили свойство <Дата согласования>
           , lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId
                                        , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() AND vbStrIdSignNo = '' THEN CURRENT_DATE ELSE NULL END
                                         )
              -- сохранили свойство <Согласовано>
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId
                                           , CASE WHEN tmp.ObjectId = zc_Enum_PromoTradeStateKind_Complete_7() AND vbStrIdSignNo = '' THEN TRUE ELSE FALSE END
                                            )
     FROM (SELECT MI.ObjectId, MI.Amount
           FROM MovementItem AS MI
                JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
           WHERE MI.MovementId = inMovementId
             AND MI.DescId     = zc_MI_Message()
             AND MI.isErased   = FALSE
           ORDER BY MI.Id DESC
           LIMIT 1
          ) AS tmp;
          
     --
     IF (vbStrIdSignNo = '') AND inPromoTradeStateKindId IN (zc_Enum_PromoTradeStateKind_Complete_1(), zc_Enum_PromoTradeStateKind_Complete_2(), zc_Enum_PromoTradeStateKind_Complete_3(), zc_Enum_PromoTradeStateKind_Complete_4(), zc_Enum_PromoTradeStateKind_Complete_5(), zc_Enum_PromoTradeStateKind_Complete_6(), zc_Enum_PromoTradeStateKind_Complete_7())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже подписан.Нельзя установить <%>.', CHR (13), lfGet_Object_ValueData_sh (inPromoTradeStateKindId);
     END IF;

/*
    RAISE EXCEPTION 'Ошибка.<%>  %', (SELECT zfCalc_WordNumber_Split (tmp.strIdSign,   ',', lfGet_User_Session (vbUserId))
                            || '  _  ' || zfCalc_WordNumber_Split (tmp.strIdSignNo, ',', lfGet_User_Session (vbUserId))
                                   FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp)
                                , (SELECT count(*) FROM MovementItem WHERE MovementId = inMovementId and DescId = zc_MI_Sign())
                                   ;
*/


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