-- Function: gpUpdate_Movement_Check_Doctors()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Doctors (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Doctors(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inisDoctors         Boolean   , -- 
   OUT outisDoctors        Boolean   , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Установка признака <Врачи.> вам запрещено.';
    END IF;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    outisDoctors := NOT inisDoctors;
    
    -- сохранили отметку <Просрочка>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Doctors(), inMovementId, outisDoctors);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.08.21                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_Doctors (inId:= 0, inSMS:= TRUE, inSession:= zfCalc_UserAdmin());
