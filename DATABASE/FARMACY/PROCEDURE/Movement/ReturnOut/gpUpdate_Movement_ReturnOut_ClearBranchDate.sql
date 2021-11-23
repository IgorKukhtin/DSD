-- Function: gpUpdate_Movement_ReturnOut_ClearBranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_ClearBranchDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnOut_ClearBranchDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Перемещение>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnOut_BranchDate());
    
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
       
    --Сохранили Корректировка нашей даты
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, Null);
    
    -- сохранили связь с <Кто установил>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), inMovementId, Null);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.11.21                                                       * 
*/
