-- Function: gpUpdate_Movement_Sent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sent(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sent(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisSent          Boolean   ,    -- Получено-да
   OUT outisSent         Boolean   ,    -- Получено-да
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbUnitKey     TVarChar;
   DECLARE vbStatusId    Integer;
   DECLARE vbUnitIdFrom  Integer;
   DECLARE vbisDeferred  Boolean;
   DECLARE vbisSUN       Boolean;
   DECLARE vbisDefSUN    Boolean;
   DECLARE vbisSent      Boolean;
   DECLARE vbisReceived  Boolean;
   DECLARE vbNumberSeats Integer;
   DECLARE vbDriverSunID Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   SELECT Movement.StatusId, MovementLinkObject_From.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean     AS isSent
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
        , MovementFloat_NumberSeats.ValueData::Integer                  AS NumberSeats
        , MovementLinkObject_DriverSun.ObjectId                         AS DriverSunID
   INTO vbStatusId, vbUnitIdFrom, vbisDeferred, vbisSUN, vbisDefSUN, vbisSent, vbisReceived, vbNumberSeats, vbDriverSunID
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()

            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

            LEFT JOIN MovementFloat AS MovementFloat_NumberSeats
                                    ON MovementFloat_NumberSeats.MovementId =  Movement.Id
                                   AND MovementFloat_NumberSeats.DescId = zc_MovementFloat_NumberSeats()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DriverSun
                                         ON MovementLinkObject_DriverSun.MovementId = Movement.Id
                                        AND MovementLinkObject_DriverSun.DescId = zc_MovementLinkObject_DriverSun()
   WHERE Movement.Id = inMovementId;

   IF COALESCE(inisSent, NOT vbisSent) <> vbisSent
   THEN
      RAISE EXCEPTION 'Ошибка. Признак <Отправлено-да> бал изменен. Обновите данные и повторите изменение признака.';
   END IF;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbUnitIdFrom <> vbUnitId AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение <Отправлено-да> разрешено только сотруднику аптеки отправителя.';
   END IF;

   IF inisSent = FALSE AND (vbisSUN <> TRUE OR vbisDeferred <> TRUE)
   THEN
      RAISE EXCEPTION 'Ошибка. Для установки <Отправлено-да> документ должен быть с признаками <Перемещение по СУН> и <Отложен>.';
   END IF;

   IF vbisReceived = TRUE
   THEN
      RAISE EXCEPTION 'Ошибка. Перемещение <Получено-да> отмена признака <Отправлено-да> запрещено.';
   END IF;

   IF inisSent = TRUE AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Отмена признака <Отправлено-да> вам запрещена, обратитесь к системному администратору';
   END IF;

   IF inisSent = FALSE AND COALESCE (vbDriverSunID, 0) = 0 AND CURRENT_DATE >= '11.03.2020'::TDateTime
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнен <Водитель получивший товар>';
   END IF;

   IF inisSent = FALSE AND COALESCE (vbNumberSeats, 0) = 0 AND CURRENT_DATE >= '11.03.2020'::TDateTime
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено <Количество мест>';
   END IF;

   -- сохранили признак
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sent(), inMovementId, NOT inisSent);

   -- сохранили свойство <Дата изменения признака Отправлено>
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

   outisSent := not inisSent;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 12.10.19                                                                      *
 06.08.19                                                                      *
*/-- SELECT * FROM gpSelect_Movement_SendCash (inStartDate:= '01.07.2019', inEndDate:= '14.07.2019', inIsErased := FALSE, inisSUN := FALSE, inSession:= '3')