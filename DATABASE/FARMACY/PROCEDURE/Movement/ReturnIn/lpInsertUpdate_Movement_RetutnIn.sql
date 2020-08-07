-- Function: lpInsertUpdate_Movement_RetutnIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_RetutnIn (Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_RetutnIn(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ>
    IN inParentId              Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inCashRegisterId        Integer    , -- 
    IN inFiscalCheckNumber     TVarChar   , -- 
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId Integer;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnIn(), inInvNumber, inOperDate, Null, 0);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, COALESCE(inParentId, 0));

    -- сохранили связь с <От кого (подразделение)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), ioId, inCashRegisterId);
 
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_FiscalCheckNumber(), ioId, inFiscalCheckNumber);

    -- !!!протокол через свойства конкретного объекта!!!
    IF vbIsInsert = TRUE
       THEN
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    END IF;
     
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.19         *
*/
--