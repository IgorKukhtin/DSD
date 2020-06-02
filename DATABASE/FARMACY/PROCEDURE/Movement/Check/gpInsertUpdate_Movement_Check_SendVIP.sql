-- Function: gpInsertUpdate_Movement_Check_SendVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_SendVIP (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_SendVIP(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inManagerId         Integer   , -- Менеджер
    IN inBayer             TVarChar  , -- Покупатель ВИП
    IN inBayerPhone        TVarChar  , -- Контактный телефон (Покупателя)
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbDate TDateTime;

   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbManagerId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- определяем признак Создание/Корректировка
    ioId := 0;
    vbDate := CURRENT_TIMESTAMP::TDateTime;
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    SELECT
        COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
    INTO
        vbInvNumber
    FROM
        Movement_Check_View
    WHERE
        Movement_Check_View.UnitId = inUnitId
        AND
        Movement_Check_View.OperDate > CURRENT_DATE;

    IF COALESCE(inManagerId, 0) = 0 OR
       COALESCE(inBayer,'') = '' OR
       COALESCE(inBayerPhone,'') = ''
    THEN
        RAISE EXCEPTION 'Ошибка. Не заполнены: Подразделение <%> или Менеджер <%> или Покупатель <%> или Контактный телефон <%>', inUnitId, inManagerId, inBayer, inBayerPhone;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, vbDate, NULL);

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());
    -- сохранили менеджера
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
    -- сохранили ФИО покупателя
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Bayer(), ioId, inBayer);
    -- сохранили Контактный телефон (Покупателя)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), ioId, inBayerPhone);
    -- Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.05.20                                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Check_SendVIP (ioId := 0, inUnitId := 183292, inBayer := 'Test Bayer'::TVarChar, inBayerPhone:= '11-22-33', inSession := '3'::TVarChar);