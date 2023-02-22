-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount(
    IN inOperDate            TDateTime , -- Дата в месяце
    IN inUnitId              Integer   , -- Аптека
    IN inUserCount           Integer   , -- Количество сотрудников
    IN inSession             TVarChar   -- пользователь
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbMovementId Integer;
   DECLARE vbId         Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Не заполнено подразделение.';
    END IF;

    -- Ищем свободные zc_MI_Child() 
    SELECT Movement.Id                       AS UnitId
         , COALESCE(MovementItemUser.Id, 0)  AS Id
    INTO vbMovementId, vbId
    FROM Movement

         LEFT JOIN MovementItem AS MovementItemUser
                                ON MovementItemUser.MovementId = Movement.Id
                               AND MovementItemUser.ObjectId  = inUnitId
                               AND MovementItemUser.DescId = zc_MI_Second()

    WHERE Movement.OperDate = date_trunc('MONTH', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule()
      AND Movement.StatusId <> zc_Enum_Status_Erased();

    IF COALESCE (vbMovementId, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Не найден график работы сотрудников за <%>.', date_trunc('MONTH', inOperDate);
    END IF;
          
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

     -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Second(), inUnitId, vbMovementId, inUserCount, NULL);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.02.23                                                        *
*/

-- тест
-- 