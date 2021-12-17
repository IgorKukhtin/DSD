-- Function: gpUpdate_Movement_Pretension_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_BranchDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_BranchDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Перемещение>
    IN inBranchDate          TDateTime , -- Дата документа
   OUT outBranchDate         TDateTime , -- Дата документа
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
    
    outBranchDate := inBranchDate;
    
    --Сохранили Корректировка нашей даты
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
    
    -- сохранили связь с <Кто установил>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), inMovementId, vbUserId);

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