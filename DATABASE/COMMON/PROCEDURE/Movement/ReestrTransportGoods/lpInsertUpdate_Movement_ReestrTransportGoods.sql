-- Function: lpInsertUpdate_Movement_ReestrTransportGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReestrTransportGoods (Integer, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReestrTransportGoods(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= CASE WHEN 1 = 1
                               THEN lpGetAccessKey (ABS (inUserId), zc_Enum_Process_InsertUpdate_Movement_TransportGoods())
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReestrTransportGoods(), inInvNumber, inOperDate, NULL, vbAccessKeyId);


     IF inUserId > 0 AND vbIsInsert = True
     THEN
         -- сохранили свойство <когда сформирована виза "" (т.е. добавлен новый документ в реестр)>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <кто сформировал визу "" (т.е. добавлен новый документ в реестр)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     IF inUserId > 0 AND vbIsInsert = False
     THEN
         -- сохранили свойство <когда сформирована виза "Получено от клиента" (т.е. добавлен последний документ в реестр)>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <кто сформировал визу "Вывезено со склада" (т.е. добавлен последний документ в реестр)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, ABS (inUserId), vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.20         *
*/

-- тест
-- 