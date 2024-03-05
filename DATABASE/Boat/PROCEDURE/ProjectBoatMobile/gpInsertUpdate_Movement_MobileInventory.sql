-- Function: gpInsertUpdate_Movement_MobileInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MobileInventory (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MobileInventory(
    IN inisCreateNew          Boolean   , -- Создавать новую если нет
   OUT outMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     vbUnitId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = 1);
     
     if EXISTS(SELECT Movement.Id
               FROM Movement 
               
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                    
               WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
                 AND Movement.OperDate <= CURRENT_DATE + INTERVAL '10 DAY'
                 AND Movement.DescId = zc_Movement_Inventory()
                 AND Movement.StatusId = zc_Enum_Status_UnComplete())
     THEN
       SELECT Movement.Id
       INTO outMovementId
       FROM Movement 
               
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId
                    
       WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_Inventory()
         AND Movement.StatusId = zc_Enum_Status_UnComplete();     
     ELSE 
       outMovementId := 0;
     END IF;
     
     IF inisCreateNew = TRUE AND COALESCE(outMovementId, 0) = 0
     THEN
       -- Создали <Документ>
       outMovementId := lpInsertUpdate_Movement_Inventory (ioId                := 0
                                                         , inInvNumber         := CAST (NEXTVAL ('movement_Inventory_seq') AS TVarChar)
                                                         , inOperDate          := CURRENT_DATE
                                                         , inUnitId            := vbUnitId
                                                         , inComment           := CAST ('' AS TVarChar)
                                                         , inisList            := False
                                                         , inUserId            := vbUserId
                                                           );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.24                                                       *
 */

-- тест
-- SELECT * FROM  gpInsertUpdate_Movement_MobileInventory (False, zfCalc_UserAdmin());