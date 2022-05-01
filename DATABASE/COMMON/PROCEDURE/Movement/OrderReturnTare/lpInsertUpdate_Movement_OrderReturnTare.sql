-- Function: lpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                    Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber             TVarChar  , -- Номер документа
    IN inOperDate              TDateTime , -- Дата документа
    IN inMovementId_Transport  Integer   , -- Путевой лист 
    IN inManagerId             Integer   , -- земеститель нач.отдела
    IN inSecurityId            Integer   , -- отдел безопасности
    IN inComment               TVarChar  , --
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderReturnTare(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с документом <Транспорт>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);
     -- сохранили связь с документом <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Manager(), ioId, inManagerId);
     -- сохранили связь с документом <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Security(), ioId, inSecurityId);


      -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId); 
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.01.22         *
*/

-- тест