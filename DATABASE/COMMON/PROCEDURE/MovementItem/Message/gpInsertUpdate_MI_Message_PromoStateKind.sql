-- Function: gpInsertUpdate_MI_Message_PromoStateKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Message_PromoStateKind (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Message_PromoStateKind(
 INOUT ioId                  Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPromoStateKindId    Integer   ,
    IN inisQuickly           Boolean   ,
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsInsert Boolean;
  DECLARE vbAmount   TFloat;
BEGIN
     
     -- 
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     vbAmount := (CASE WHEN inisQuickly = TRUE THEN 1 ELSE 0 END);
     
     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), inPromoStateKindId, inMovementId, vbAmount, NULL);
   
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
       

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
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