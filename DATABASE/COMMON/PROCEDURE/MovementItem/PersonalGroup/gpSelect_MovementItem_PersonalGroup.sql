-- Function: gpSelect_MovementItem_PersonalGroup (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalGroup (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalGroup(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, MemberId Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , WorkTimeKindId Integer, WorkTimeKindName TVarChar
             , UnitName_inf TVarChar, PositionName_inf TVarChar
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalRate());
     vbUserId:= lpGetUserBySession (inSession);

     --���� ���.���������
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)

          , tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.Amount
                           , MovementItem.ObjectId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                     )
            
       -- ���������
       SELECT MovementItem.Id
            , View_Personal.MemberId
            , View_Personal.PersonalId
            , View_Personal.PersonalCode
            , View_Personal.PersonalName

            , Object_Position.Id             AS PositionId
            , Object_Position.ValueData      AS PositionName
            , Object_PositionLevel.Id        AS PositionLevelId
            , Object_PositionLevel.ValueData AS PositionLevelName
            , Object_PersonalGroup.Id        AS PersonalGroupId
            , Object_PersonalGroup.ValueData AS PersonalGroupName
            
            , Object_WorkTimeKind.Id         AS WorkTimeKindId
            , Object_WorkTimeKind.ValueData  AS WorkTimeKindName

            , View_Personal.UnitName         AS UnitName_inf
            , View_Personal.PositionName     AS PositionName_inf

            , MovementItem.Amount :: TFloat  AS Amount

            , MovementItem.isErased

       FROM tmpMI AS MovementItem
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                             ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MILinkObject_PositionLevel.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                 ON ObjectLink_Personal_PersonalGroup.ObjectId = View_Personal.PersonalId
                                AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_WorkTimeKind
                                             ON MILinkObject_WorkTimeKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
            LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MILinkObject_WorkTimeKind.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_PersonalGroup (inMovementId:= 14521952, inIsErased:= TRUE, inSession:= '2')