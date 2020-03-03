-- Function: gpInsertUpdate_Movement_TechnicalRediscount_SummaWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount_SummaWages(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount_SummaWages(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inSummWages           TFloat    , -- В зарплату
   OUT outSummWages          TFloat    , -- Итого
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    -- вытягиваем подразделение ...
    SELECT Movement.OperDate
         , MLO_Unit.ObjectId                   AS UnitId
    INTO vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inId;

     -- Разрешаем только сотрудникам с правами админа
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;

     -- сохранили свойство <В зарплату>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaManual(), inId, inSummWages);

    outSummWages := gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, inSession);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.20                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TechnicalRediscount_SummaWages (, inSession:= '2')