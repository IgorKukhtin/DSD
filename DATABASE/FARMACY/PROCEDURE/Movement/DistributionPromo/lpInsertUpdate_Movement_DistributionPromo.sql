-- Function: lpInsertUpdate_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_DistributionPromo (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TFloat, TVarChar, TBlob, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_DistributionPromo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartPromo            TDateTime  , -- Дата начала действия
    IN inEndPromo              TDateTime  , -- Дата окончания действия
    IN inAmount                Integer    , -- Выдовать от количества товара
    IN inSummRepay             Tfloat     , -- Выдовать от суммы товара 
    IN inComment               TVarChar   , -- Примечание
    IN inMessage               TBlob      , -- Сообщение
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
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_DistributionPromo(), inInvNumber, inOperDate, NULL, 0);

    -- сохранили свойство <Сообщение>
    PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Message(), ioId, inMessage);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummRepay(), ioId, inSummRepay);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

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
 02.12.20                                                       *
*/