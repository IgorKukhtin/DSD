-- Function: gpDelete_MovementItem_EmployeeScheduleVIP_User()

DROP FUNCTION IF EXISTS gpDelete_MovementItem_EmployeeScheduleVIP_User(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MovementItem_EmployeeScheduleVIP_User(
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
    THEN
      RAISE EXCEPTION 'Удаление вам запрещено, обратитесь к системному администратору.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Не сохранен график работы сотрудников.';
    END IF;
    
    IF COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION 'Не сохранена строка в графике работы сотрудников.';
    END IF;

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;    
    
    IF EXISTS(SELECT 1 FROM MovementItem
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.ParentId = inId
                               AND MovementItem.DescId = zc_MI_Child()) 
    THEN
        RAISE EXCEPTION 'Ошибка.Сначало удалите отметки сотрудника по дням.';
    END IF;    

    -- Удалили
    PERFORM lpDelete_MovementItem(inId, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
16.09.21                                                        *

*/

select * from gpDelete_MovementItem_EmployeeScheduleVIP_User(inMovementID := 24861838 , inId := 457009614 ,  inSession := '3');