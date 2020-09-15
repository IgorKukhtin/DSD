 -- Function: lpInsertUpdate_MI_Over_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Over_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Over_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inUnitId              Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --  
    IN inUserId              Integer     -- пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
 
   -- проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не определено значение параметра <Подразделение>.';
   END IF;

   -- проверка
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определён главный элемент.';
   END IF;

   -- проверка
   IF COALESCE (inMovementId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Редактирование строк которые не попали в распределение запрещено.';
   END IF;

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId           := ioId
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := inUnitId
                                      , inMovementId   := inMovementId
                                      , inAmount       := inAmount
                                      , inParentId     := inParentId
                                      , inUserId       := inUserId
                                       );
  
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Price(), ioId, inPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_MCS(), ioId, inMCS);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Remains(), ioId, inRemains);

  
   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSummOver (inMovementId);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.16         *
 
*/

-- тест
-- 