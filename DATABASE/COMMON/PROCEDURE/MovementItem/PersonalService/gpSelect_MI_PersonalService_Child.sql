-- Function: gpSelect_MI_PersonalService_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_PersonalService_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PersonalService_Child(
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
             , Koeff TFloat
             , Rate TFloat
             , isErased Boolean
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
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.ParentId                    AS ParentId
                           , MovementItem.ObjectId                    AS MemberId
                           , MovementItem.Amount

                           , MILinkObject_PositionLevel.ObjectId      AS PositionLevelId
                           , MILinkObject_StaffList.ObjectId          AS StaffListId
                           , MILinkObject_ModelService.ObjectId       AS ModelServiceId
                           , MILinkObject_StaffListSummKind.ObjectId  AS StaffListSummKindId
                           , MILinkObject_StorageLine.ObjectId        AS StorageLineId

                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                            ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                                           ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                                            ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                                            ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                       )

          , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                       AND MovementItemFloat.DescId IN (zc_MIFloat_MemberCount()  
                                                                      , zc_MIFloat_DayCount()
                                                                      , zc_MIFloat_WorkTimeHoursOne()
                                                                      , zc_MIFloat_WorkTimeHours()
                                                                      , zc_MIFloat_Price()
                                                                      , zc_MIFloat_HoursPlan()
                                                                      , zc_MIFloat_HoursDay()
                                                                      , zc_MIFloat_PersonalCount()
                                                                      , zc_MIFloat_GrossOne()
                                                                      , zc_MIFloat_Koeff()                       
                                                                      )
                                     )


       -- Результат
       SELECT tmpMI.MovementItemId                     AS Id
            , tmpMI.ParentId                           AS ParentId

            , Object_Member.Id                         AS MemberId
            , Object_Member.ValueData                  AS MemberName

            , Object_PositionLevel.Id                  AS PositionLevelId
            , Object_PositionLevel.ValueData           AS PositionLevelName

            , Object_StaffList.Id                      AS StaffListId
            , Object_StaffList.ObjectCode              AS StaffListCode
            , ('(' || COALESCE (Object_Unit_StaffList.ObjectCode, 0) :: TVarChar || ') ' || COALESCE (Object_Unit_StaffList.ValueData, '')
            || CASE WHEN Object_PositionLevel_StaffList.ValueData      <> '' THEN ' - ' || Object_PositionLevel_StaffList.ValueData ELSE '' END
            || CASE WHEN Object_Position_StaffList.ValueData           <> '' THEN ' - ' || Object_Position_StaffList.ValueData      ELSE '' END
            || CASE WHEN ObjectFloat_PersonalCount.ValueData           <> 0  THEN ' - ' || zfConvert_FloatToString (ObjectFloat_PersonalCount.ValueData) ELSE ' - ???' END ||  ' чел.'
              ) :: TVarChar AS StaffListName

            , Object_ModelService.Id                   AS ModelServiceId
            , Object_ModelService.ValueData            AS ModelServiceName

            , Object_StaffListSummKind.Id              AS StaffListSummKindId
            , Object_StaffListSummKind.ValueData       AS StaffListSummKindName

            , Object_StorageLine.Id                    AS StorageLineId
            , Object_StorageLine.ValueData             AS StorageLineName

            , tmpMI.Amount :: TFloat                   AS Amount

            , MIFloat_MemberCount.ValueData            AS MemberCount
            , MIFloat_DayCount.ValueData               AS DayCount
            , MIFloat_WorkTimeHoursOne.ValueData       AS WorkTimeHoursOne
            , MIFloat_WorkTimeHours.ValueData          AS WorkTimeHours
            , MIFloat_Price.ValueData                  AS Price
            , MIFloat_HoursPlan.ValueData              AS HoursPlan
            , MIFloat_HoursDay.ValueData               AS HoursDay
            , MIFloat_PersonalCount.ValueData          AS PersonalCount
            , MIFloat_GrossOne.ValueData               AS GrossOne
            , MIFloat_Koeff.ValueData        ::TFloat  AS Koeff

            --CASE WHEN COALESCE (MIFloat_GrossOne.ValueData,0) <> 0 THEN tmpMI.Amount / MIFloat_GrossOne.ValueData ELSE 0 END
            , CAST ( (COALESCE (MIFloat_Koeff.ValueData, 0) * MIFloat_Price.ValueData) AS NUMERIC (16,2) ) ::TFloat AS Rate

            , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN tmpMovementItemFloat AS MIFloat_MemberCount
                                        ON MIFloat_MemberCount.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_MemberCount.DescId = zc_MIFloat_MemberCount()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayCount
                                        ON MIFloat_DayCount.MovementItemId = tmpMI .MovementItemId
                                       AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_WorkTimeHoursOne
                                        ON MIFloat_WorkTimeHoursOne.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_WorkTimeHoursOne.DescId = zc_MIFloat_WorkTimeHoursOne()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_WorkTimeHours
                                        ON MIFloat_WorkTimeHours.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_WorkTimeHours.DescId = zc_MIFloat_WorkTimeHours()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_HoursPlan
                                        ON MIFloat_HoursPlan.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_HoursPlan.DescId = zc_MIFloat_HoursPlan()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_HoursDay
                                        ON MIFloat_HoursDay.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_HoursDay.DescId = zc_MIFloat_HoursDay()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_PersonalCount
                                        ON MIFloat_PersonalCount.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_PersonalCount.DescId = zc_MIFloat_PersonalCount()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_GrossOne
                                        ON MIFloat_GrossOne.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_GrossOne.DescId = zc_MIFloat_GrossOne()
            LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                        ON MIFloat_Koeff.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId

            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpMI.PositionLevelId
            LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = tmpMI.StaffListId
            LEFT JOIN Object AS Object_ModelService ON Object_ModelService.Id = tmpMI.ModelServiceId
            LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = tmpMI.StaffListSummKindId
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = tmpMI.StorageLineId
 -- для штатного рпасписания
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                 ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
            LEFT JOIN Object AS Object_Unit_StaffList ON Object_Unit_StaffList.Id = ObjectLink_StaffList_Unit.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                                 ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
            LEFT JOIN Object AS Object_Position_StaffList ON Object_Position_StaffList.Id = ObjectLink_StaffList_Position.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                 ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel_StaffList ON Object_PositionLevel_StaffList.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount
                                  ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id
                                 AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.11.21         *
 26.05.17         * add StorageLine
 21.06.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PersonalService_Child (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_PersonalService_Child (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')
