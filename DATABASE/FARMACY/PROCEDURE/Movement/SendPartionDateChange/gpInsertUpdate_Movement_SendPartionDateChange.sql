-- Function: gpInsertUpdate_Movement_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendPartionDateChange (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendPartionDateChange(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , --
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendPartionDateChange());
     vbUserId := inSession;
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';     
        END IF;     
        
        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_SendPartionDateChange (ioId               := ioId
                                                          , inInvNumber        := inInvNumber
                                                          , inOperDate         := inOperDate
                                                          , inUnitId           := inUnitId
                                                          , inComment          := inComment
                                                          , inUserId           := vbUserId
                                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.07.20                                                       *
*/

-- тест
-- 
