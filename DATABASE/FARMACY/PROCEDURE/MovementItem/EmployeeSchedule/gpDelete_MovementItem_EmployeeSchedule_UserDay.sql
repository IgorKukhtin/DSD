-- Function: gpDelete_MovementItem_EmployeeSchedule_UserDay()

DROP FUNCTION IF EXISTS gpDelete_MovementItem_EmployeeSchedule_UserDay(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MovementItem_EmployeeSchedule_UserDay(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inId                  Integer   , -- Что удалить
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF NOT EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
       AND vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Удаление вам запрещено, обратитесь к системному администратору.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Не сохранен график работы сотрудников.';
    END IF;
    
    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;    

    -- Удалили
    PERFORM lpDelete_MovementItem(inId, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
11.09.19                                                        *

*/