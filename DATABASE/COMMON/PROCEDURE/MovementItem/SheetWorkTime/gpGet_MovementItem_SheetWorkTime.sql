-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_SheetWorkTime(
    IN inUnitId            Integer  , -- Подразделение
    IN inMemberId          Integer  , -- Физ. лицо
    IN inPositionId        Integer  , -- 
    IN inPositionLevelId   Integer  , -- 
    IN inPersonalGroupId   Integer  ,
    IN inStorageLineId     Integer  ,
    IN inOperDate          TDateTime, --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar, MemberId Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar, 
               PositionLevelId Integer, PositionLevelName TVarChar, 
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               StorageLineId Integer, StorageLineName TVarChar,  
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
            Object_Member.Id                 AS MemberId,
            Object_Member.ValueData          AS MemberName,
            Object_Position.Id               AS PositionId,
            Object_Position.ValueData        AS PositionName,
            Object_PositionLevel.Id          AS PositionLevelId,
            Object_PositionLevel.ValueData   AS PositionLevelName,
            Object_PersonalGroup.Id          AS PersonalGroupId,
            Object_PersonalGroup.ValueData   AS PersonalGroupName,
            Object_StorageLine.Id            AS StorageLineId,
            Object_StorageLine.ValueData     AS StorageLineName,
            OperDate.OperDate
        FROM (SELECT inOperDate AS OperDate) AS OperDate
            LEFT OUTER JOIN Object AS Object_Member        ON Object_Member.Id        = inMemberId
            LEFT OUTER JOIN Object AS Object_Position      ON Object_Position.Id      = inPositionId
            LEFT OUTER JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = inPositionLevelId
            LEFT OUTER JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = inPersonalGroupId
            LEFT OUTER JOIN Object AS Object_StorageLine   ON Object_StorageLine.Id   = inStorageLineId
            LEFT OUTER JOIN Object AS Object_Unit          ON Object_Unit.Id          = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.17         * add StorageLine
 10.01.14                         *
*/


-- тест
-- select * from gpGet_MovementItem_SheetWorkTime(inunitid := 8464 , inmemberid := 8468 , inpositionid := 8466 , inpositionlevelid := 0 , inPersonalGroupId := 0 , inStorageLineId := 0 , inoperdate := ('01.03.2017')::TDateTime ,  inSession := '5');