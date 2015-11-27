-- Function: gpGet_Movement_Transport()

DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_SheetWorkTime(
    IN inUnitId            Integer  , -- �������������
    IN inMemberId          Integer  , -- ���. ����
    IN inPositionId        Integer  , -- 
    IN inPositionLevelId   Integer  , -- 
    IN inPersonalGroupId   Integer  ,
    IN inOperDate          TDateTime, --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar, MemberId Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar, 
               PositionLevelId Integer, PositionLevelName TVarChar, 
               PersonalGroupId Integer, PersonalGroupName TVarChar, 
               OperDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
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
            OperDate.OperDate
        FROM (SELECT inOperDate AS OperDate) AS OperDate
            LEFT OUTER JOIN Object AS Object_Member ON Object_Member.Id = inMemberId
            LEFT OUTER JOIN Object AS Object_Position ON Object_Position.Id = inPositionId
            LEFT OUTER JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = inPositionLevelId
            LEFT OUTER JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = inPersonalGroupId
            LEFT OUTER JOIN Object AS Object_Unit ON Object_Unit.Id = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.14                         *
*/


-- ����
-- SELECT * FROM gpGet_MovementItem_SheetWorkTime (inMovementId:= 0, inSession:= '2')
