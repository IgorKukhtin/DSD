
    -- Function: gpInsert_MovementUnit_SendOverdue()

DROP FUNCTION IF EXISTS gpInsert_MovementUnit_SendOverdue (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementUnit_SendOverdue(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  PERFORM lpInsert_MovementUnit_SendOverdue (inUnitID         := Object_Unit.Id
                                           , inUnitOverdueID  := ObjectLink_Unit_UnitOverdue.ChildObjectId 
                                           , inSession        := inSession)
  FROM Object AS Object_Unit

       INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                               ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                              AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                              AND ObjectBoolean_DividePartionDate.ValueData = True

       INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                             ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()

  WHERE Object_Unit.DescId = zc_Object_Unit()
    AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsert_MovementUnit_SendOverdue (inSession:= '3')       