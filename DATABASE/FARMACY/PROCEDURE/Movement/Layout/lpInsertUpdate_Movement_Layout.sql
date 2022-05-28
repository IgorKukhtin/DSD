-- Function: lpInsertUpdate_Movement_Layout()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Layout (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Layout(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Выкладка>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inLayoutId            Integer   , -- Название выкладки
    IN inComment             TVarChar  , -- Примечание
    IN inisPharmacyItem      Boolean   , -- Для аптечных пунктов
    IN inisNotMoveRemainder6 Boolean   , -- Не перемещать остаток менее 6 мес.
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Layout());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Layout(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Выкладка>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Layout(), ioId, inLayoutId);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили <Для аптечных пунктов>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PharmacyItem(), ioId, inisPharmacyItem);

     -- сохранили <Не перемещать остаток менее 6 мес.>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotMoveRemainder6(), ioId, inisNotMoveRemainder6);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 27.08.20         *
*/

-- тест
--