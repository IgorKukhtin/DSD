-- Function: gpUpdate_Movement_Received()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Received(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Received(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisReceived          Boolean   ,    -- Получено-да
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbUnitKey    TVarChar;
   DECLARE vbStatusId   Integer;
   DECLARE vbUnitIdTo   Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN      Boolean;
   DECLARE vbisDefSUN   Boolean;
   DECLARE vbisReceived Boolean;
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

   SELECT Movement.StatusId, MovementLinkObject_To.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
   INTO vbStatusId, vbUnitIdTo, vbisDeferred, vbisSUN, vbisDefSUN, vbisReceived
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

   WHERE Movement.Id = inMovementId;

   IF COALESCE(inisReceived, NOT vbisReceived) <> vbisReceived
   THEN
      RAISE EXCEPTION 'Ошибка. Признак <Получено-да> бал изменен. Обновите данные и повторите изменение признака.';
   END IF;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbUnitIdTo <> vbUnitId AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение <Получено-да> разрешено только сотруднику аптеки получателя.';
   END IF;

   IF inisReceived = FALSE AND (vbisSUN <> TRUE OR vbisDeferred <> TRUE)
   THEN
      RAISE EXCEPTION 'Ошибка. Для установки <Получено-да> документ должен быть с признаками <Перемещение по СУН> и <Отложен>.';
   END IF;

   IF inisReceived = TRUE AND 
      NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Отмена признака <Получено-да> вам запрещена, обратитесь к системному администратору';
   END IF;

   -- сохранили признак
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Received(), inMovementId, NOT inisReceived);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 06.08.19                                                                      *
*/