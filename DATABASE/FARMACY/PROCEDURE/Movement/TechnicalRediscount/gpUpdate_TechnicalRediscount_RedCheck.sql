-- Function: gpUpdate_TechnicalRediscount_RedCheck()

DROP FUNCTION IF EXISTS gpUpdate_TechnicalRediscount_RedCheck(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_TechnicalRediscount_RedCheck(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioisRedCheck          Boolean   ,   
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

     -- Разрешаем только сотрудникам с правами админа
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND vbUserId <> 11263040
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;

    SELECT 
      StatusId
    INTO
      vbStatusId
    FROM Movement 
    WHERE Id = inMovementId;
            
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение технического переучета в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    ioisRedCheck := NOT ioisRedCheck;
    
      -- сохранили <Красный чек>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RedCheck(), inMovementId, ioisRedCheck);

    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.01.21                                                        *
*/

-- тест
-- select * from gpUpdate_TechnicalRediscount_RedCheck(inMovementId := 21444137 , ioisRedCheck := 'True' ,  inSession := '3');