-- Function: lpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- Сотрудники
   OUT outAmount             TFloat    , -- Сумма к выплате
   OUT outAmountCash         TFloat    , -- Сумма к выплате из кассы
    IN inSummService         TFloat    , -- Сумма начислено
    IN inSummCard            TFloat    , -- Сумма на карточку (БН)
    IN inSummCardRecalc      TFloat    , -- Сумма на карточку (БН) для распределения
    IN inSummMinus           TFloat    , -- Сумма удержания
    IN inSummAdd             TFloat    , -- Сумма премия
    
    IN inSummSocialIn        TFloat    , -- Сумма соц выплаты (в зарплате)
    IN inSummSocialAdd       TFloat    , -- Сумма соц выплаты (к зарплате)
    IN inSummChild           TFloat    , -- Сумма алименты (удержание)
    
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- Статьи назначения
    IN inUnitId              Integer   , -- Подразделение
    IN inPositionId          Integer   , -- Должность
    IN inMemberId            Integer   , -- юр.лицо
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- рассчитываем сумму к выплате
     outAmount:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) + COALESCE (inSummAdd, 0);
     -- рассчитываем сумму к выплате из кассы
     outAmountCash:= outAmount - COALESCE (inSummCard, 0);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, outAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummService(), ioId, inSummService);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), ioId, inSummCard);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardRecalc(), ioId, inSummCardRecalc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinus(), ioId, inSummMinus);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd (), ioId, inSummAdd );
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialIn(), ioId, inSummSocialIn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialAdd(), ioId, inSummSocialAdd);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChild(), ioId, inSummChild);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), ioId, inMemberId);

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
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
