-- Function: gpUpdateMI_OrderFinance_SignSB()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderFinance_SignSB (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderFinance_SignSB(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ> 
    IN inisSign                Boolean   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_OrderFinance_SB());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;    

     --если нет чайлда - создаем 
     IF COALESCE (ioId, 0) = 0
     THEN
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId
                                        , zc_MI_Child()
                                        , Null
                                        , inMovementId
                                        , (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inParentId) ::TFloat  -- нет чайлда сохраняем сумму из мастера
                                        , inParentId);
     END IF;
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Sign(), ioId, inisSign);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.26         *
*/

-- тест
--