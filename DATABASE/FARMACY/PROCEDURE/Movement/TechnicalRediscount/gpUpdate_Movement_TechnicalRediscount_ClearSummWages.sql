-- Function: gpUpdate_Movement_TechnicalRediscount_ClearSummWages()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TechnicalRediscount_ClearSummWages(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TechnicalRediscount_ClearSummWages(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

     -- Разрешаем только сотрудникам с правами админа
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;

    -- вытягиваем подразделение ...
    SELECT Movement.OperDate
         , MLO_Unit.ObjectId                   AS UnitId
    INTO vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT * FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_SummaManual() AND MovementFloat.MovementId = inMovementId)
    THEN
      DELETE FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_SummaManual() AND MovementFloat.MovementId = inMovementId;
    ELSE
      RAISE EXCEPTION 'Сумма введенная вручную не найдена...';    
    END IF;

    PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, inSession);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.20                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_TechnicalRediscount_ClearSummWages (, inSession:= '2')