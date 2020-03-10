-- Function: lpInsertUpdate_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TechnicalRediscount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inComment             TVarChar  , -- Примечание
    IN inisRedCheck          Boolean  ,  -- Красный чек
    IN inisAdjustment        Boolean  ,  -- Корректировка основного переучета
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TechnicalRediscount(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Подразделение в документе>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили <Красный чек>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RedCheck(), ioId, inisRedCheck);
     -- сохранили <Корректировка основного переучета>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Adjustment(), ioId, inisAdjustment);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
 */
