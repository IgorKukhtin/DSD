-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_MovementItem_SheetWorkTime(
    IN inUnitId            Integer  , -- Подразделение
    IN inPersonalId          Integer  , -- Физ. лицо
    IN inPositionId        Integer  , -- 
    IN inPersonalGroupId   Integer  ,
    IN inOperDate          TDateTime, --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar, PersonalId Integer, PersonalName TVarChar,
               PositionId Integer, PositionName TVarChar, 
               PersonalGroupId Integer, PersonalGroupName TVarChar, 
               OperDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Transport());
    vbUserId:= lpGetUserBySession (inSession);

    
    RETURN QUERY 
        SELECT
            Object_Unit.Id                   AS UnitId,
            Object_Unit.ValueData            AS UnitName,
            Object_Personal.Id               AS PersonalId,
            Object_Personal.ValueData        AS PersonalName,
            Object_Position.Id               AS PositionId,
            Object_Position.ValueData        AS PositionName,
            Object_PersonalGroup.Id          AS PersonalGroupId,
            Object_PersonalGroup.ValueData   AS PersonalGroupName,
            OperDate.OperDate
        FROM (SELECT inOperDate AS OperDate) AS OperDate
            LEFT OUTER JOIN Object AS Object_Personal ON Object_Personal.Id = inPersonalId
            LEFT OUTER JOIN Object AS Object_Position ON Object_Position.Id = inPositionId
            LEFT OUTER JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = inPersonalGroupId
            LEFT OUTER JOIN Object AS Object_Unit ON Object_Unit.Id = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.16         * rename member -> Personal
 10.01.14                         *
*/


-- тест
-- SELECT * FROM gpGet_MovementItem_SheetWorkTime (inMovementId:= 0, inSession:= '2')
