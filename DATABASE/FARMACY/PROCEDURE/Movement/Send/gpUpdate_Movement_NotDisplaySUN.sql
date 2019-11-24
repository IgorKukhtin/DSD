-- Function: gpUpdate_Movement_NotDisplaySUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_NotDisplaySUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_NotDisplaySUN(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisNotDisplaySUN     Boolean   ,    -- Не отображать для сбора СУН
   OUT outisNotDisplaySUN    Boolean   ,    -- Не отображать для сбора СУН
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbStatusId        Integer;
   DECLARE vbisDeferred      Boolean;
   DECLARE vbisSUN           Boolean;
   DECLARE vbisDefSUN        Boolean;
   DECLARE vbisSent          Boolean;
   DECLARE vbisNotDisplaySUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;
   vbUserId := lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение <Не отображать для сбора СУН> разрешено только администратору.';
   END IF;


   SELECT Movement.StatusId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  ::Boolean AS isDefSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean AS isSent
        , COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE)::Boolean AS isNotDisplaySUN
   INTO vbStatusId, vbisDeferred, vbisSUN, vbisDefSUN, vbisSent, vbisNotDisplaySUN
   FROM Movement

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

            LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                      ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                     AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()

   WHERE Movement.Id = inMovementId;

   IF COALESCE(inisNotDisplaySUN, NOT vbisNotDisplaySUN) <> inisNotDisplaySUN
   THEN
      RAISE EXCEPTION 'Ошибка. Признак <Не отображать для сбора СУН> бал изменен. Обновите данные и повторите изменение признака.';
   END IF;

   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Complete()
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   IF vbisSUN <> TRUE
   THEN
      RAISE EXCEPTION 'Ошибка. Для установки <Не отображать для сбора СУН> документ должен быть с признаками <Перемещение по СУН>.';
   END IF;

   IF vbisSent = TRUE AND inisNotDisplaySUN = FALSE
   THEN
      RAISE EXCEPTION 'Ошибка. Перемещение <Отправлено-да> установка признака <Не отображать для сбора СУН> запрещено.';
   END IF;

   -- сохранили признак
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotDisplaySUN(), inMovementId, NOT inisNotDisplaySUN);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

   outisNotDisplaySUN := not inisNotDisplaySUN;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 22.12.19                                                                      *
*/

-- select * from gpUpdate_Movement_NotDisplaySUN(inMovementId := 16597220 , inisNotDisplaySUN := 'False' ,  inSession := '3');