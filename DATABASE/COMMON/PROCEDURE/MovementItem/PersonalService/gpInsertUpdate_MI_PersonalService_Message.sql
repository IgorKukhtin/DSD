-- Function: gpInsertUpdate_MI_PersonalService_Message()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Message(
 INOUT ioId                  Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsInsert Boolean;
BEGIN
     
     -- 
     -- проверка прав пользователя на вызов процедуры
     --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := inSession;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), 0, inMovementId, 0, NULL);
   
       -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     
     -- сохранили 
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
   
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 20.09.17         *
*/

-- тест