-- Function: gpSelect_Object_Process()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (Integer, Integer);

-- Проверка закрытия периода

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inUserId      Integer      , -- сессия пользователя
    IN inMovementId  Integer      )
RETURNS VOID
AS
$BODY$  
DECLARE
  vbUnitFrom Integer;
  vbUnitTo   Integer;
  vbOperDate TDateTime;
BEGIN

  -- для Админа  - Все Права
  IF EXISTS (SELECT 1
             FROM ObjectLink_UserRole_View
            WHERE ObjectLink_UserRole_View.UserId = inUserId
              AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())

  THEN
     RETURN;
  END IF;

  SELECT OperDate, Movement_UnitTo.ObjectId, Movement_UnitFrom.objectid INTO vbOperDate, vbUnitTo, vbUnitFrom
    FROM Movement 
                 JOIN MovementLinkObject AS Movement_UnitTo ON Movement_UnitTo.movementid = Movement.Id
                  AND Movement_UnitTo.DescId = zc_MovementLinkObject_To()   
                 JOIN MovementLinkObject AS Movement_UnitFrom ON Movement_UnitFrom.movementid = Movement.Id
                  AND Movement_UnitFrom.DescId = zc_MovementLinkObject_From()   
   WHERE Id = inMovementId;


  IF NOT EXISTS (SELECT 1
     FROM PeriodClose
     JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.RoleId = PeriodClose.RoleId
      AND (PeriodClose.UnitId = vbUnitFrom OR PeriodClose.UnitId = vbUnitTo)
      AND ObjectLink_UserRole_View.UserId = inUserId
      AND CloseDate <= vbOperDate)
  THEN
     RAISE EXCEPTION 'Период закрыт';
  END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (Integer, Integer)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Process('2')

