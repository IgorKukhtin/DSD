-- Function: gpSelect_MI_PersonalService_Child_detail()

DROP FUNCTION IF EXISTS gpSelect_MI_PersonalService_Child_detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PersonalService_Child_detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, MemberId Integer, MemberName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , StaffListId Integer, StaffListCode Integer, StaffListName TVarChar
             , ModelServiceId Integer, ModelServiceName TVarChar
             , StaffListSummKindId Integer, StaffListSummKindName TVarChar
             , StorageLineId Integer, StorageLineName TVarChar

             , Amount TFloat, MemberCount TFloat, DayCount TFloat, WorkTimeHoursOne TFloat, WorkTimeHours TFloat, Price TFloat
             , HoursPlan TFloat, HoursDay TFloat, PersonalCount TFloat, GrossOne TFloat
             , isErased Boolean
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmpMI_Child AS (SELECT *
                            FROM gpSelect_MI_PersonalService_Child(inMovementId, inIsErased, inSession) AS tmp   
                            )
          , tmpMI_Master AS (SELECT tmp.ParentId
                                  , Object_Unit.Id            AS UnitId
                                  , Object_Unit.ObjectCode    AS UnitCode
                                  , Object_Unit.ValueData     AS UnitName
                                  , Object_Position.Id        AS PositionId
                                  , Object_Position.ValueData AS PositionName
                             FROM (SELECT DISTINCT tmpMI_Child.ParentId FROM tmpMI_Child) AS tmp
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                 ON MILinkObject_Unit.MovementItemId = tmp.ParentId
                                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                 ON MILinkObject_Position.MovementItemId = tmp.ParentId
                                                                AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId
                             )
       -- Результат
       SELECT tmpMI.Id
            , tmpMI.ParentId

            , tmpMI.MemberId
            , tmpMI.MemberName

            , tmpMI.PositionLevelId
            , tmpMI.PositionLevelName

            , tmpMI.StaffListId
            , tmpMI.StaffListCode
            , tmpMI.StaffListName

            , tmpMI.ModelServiceId
            , tmpMI.ModelServiceName

            , tmpMI.StaffListSummKindId
            , tmpMI.StaffListSummKindName
            , tmpMI.StorageLineId
            , tmpMI.StorageLineName
            , tmpMI.Amount
            , tmpMI.MemberCount
            , tmpMI.DayCount
            , tmpMI.WorkTimeHoursOne
            , tmpMI.WorkTimeHours
            , tmpMI.Price
            , tmpMI.HoursPlan
            , tmpMI.HoursDay
            , tmpMI.PersonalCount
            , tmpMI.GrossOne
            , tmpMI.isErased
            --
            , tmpMI_Master.UnitId
            , tmpMI_Master.UnitCode
            , tmpMI_Master.UnitName
            , tmpMI_Master.PositionId
            , tmpMI_Master.PositionName
       FROM tmpMI_Child AS tmpMI
            LEFT JOIN tmpMI_Master ON tmpMI_Master.ParentId = tmpMI.ParentId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PersonalService_Child_detail (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
