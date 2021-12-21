-- Function: gpUpdate_Movement_Pretension_ClearSentDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_ClearSentDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_ClearSentDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Перемещение>
   OUT outSentDate         TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Pretension_Meneger());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM MovementDate AS MovementDate_Branch
                  WHERE MovementDate_Branch.MovementId = inMovementId
                    AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                    AND MovementDate_Branch.ValueData IS NOT NULL)
    THEN
      RETURN;
    END IF;

    -- параметры документа
    SELECT
        Movement.StatusId
    INTO
        vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    -- свойство меняем у не проведенных документов
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
       RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
    END IF;
    
    outSentDate := Null;
       
    --Сохранили Корректировка нашей даты
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, Null);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/