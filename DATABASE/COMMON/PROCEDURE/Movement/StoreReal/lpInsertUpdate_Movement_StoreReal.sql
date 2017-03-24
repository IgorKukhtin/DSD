-- Function: lpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TFloat);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StoreReal (
 INOUT ioId        Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber TVarChar  , -- Номер документа
    IN inOperDate  TDateTime , -- Дата документа
    IN inUserId    Integer   , -- пользователь
    IN inPartnerId Integer   , -- Контрагент
    IN inGUID      TVarChar  , -- Глобальный уникальный идентификатор	для синхронизации с мобильными устройствами
    IN inComment   TVarChar    -- Примечание
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- проверка
      IF inOperDate <> DATE_TRUNC('DAY', inOperDate)
      THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
      END IF;

      -- определяем ключ доступа
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- определяем признак Создание/Корректировка
      vbIsInsert := COALESCE(ioId, 0) = 0;

      -- сохранили <Документ>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_StoreReal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert 
      THEN
           -- сохранили связь с <Пользователь>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), ioId, inUserId);
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
      END IF;

      -- сохранили связь с <Контрагент>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Partner(), ioId, inPartnerId);    

      -- сохраняем GUID, если задан
      IF inGUID IS NOT NULL
      THEN
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), ioId, inGUID);
      END IF;

      -- Комментарий
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol(ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *                                          
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inUserId:= 2, inPartnerId:= 17819, inGUID:= NULL, inComment:= 'Факт');
