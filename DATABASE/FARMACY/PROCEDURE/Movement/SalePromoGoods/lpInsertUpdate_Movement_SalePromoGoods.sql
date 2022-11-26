-- Function: lpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TVarChar, Boolean, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartPromo            TDateTime  , -- Дата начала погашения
    IN inEndPromo              TDateTime  , -- Дата окончания погашения
    IN inComment               TVarChar   , -- Примечание
    IN inisAmountCheck         Boolean    , -- Акция от суммы чека
    IN inAmountCheck           TFloat     , -- От суммы чека
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate   := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo := DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo   := DATE_TRUNC ('DAY', inEndPromo);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SalePromoGoods(), inInvNumber, inOperDate, NULL, 0);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили <Акция от суммы чека>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_AmountCheck(), ioId, inisAmountCheck);

    -- сохранили <От суммы чека>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCheck(), ioId, inAmountCheck);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

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