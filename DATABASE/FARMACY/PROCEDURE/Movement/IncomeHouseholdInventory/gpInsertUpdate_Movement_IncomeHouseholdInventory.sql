-- Function: gpInsertUpdate_Movement_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeHouseholdInventory (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeHouseholdInventory(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeHouseholdInventory());
    
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
        
        IF COALESCE (ioId, 0) = 0 AND
           EXISTS(SELECT Movement.id
                  FROM Movement 
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  WHERE Movement.DescId = zc_Movement_IncomeHouseholdInventory() 
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                    AND MovementLinkObject_Unit.ObjectId = inUnitId)
        THEN
          RAISE EXCEPTION 'Ошибка. По подразделению <%> уже создан документ прихода хоз. инвентаря.', (SELECT ValueData FROM Object WHERE ID = inUnitId);             
        END IF;
     END IF;     
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_IncomeHouseholdInventory (ioId               := ioId
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
 09.07.20                                                       *
*/

-- тест
-- 
