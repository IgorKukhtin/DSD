-- Function: gpUpdate_Movement_Check_SetOffsetVIP()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SetOffsetVIP (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SetOffsetVIP(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inisOffsetVIP       Boolean   , -- Зачет ВИПам
    IN inDateOffsetVIP     TDateTime , -- Дата зачет ВИПам
   OUT outisOffsetVIP      Boolean   , -- 
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

    outisOffsetVIP := NOT inisOffsetVIP;
    
    -- сохранили отметку <Зачет ВИПам>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_OffsetVIP(), inMovementId, outisOffsetVIP);

    -- сохранили отметку <Дата зачет ВИПам>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OffsetVIP(), inMovementId, inDateOffsetVIP);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.10.21                                                       *
*/

-- тест
-- select * from gpUpdate_Movement_Check_SetOffsetVIP(inMovementId := 32589738 , inisOffsetVIP := 'False' , inDateOffsetVIP := ('02.07.2023')::TDateTime ,  inSession := '3');

