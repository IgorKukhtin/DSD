-- Function: lpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Tfloat, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inAmount                Tfloat     , -- 
    IN inChangePercent         Tfloat     , --
    IN inMakerId               Integer    , -- Производитель
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <Производитель>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Maker(), ioId, inMakerId);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 24.04.16         *
*/