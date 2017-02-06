-- Function: lpInsertUpdate_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_MobileBills (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_MobileBills(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMobileEmployeeId    Integer   , -- Номер телефона
    IN inAmount              TFloat    , -- Сумма итого
    IN inCurrMonthly         TFloat    , -- 
    IN inCurrNavigator       TFloat    , -- 
    IN inPrevNavigator       TFloat    , -- 
    IN inLimit               TFloat    , -- 
    IN inPrevLimit           TFloat    , -- 
    IN inDutyLimit           TFloat    , -- 
    IN inOverlimit           TFloat    , -- 
    IN inPrevMonthly         TFloat    , -- 
--    IN inRegionId            Integer   , --
    IN inEmployeeId          Integer   , --
    IN inPrevEmployeeId      Integer   , --
    IN inMobileTariffId      Integer   , --
    IN inPrevMobileTariffId  Integer   , --
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inMobileEmployeeId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrMonthly(), ioId, inCurrMonthly);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrNavigator(), ioId, inCurrNavigator);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevNavigator(), ioId, inPrevNavigator);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Limit(), ioId, inLimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevLimit(), ioId, inPrevLimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DutyLimit(), ioId, inDutyLimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Overlimit(), ioId, inOverlimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevMonthly(), ioId, inPrevMonthly);
    
     -- сохранили связь с <>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Region(), ioId, inRegionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Employee(), ioId, inEmployeeId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PrevEmployee(), ioId, inPrevEmployeeId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MobileTariff(), ioId, inMobileTariffId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PrevMobileTariff(), ioId, inPrevMobileTariffId);

     
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_MobileBills (ioId:= 0, inMovementId:= 10, inMobileEmployeeId:= 1, inAmount:= 0, inCurrMonthly:= 0, inPrevMobileTariff:= '', inRegionId:= 0, inSession:= '2')
