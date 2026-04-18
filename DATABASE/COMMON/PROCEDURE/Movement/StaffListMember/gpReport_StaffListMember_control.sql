-- Function: gpReport_StaffListMember_control()

DROP FUNCTION IF EXISTS gpReport_StaffListMember_control (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListMember_control(
    IN inUnitId            Integer ,
    IN inMemberId          Integer ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- УЕУУЙС РПМШЪПЧБФЕМС
)
RETURNS TABLE (Text_control      TVarChar
             , DateIn            TDateTime
             , DateSend          TDateTime
             , DateOut           TDateTime
             , MemberId          Integer  
             , MemberCode        Integer  
             , MemberName        TVarChar 
             , PositionId        Integer  
             , PositionName      TVarChar 
             , PositionLevelId   Integer  
             , PositionLevelName TVarChar 
             , UnitId            Integer  
             , UnitName          TVarChar 
             , isMain            Boolean  
             , isOfficial        Boolean  
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_StaffListMember Boolean;
BEGIN
     --  проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

     WITH
     tmpViewPersonal AS (SELECT *
                         FROM (SELECT *
                                    -- есть задвоенные сотрудники для разных StorageLine для них не нужно дублировать документ приема
                                    , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId, tmp.PositionId, COALESCE (tmp.PositionLevelId,0), tmp.UnitId/*, tmp.DateIn*/ ORDER BY tmp.isMain DESC, tmp.DateIn, tmp.PersonalId ASC) AS Ord_sl -- 
                               FROM Object_Personal_View AS tmp
                               WHERE (tmp.isERased = inIsErased OR inIsErased = TRUE)
                                 AND (tmp.MemberId = inMemberId OR inMemberId = 0)
                                 AND (tmp.UnitId = inUnitId OR inUnitId = 0)
                               ) AS tmp
                         WHERE tmp.DateOut = zc_DateEnd()
                         )

   , tmpMovement_all AS (SELECT *
                            , MovementLinkObject_Unit.ObjectId AS UnitId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND (MovementLinkObject_Unit.ObjectId = inUnitId  OR inUnitId = 0)
                        WHERE Movement.DescId = zc_Movement_StaffListMember()
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                        )

   , tmpMovementBoolean AS (SELECT MovementBoolean.*
                            FROM MovementBoolean
                            WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                              AND MovementBoolean.DescId IN (zc_MovementBoolean_Official()
                                                           , zc_MovementBoolean_Main()
                                                            )
                            )       

   , tmpMovementString AS (SELECT MovementString.*
                           FROM MovementString
                           WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                             AND MovementString.DescId IN (zc_MovementString_Comment()
                                                         , zc_MovementString_NumBiz()
                                                           )
                           )

   , tmpMovementDate AS (SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                           AND MovementDate.DescId IN (zc_MovementDate_Insert()
                                                        , zc_MovementDate_Update()
                                                         )
                         )
   , tmpMLO AS (SELECT MovementLinkObject.*
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all) 
                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_ReasonOut()
                                                  , zc_MovementLinkObject_StaffListKind() 
                                                  , zc_MovementLinkObject_Member()
                                                  , zc_MovementLinkObject_Position()
                                                  , zc_MovementLinkObject_PositionLevel()
                                                 
                                                   )
                )

   , tmpMov_Data AS (SELECT Movement.*
                          , MovementLinkObject_Member.ObjectId        AS MemberId
                          , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId        --zc_Enum_StaffListKind_Send()  zc_Enum_StaffListKind_Out() zc_Enum_StaffListKind_Add() zc_Enum_StaffListKind_In()                   
                     FROM tmpMovement_all AS Movement
                          LEFT JOIN tmpMLO AS MovementLinkObject_Member
                                           ON MovementLinkObject_Member.MovementId = Movement.Id
                                          AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                           --AND (MovementLinkObject_Member.ObjectId = inMemberId OR inMemberId = 0)
                          INNER JOIN (SELECT DISTINCT tmpViewPersonal.MemberId FROM tmpViewPersonal) AS tmpMember ON tmpMember.MemberId = MovementLinkObject_Member.ObjectId
                          LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                           ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                          AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                     )
   , tmpMovement AS (SELECT Movement.*
                          , COALESCE (MovementBoolean_Official.ValueData, FALSE) ::Boolean  AS isOfficial
                          , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain
                          , MovementLinkObject_Position.ObjectId AS PositionId
                          , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                     FROM tmpMov_Data AS Movement
                          LEFT JOIN tmpMovementBoolean AS MovementBoolean_Main
                                                       ON MovementBoolean_Main.MovementId = Movement.Id
                                                      AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()

                          LEFT JOIN tmpMovementBoolean AS MovementBoolean_Official
                                                       ON MovementBoolean_Official.MovementId = Movement.Id
                                                      AND MovementBoolean_Official.DescId = zc_MovementBoolean_Official()

                          LEFT JOIN tmpMLO AS MovementLinkObject_Position
                                           ON MovementLinkObject_Position.MovementId = Movement.Id
                                          AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()

                          LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                                           ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                                          AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
                     )
   , tmpMovement_Last_Main AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE 
                                     ) AS tmp
                               WHERE tmp.ord = 1
                                 AND tmp.StaffListKindId <> zc_Enum_StaffListKind_Out()  
                               )  
   , tmpMovement_Last_Add AS (SELECT * 
                                 FROM (SELECT *
                                            --не основное место работы берем последнее
                                            , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId, tmpMovement.PositionId, tmpMovement.PositionLevelId ORDER BY tmpMovement.OperDate DESC) AS Ord 
                                       FROM tmpMovement
                                       WHERE tmpMovement.isMain = FALSE
                                       ) AS tmp
                                 WHERE tmp.Ord = 1
                                   AND tmp.StaffListKindId <> zc_Enum_StaffListKind_Out()
                                 )

   , tmpPersonal_main AS (SELECT *
                          FROM (SELECT tmpViewPersonal.*
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY COALESCE (tmpViewPersonal.DateSend, tmpViewPersonal.DateIn) DESC) AS Ord 
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = TRUE
                                ) AS tmp
                          WHERE tmp.Ord = 1
                          )
   , tmpPersonal_add AS (SELECT *
                         FROM (SELECT tmpViewPersonal.*
                                    , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId
                                                                    , tmpViewPersonal.UnitId
                                                                    , tmpViewPersonal.PositionId
                                                                    , tmpViewPersonal.PositionLevelId
                                                         ORDER BY tmpViewPersonal.DateIn DESC)          AS Ord 
                               FROM tmpViewPersonal
                               WHERE tmpViewPersonal.isMain = FALSE AND tmpViewPersonal.DateSend IS NULL
                               ) AS tmp
                         WHERE tmp.Ord = 1
                         )

   , tmp_Err AS (--основное место работы - есть сотрудник нет документа
                 SELECT 1 AS Kind
                      , tmpViewPersonal.DateIn    ::TDateTime
                      , tmpViewPersonal.DateSend  ::TDateTime
                      , tmpViewPersonal.DateOut   ::TDateTime
                      , tmpViewPersonal.UnitId 
                      , tmpViewPersonal.MemberId
                      , tmpViewPersonal.PositionId
                      , tmpViewPersonal.PositionLevelId
                      , tmpViewPersonal.isMain
                      , tmpViewPersonal.isOfficial
                 FROM tmpPersonal_main AS tmpViewPersonal 
                      LEFT JOIN tmpMovement_Last_Main AS tmpMovement_Last
                                                      ON tmpMovement_Last.MemberId = tmpViewPersonal.MemberId
                                                     AND tmpMovement_Last.UnitId = tmpViewPersonal.UnitId
                                                     AND tmpMovement_Last.PositionId = tmpViewPersonal.PositionId
                                                     AND COALESCE (tmpMovement_Last.PositionLevelId,0) = COALESCE (tmpViewPersonal.PositionLevelId,0)
                 WHERE tmpMovement_Last.MemberId IS NULL
               UNION 
                 --по совместительству - есть сотрудник нет документа
                 SELECT 2 AS Kind
                      , tmpViewPersonal.DateIn    ::TDateTime
                      , tmpViewPersonal.DateSend  ::TDateTime
                      , tmpViewPersonal.DateOut   ::TDateTime
                      , tmpViewPersonal.UnitId 
                      , tmpViewPersonal.MemberId
                      , tmpViewPersonal.PositionId
                      , tmpViewPersonal.PositionLevelId
                      , tmpViewPersonal.isMain
                      , tmpViewPersonal.isOfficial
                 FROM tmpPersonal_add AS tmpViewPersonal 
                      LEFT JOIN tmpMovement_Last_Add AS tmpMovement_Last
                                                     ON tmpMovement_Last.MemberId = tmpViewPersonal.MemberId
                                                    AND tmpMovement_Last.UnitId = tmpViewPersonal.UnitId
                                                    AND tmpMovement_Last.PositionId = tmpViewPersonal.PositionId
                                                    AND COALESCE (tmpMovement_Last.PositionLevelId,0) = COALESCE (tmpViewPersonal.PositionLevelId,0)
                 WHERE tmpMovement_Last.MemberId IS NULL
               )
      --
      SELECT CASE WHEN tmp.Kind = 1 THEN 'Основное место работы - нет документа'
                  WHEN tmp.Kind = 2 THEN 'По совместительству - нет документа'
              END                           ::TVarChar  AS Text_control
           , tmp.DateIn                     ::TDateTime
           , tmp.DateSend                   ::TDateTime
           , tmp.DateOut                    ::TDateTime
           , Object_Member.Id               ::Integer   AS MemberId
           , Object_Member.ObjectCode       ::Integer   AS MemberCode
           , Object_Member.ValueData        ::TVarChar  AS MemberName
           , Object_Position.Id             ::Integer   AS PositionId
           , Object_Position.ValueData      ::TVarChar  AS PositionName
           , Object_PositionLevel.Id        ::Integer   AS PositionLevelId
           , Object_PositionLevel.ValueData ::TVarChar  AS PositionLevelName
           , Object_Unit.Id                 ::Integer   AS UnitId
           , Object_Unit.ValueData          ::TVarChar  AS UnitName
           , tmp.isMain                     ::Boolean   AS isMain
           , tmp.isOfficial                 ::Boolean   AS isOfficial
      FROM tmp_Err AS tmp
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmp.PositionId
           LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmp.PositionLevelId

 ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.26         *
*/

-- тест
--SELECT * FROM gpReport_StaffListMember_control (inUnitId :=0 , inMemberId:= 0, inIsErased:=false, inSession:= zfCalc_UserAdmin())    --8428 "Відділ маркетингу та реклами"

--SELECT * FROM gpReport_StaffListMember_byPersonal (inUnitId := 9316729, inMemberId:= 81171, inIsErased:=true, inSession:= zfCalc_UserAdmin())
--inMemberId:= 7659382
---select * from gpGet_Object_Personal(inId := 12408227 , inMaskId := 0 ,  inSession := '9457'::TVarchar);--
--select * from gpGet_Object_Personal(Id := 4846223 , MaskId := 0 ,  inSession := '9457');

--SELECT * FROM gpReport_StaffListMember_byPersonal (inUnitId := 8450, inMemberId:= 8478267, inIsErased:=true, inSession:= zfCalc_UserAdmin())   --   Цибулька Ольга Серг??вна

--select * from gpGet_Object_Personal(inId := 11694844 , inMaskId := 0 ,  inSession := '9457');
--select * from gpGet_Object_Personal(Id := 12408227 , MaskId := 0 ,  inSession := '9457');
