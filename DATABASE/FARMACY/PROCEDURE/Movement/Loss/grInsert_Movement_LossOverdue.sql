--- Function: grInsert_Movement_LossOverdue()

DROP FUNCTION IF EXISTS grInsert_Movement_LossOverdue (TVarChar);

CREATE OR REPLACE FUNCTION grInsert_Movement_LossOverdue(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

  PERFORM grInsert_Movement_LossOverdueUnit (inUnitID       := Object_Unit.Id,
                                             inSession      := inSession)
  FROM Object AS Object_Unit
       INNER JOIN ObjectBoolean AS ObjectBoolean_Unit_TechnicalRediscount
                                ON ObjectBoolean_Unit_TechnicalRediscount.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Unit_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
                               AND ObjectBoolean_Unit_TechnicalRediscount.ValueData = True
       INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                               ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                              AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                              AND ObjectBoolean_DividePartionDate.ValueData = True
  WHERE Object_Unit.DescId = zc_Object_Unit()
    AND Object_Unit.isErased = False;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.04.20                                                       *
*/

-- SELECT * FROM grInsert_Movement_LossOverdue (inSession := '3')