-- Function: lpInsertUpdate_Movement_PromoCode()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoCode (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Boolean, Boolean, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoCode(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inChangePercent         Tfloat     , --
    IN inIsElectron            Boolean    , 
    IN inIsOne                 Boolean    , 
    IN inPromoCodeId           Integer    , --
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo:= DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo  := DATE_TRUNC ('DAY', inEndPromo);

    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoCode(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <Производитель>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoCode(), ioId, inPromoCodeId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inIsElectron);
    
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_One(), ioId, inIsOne);
    
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 13.12.17         *
*/