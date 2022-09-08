-- Function: lpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TVarChar, Boolean, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartSale             TDateTime  , -- Дата начала погашения
    IN inEndSale               TDateTime  , -- Дата окончания погашения
    IN inMonthCount            Integer    , -- Количество месяцев погашения
    IN inComment               TVarChar   , -- Примечание
    IN inisElectron            Boolean    , -- для Сайта
    IN inSummRepay             Tfloat     , -- Погашать от суммы чека
    IN inAmountPresent         Tfloat     , -- Количество подарка в чек
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartSale := DATE_TRUNC ('DAY', inStartSale);
    inEndSale   := DATE_TRUNC ('DAY', inEndSale);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SalePromoGoods(), inInvNumber, inOperDate, NULL, 0);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MonthCount(), ioId, inMonthCount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummRepay(), ioId, inSummRepay);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPresent(), ioId, inAmountPresent);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inisElectron);

    IF vbIsInsert = True
    THEN
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    ELSE
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/