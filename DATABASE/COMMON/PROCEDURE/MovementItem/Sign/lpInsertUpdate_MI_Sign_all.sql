-- Function: lpInsertUpdate_MI_Sign_all()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Sign_all (Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Sign_all(
    IN inMovementId      Integer   , -- 
    IN inSignInternalId  Integer   , -- 
    IN inAmount          TFloat   ,
    IN inUserId          Integer
)
RETURNS VOID AS
$BODY$
  DECLARE vbIsInsert Boolean;
  DECLARE vbId Integer;
BEGIN

     vbId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Sign() AND MovementItem.Amount = inAmount AND MovementItem.isErased = FALSE);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbId, 0) = 0;

     -- сохранили <Элемент документа>
     vbId:= lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inSignInternalId, inMovementId, inAmount, NULL);

     -- сохранили ВСЕГДА
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, inUserId);


     -- а теперь еще и УДАЛИМ
     /*IF inIsSign = FALSE
     THEN
         PERFORM lpSetErased_MovementItem (inMovementItemId:= vbId, inUserId:= vbUserId);
     END IF;*/

     -- для док.Акция,
     /*IF (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId) = zc_Movement_Promo()
     THEN
         IF inIsSign = TRUE
         THEN
             -- если подписывает последний пользователь устанавливаем свойства по согласованию
             IF zfCalc_Word_Split (vbStrIdSignNo, ',', vbIndexNo + 1) = '' -- если последний среди неподписанных
             THEN
                  -- сохранили свойство <Согласовано>
                  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId, TRUE);
                  -- сохранили свойство <дата согласования>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId, CURRENT_DATE);
             END IF;
         ELSE
             -- при отмене подписи отменяем согласование
             -- сохранили свойство <Согласовано>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inMovementId, FALSE);
             -- сохранили свойство <дата согласования>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inMovementId, NULL);
         END IF;
     END IF;*/

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 03.08.17         *
 23.08.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Sign_all (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- Степаненко О.М.
-- SELECT * FROM lpInsertUpdate_MI_Sign_all (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- Степаненко О.М.

-- SELECT * FROM lpInsertUpdate_MI_Sign_all (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- Махота Д.П.
-- SELECT * FROM lpInsertUpdate_MI_Sign_all (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- Махота Д.П.
