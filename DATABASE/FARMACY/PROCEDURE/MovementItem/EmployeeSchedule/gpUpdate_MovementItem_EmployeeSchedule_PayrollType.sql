-- Function: gpUpdate_MovementItem_EmployeeSchedule_PayrollType()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_PayrollType(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_PayrollType(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа чилдрен>
    IN inDay                 Integer   , -- День
    IN inPayrollTypeID       Integer   , -- Тип дня
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceExit Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    IF COALESCE (inId, 0) = 0 
    THEN
        RAISE EXCEPTION 'Ошибка. График не сохранен.';
    END IF;
    
    IF inPayrollTypeID < 0
    THEN
      vbServiceExit := True;
      inPayrollTypeID := 0;
    ELSE
      vbServiceExit := False;    
    END IF;
    
    -- сохранили
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PayrollType(), inId, inPayrollTypeID);    
     -- сохранили свойство <Служебный выход>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ServiceExit(), inId, vbServiceExit);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
24.09.19                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_EmployeeSchedule_PayrollType (, inSession:= '2')

