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
  DECLARE vbParentId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
  DECLARE vbStatusId Integer;
BEGIN
   vbUserId:= inSession;
  
   SELECT MLO_Unit.ObjectId, Movement.ParentId, Movement.StatusId
   INTO vbUnitId, vbParentId, vbStatusId
   FROM  Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
   WHERE Movement.Id = inMovementId;

   -- Если Проведен, то сразу ругнемся.
   IF vbStatusId = zc_Enum_Status_Complete()
   THEN
       RAISE EXCEPTION 'Документ уже Проведен.';
   END IF;

   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
             WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
      AND vbUserId <> 8037524
   THEN
     
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
         vbUnitKey := '0';
      END IF;
      vbUserUnitId := vbUnitKey::Integer;

      IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
      THEN
         RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;  
   
      IF (COALESCE ((SELECT COUNT(*) FROM MovementItem WHERE MovementItem.MovementId = inMovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased  = FALSE), 0) > 3 OR 
          COALESCE ((SELECT COUNT(*) FROM Movement 

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Inventory()
                                AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                AND Movement.StatusId = zc_Enum_Status_Complete()), 0) >= 1) AND
        EXISTS(SELECT 1
                FROM Movement

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                     INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                   ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                  AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
                  AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                  AND Movement.DescId = zc_Movement_Check()
                  AND MovementLinkObject_Unit.ObjectId = vbUnitId
                  AND Movement.StatusId = zc_Enum_Status_Complete()) AND
         (SELECT MAX(Movement.OperDate)
          FROM Movement

               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

               INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                             ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                            AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

          WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
            AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
            AND Movement.DescId = zc_Movement_Check()
            AND MovementLinkObject_Unit.ObjectId = vbUnitId
            AND Movement.StatusId = zc_Enum_Status_Complete()) > 
          COALESCE ((SELECT MAX(EmployeeWorkLog.DateZReport)
                     FROM EmployeeWorkLog
                     WHERE EmployeeWorkLog.DateLogIn >= DATE_TRUNC ('DAY', CURRENT_DATE)
                       AND EmployeeWorkLog.DateLogIn < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                       AND EmployeeWorkLog.UnitId = vbUnitId
                       AND EmployeeWorkLog.DateZReport IS NOT NULL),DATE_TRUNC ('DAY', CURRENT_DATE)) 
      THEN 
        RAISE EXCEPTION 'Ошибка. Смена не закрыта выполнение операций с инвентаризацией запрещено.';     
      END IF;             
   END IF;     

   IF COALESCE (vbParentId, 0) <> 0
   THEN
       IF NOT EXISTS(SELECT 1 FROM Movement WHERE Movement.ID = vbParentId AND StatusId = zc_Enum_Status_Complete())
       THEN
         RAISE EXCEPTION 'Ошибка. Документы сформированные по техническому переучету проводяться вместе с ним.';           
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
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 30776064 , inSession:= '2')