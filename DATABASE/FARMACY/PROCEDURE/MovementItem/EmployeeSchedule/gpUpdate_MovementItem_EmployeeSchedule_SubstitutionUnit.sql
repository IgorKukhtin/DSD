-- Function: gpUpdate_MovementItem_EmployeeSchedule_SubstitutionUnit()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_SubstitutionUnit (Integer, Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_SubstitutionUnit(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Подразделени
    IN inTypeId            Integer   , -- День
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;
    
    IF COALESCE(inTypeId,0) = 0
    THEN
        RAISE EXCEPTION 'Не определено значение дня.';
    END IF;

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    SELECT 
      Movement.id,
      Movement.StatusId
    INTO
      vbMovementId,
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение подразделения в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- сохранили <Элемент документа>
    
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.MovementID = vbMovementId 
                AND MovementItem.Amount = inTypeId
                AND MovementItem.DescId = zc_MI_Child() 
                AND MovementItem.ParentId = inId)
    THEN
      SELECT MovementItem.Id
      INTO vbId
      FROM MovementItem
      WHERE MovementItem.MovementID = vbMovementId 
        AND MovementItem.Amount = inTypeId
        AND MovementItem.DescId = zc_MI_Child() 
        AND MovementItem.ParentId = inId;
    ELSE
      vbId := 0;
    END IF;
                
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Child(), inUnitId, vbMovementId, inTypeId, inId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 25.03.19                                                                                    *
*/
-- тест
-- select * from gpUpdate_MovementItem_EmployeeSchedule_SubstitutionUnit(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');
