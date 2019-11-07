-- Function: lpInsertUpdate_Movement_Loyalty()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loyalty (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Tfloat, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loyalty(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inStartSale             TDateTime  , -- Дата начала погашения
    IN inEndSale               TDateTime  , -- Дата окончания погашения
    IN inStartSummCash         Tfloat     , -- Вылавать от суммы чека
    IN inMonthCount            Integer    , -- Количество месяцев погашения
    IN inDayCount              Integer    , -- Промокодов в день для аптеки
    IN inSummLimit             Tfloat     , -- Лимит суммы скидки в день для аптеки
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo:= DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo  := DATE_TRUNC ('DAY', inEndPromo);
    inStartSale := DATE_TRUNC ('DAY', inStartSale);
    inEndSale   := DATE_TRUNC ('DAY', inEndSale);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Loyalty(), inInvNumber, inOperDate, NULL, 0);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartSummCash(), ioId, inStartSummCash);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MonthCount(), ioId, inMonthCount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Limit(), ioId, inSummLimit);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Шаблий О.В.
 05.11.19                                                                  *
*/