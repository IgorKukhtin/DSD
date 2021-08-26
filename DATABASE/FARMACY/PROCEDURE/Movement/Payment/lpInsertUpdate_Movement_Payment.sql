-- Function: lpInsertUpdate_Movement_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, integer, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Payment(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inJuridicalId           Integer    , -- Юрлицо
    IN inisPaymentFormed       Boolean    , -- Платеж сформирован 
    IN inComment               TVarChar   , -- Комментарий
    IN inUserId                Integer      -- сессия пользователя
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
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Payment(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с юрлицом
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    
    -- сохранили <Платеж сформирован >
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PaymentFormed(), ioId, inisPaymentFormed);

    -- сохранили <Комментарий>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 29.10.15                                                                       *
*/