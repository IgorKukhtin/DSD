-- Function: gpInsertUpdate_Movement_Check_Site_Liki24()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site_Tabletki (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_Site_Tabletki(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inDate              TDateTime , -- Дата/время документа
    IN inBookingId         TVarChar  , -- ID заказа на сайте
    IN inBayer             TVarChar  , -- Покупатель ВИП
    IN inBayerPhone        TVarChar  , -- Контактный телефон (Покупателя)
    IN inCode              Integer   , -- Код заказа
    IN inBookingStatus     TVarChar  , -- Статус заказа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;

    IF COALESCE(inBookingId, '') = ''
    THEN
        RAISE EXCEPTION 'Оштбка. Не заполнено ID звказа';
    END IF;


    IF COALESCE(ioId,0) = 0 AND
       EXISTS(SELECT MovementString.MovementId FROM MovementString
              WHERE MovementString.DescId = zc_MovementString_BookingId()
                AND MovementString.ValueData = inBookingId)
    THEN
      SELECT MovementString.MovementId
      INTO ioId
      FROM MovementString
      WHERE MovementString.DescId = zc_MovementString_BookingId()
        AND MovementString.ValueData = inBookingId;
    END IF;

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF COALESCE(ioId,0) = 0
    THEN
        SELECT COALESCE(MAX(zfConvert_StringToNumber(Movement.InvNumber)), 0) + 1
        INTO vbInvNumber
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE Movement.DescId = zc_Movement_Check()
          AND Movement.OperDate >= DATE_TRUNC ('DAY', inDate)
          AND Movement.OperDate < DATE_TRUNC ('DAY', inDate) + INTERVAL '1 DAY'
          AND MovementLinkObject_Unit.ObjectId = inUnitId;
    ELSE
        SELECT Movement.InvNumber
        INTO vbInvNumber
        FROM Movement
        WHERE Movement.Id = ioId;
    END IF;


    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, inDate, NULL);



    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <Источник чека>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CheckSourceKind(), ioId, zc_Enum_CheckSourceKind_Tabletki());
    -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());

    -- сохранили ID заказа на сайте
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingId(), ioId, inBookingId);
    -- сохранили ID заказа в системе источника
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_OrderId(), ioId, inCode::TVarChar);
    -- сохранили Статус заказа
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), ioId, inBookingStatus);
    -- сохранили ФИО покупателя
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Bayer(), ioId, inBayer);
    -- сохранили Контактный телефон (Покупателя)
    --PERFORM lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), ioId, inBayerPhone);
    -- Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);
    -- сохранили менеджера
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, 682919);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', vbInvNumber, inSession;
    END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.08.20                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Check_Site_Tabletki (ioId := 0, inUnitId := 183292, inDate := NULL::TDateTime, inBookingId := 'ea611433-bfc6-435b-80cf-16b457607dc3'::TVarChar, inOrderId:= 'bfb4b3dd-affe-11ea-a9f3-00163e3c1eb4', inSession := '3'::TVarChar); -