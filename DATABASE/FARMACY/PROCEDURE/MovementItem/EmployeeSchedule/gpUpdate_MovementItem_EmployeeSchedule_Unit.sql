-- Function: gpUpdate_MovementItem_EmployeeSchedule_Unit()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_Unit (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_Unit(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Подразделени
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    SELECT 
      Movement.StatusId
    INTO
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение подразделения в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inId, inUnitId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 25.03.19                                                                                    *
*/
-- тест
-- select * from gpUpdate_MovementItem_EmployeeSchedule_Unit(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');