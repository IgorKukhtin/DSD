-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- подразделение
    IN inFullInvent          Boolean   , -- Полная инвентаризация
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserUnitId Integer;
   DECLARE vbOldUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     
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
        
        IF COALESCE (ioId, 0) <> 0
        THEN

          SELECT 
            MLO_Unit.ObjectId 
          INTO
            vbOldUnitId
          FROM Movement
               INNER JOIN MovementLinkObject AS MLO_Unit
                                             ON MLO_Unit.MovementId = Movement.Id
                                            AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
          WHERE Movement.Id = ioId;

          IF COALESCE (vbOldUnitId, 0) <> COALESCE (inUnitId, 0)
          THEN
            RAISE EXCEPTION 'Ошибка. Изменение подразделения запрещено..';                       
          END IF;
        ELSE
          RAISE EXCEPTION 'Ошибка. Создавать инвентаризации вам запрещено..';                       
        END IF;
        
        IF COALESCE (inUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION 'Ошибка. Не заполнено подразделение..';             
        END IF;     

        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        
     END IF;     

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inUnitId           := inUnitId
                                              , inFullInvent       := inFullInvent
                                              , inComment          := inComment
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 19.12.19                                                                         * + Comment
 17.12.18                                                                         *
 16.09.15                                                          * + FullInvent
 11.07.15                                                          *
*/