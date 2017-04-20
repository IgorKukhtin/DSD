-- Function: lpInsertUpdate_MovementItem_Visit()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Visit (Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Visit (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Visit(
 INOUT ioId                Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId        Integer   , -- Ключ объекта <Документ>
    IN inPhotoMobileId     Integer   , -- фото
    IN inComment           TVarChar  , -- 
    IN inUserId            Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
      -- определяется признак Создание/Корректировка
      vbIsInsert:= COALESCE (ioId, 0) = 0;

      -- сохранили <Элемент документа>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPhotoMobileId, inMovementId, 0, NULL);

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 26.03.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Visit (ioId:= 0, inMovementId:= 10, inPhotoMobileId:= 1, inComment:= 'dfgdfg', inUserId:= 1)
