-- Function: gpComplete_Movement_Inventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_Inventory  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
BEGIN
  vbUserId:= inSession;
  
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
             WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
   THEN
     
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
         vbUnitKey := '0';
      END IF;
      vbUserUnitId := vbUnitKey::Integer;

      SELECT MLO_Unit.ObjectId
      INTO vbUnitId
      FROM  Movement
            INNER JOIN MovementLinkObject AS MLO_Unit
                                          ON MLO_Unit.MovementId = Movement.Id
                                         AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
      WHERE Movement.Id = inMovementId;

      IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
      THEN
         RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     
   END IF;     
  

  -- пересчитали Итоговые суммы
  -- PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);

  -- собственно проводки
  PERFORM lpComplete_Movement_Inventory(inMovementId, -- ключ Документа
                                        vbUserId);    -- Пользователь                          

  -- собственно проводки
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий О.В.
 17.12.18                                                                        *
 11.07.15                                                         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 29207, inSession:= '2')
