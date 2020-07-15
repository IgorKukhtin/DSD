-- Function: lpInsertUpdate_MI_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ComputerAccessoriesRegister(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inComputerAccessoriesId Integer   , -- Компьютерный аксессуар
    IN inAmount                TFloat    , -- Количество
    IN inReplacementDate       TDateTime , -- Дата замены 
    IN inComment               TVarChar  , -- Комментарий
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

          
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inComputerAccessoriesId, inMovementId, inAmount, NULL);
 
     -- Сохранили <Себестоимость>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ReplacementDate(), ioId, inReplacementDate);

     -- Сохранили <Комментарий>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 14.07.20                                                                      * 
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ComputerAccessoriesRegister (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
