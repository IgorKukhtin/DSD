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
           --
             , PositionId_object         Integer
             , PositionName_object       TVarChar
             , PositionLevelId_object    Integer
             , PositionLevelName_object  TVarChar
             , UnitId_object             Integer
             , UnitName_object           TVarChar
             , DateIn_object             TDateTime
             , DateSend_object           TDateTime
             , DateOut_object            TDateTime
             , isOfficial_object         Boolean
             , isErased_object           Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_StaffListMember Boolean;
BEGIN
     --  проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     inIsErased:= TRUE;

     -- Результат
     RETURN QUERY

     WITH
     tmpViewPersonal AS (SELECT *
                         FROM (SELECT *
                                    -- есть задвоенные сотрудники для разных StorageLine для них не нужно дублировать документ приема
                                    , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId, tmp.PositionId, COALESCE (tmp.PositionLevelId,0), tmp.UnitId/*, tmp.DateIn*/ ORDER BY tmp.isMain DESC, tmp.DateIn) AS Ord_sl -- 
                               FROM Object_Personal_View AS tmp
                               WHERE (tmp.isERased = inIsErased OR inIsErased = TRUE)
                                 AND (tmp.MemberId = inMemberId OR inMemberId = 0)
                                -- AND (tmp.UnitId = inUnitId OR inUnitId = 0)  
                                 AND tmp.isMain = TRUE
                               ) AS tmp
                         WHERE tmp.Ord_sl = 1
                         )
     --все документы
   , tmpMovement_all AS (SELECT *
                            , MovementLinkObject_Unit.ObjectId AS UnitId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND (MovementLinkObject_Unit.ObjectId = inUnitId  OR inUnitId = 0)
                        WHERE Movement.DescId = zc_Movement_StaffListMember()
                          AND Movement.StatusId = zc_Enum_Status_Complete() --zc_Enum_Status_Erased()
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
     --все докум. выбранных для физ.лиц
   , tmpMov_Data AS (SELECT Movement.*
                          , MovementLinkObject_Member.ObjectId        AS MemberId
                          , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId        --zc_Enum_StaffListKind_Send()  zc_Enum_StaffListKind_Out() zc_Enum_StaffListKind_Add() zc_Enum_StaffListKind_In()                   
                     FROM tmpMovement_all AS Movement
                          INNER JOIN tmpMLO AS MovementLinkObject_Member
                                            ON MovementLinkObject_Member.MovementId = Movement.Id
                                           AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                           AND (MovementLinkObject_Member.ObjectId = inMemberId OR inMemberId = 0)
                          --INNER JOIN (SELECT DISTINCT tmpViewPersonal.MemberId FROM tmpViewPersonal) AS tmpMember ON tmpMember.MemberId = MovementLinkObject_Member.ObjectId
                          LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                           ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                          AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                     )
   -- + должность разряд, главное, офиц.                  
   , tmpMovement AS (SELECT Movement.*
                          , COALESCE (MovementBoolean_Official.ValueData, FALSE) ::Boolean  AS isOfficial
                          , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain
                          , MovementLinkObject_Position.ObjectId AS PositionId
                          , MovementLinkObject_PositionLevel.ObjectId AS PositionLevelId
                          --, ROW_NUMBER () OVER (PARTITION BY Movement.MemberId ORDER BY Movement.OperDate DESC) AS ord
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
   --выбираем для isMain=True последний документ приема (для понимания когда принят на работу) 
   , tmpMovement_main_in AS (SELECT * 
                             FROM (SELECT *
                                        , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                   FROM tmpMovement
                                   WHERE tmpMovement.isMain = TRUE
                                     AND tmpMovement.StaffListKindId IN (zc_Enum_StaffListKind_In(),zc_Enum_StaffListKind_Add())
                                   ) AS tmp
                             WHERE tmp.ord = 1
                              -- AND tmp.StaffListKindId <> zc_Enum_StaffListKind_Out()  
                             )  
   --выбираем для isMain=True последний документ перевода  
   , tmpMovement_main_send AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE
                                       AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Send()  
                                     ) AS tmp
                               WHERE tmp.ord = 1
                               )
   --выбираем для isMain=True последний документ увольнения  
   , tmpMovement_main_out AS (SELECT * 
                               FROM (SELECT *
                                          , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MemberId ORDER BY tmpMovement.OperDate DESC) AS Ord
                                     FROM tmpMovement
                                     WHERE tmpMovement.isMain = TRUE
                                       AND tmpMovement.StaffListKindId = zc_Enum_StaffListKind_Out()  
                                     ) AS tmp
                               WHERE tmp.ord = 1
                               )

   , tmpPersonal_main AS (SELECT *
                          FROM (SELECT tmpViewPersonal.*
                                     , ROW_NUMBER() OVER (PARTITION BY tmpViewPersonal.MemberId ORDER BY COALESCE (tmpViewPersonal.DateSend, tmpViewPersonal.DateIn) DESC) AS Ord
                                     --, Count() OVER (PARTITION BY tmpViewPersonal.MemberId) AS Count
                                FROM tmpViewPersonal
                                WHERE tmpViewPersonal.isMain = TRUE
                                ) AS tmp
                          WHERE tmp.Ord = 1
                          )

   , tmpMember_byMovement AS (SELECT DISTINCT tmpMovement.MemberId
                              FROM tmpMovement
                              WHERE tmpMovement.isMain = TRUE
                              )
   --данные по физ лицу - прием, перевод, увольнение
   , tmpData AS (--основное место работы 
                 SELECT Movement_in.OperDate     ::TDateTime AS DateIn
                      , Movement_send.OperDate   ::TDateTime AS DateSend
                      , Movement_out.OperDate    ::TDateTime AS DateOut
                      , COALESCE (Movement_out.UnitId, Movement_send.UnitId, Movement_in.UnitId) AS UnitId 
                      , tmpMember.MemberId
                      , COALESCE (Movement_out.PositionId, Movement_send.PositionId, Movement_in.PositionId) AS PositionId
                      , COALESCE (Movement_out.PositionLevelId, Movement_send.PositionLevelId, Movement_in.PositionLevelId) AS PositionLevelId
                      , Movement_in.isMain
                      , Movement_in.isOfficial
                 FROM tmpMember_byMovement AS tmpMember
                      LEFT JOIN tmpMovement_main_in   AS Movement_in ON Movement_in.MemberId = tmpMember.MemberId
                      LEFT JOIN tmpMovement_main_send AS Movement_send ON Movement_send.MemberId = tmpMember.MemberId
                      LEFT JOIN tmpMovement_main_out  AS Movement_out ON Movement_out.MemberId = tmpMember.MemberId
               )
   , tmpErr AS (
                SELECT *
                FROM (SELECT tmpData.MemberId
                           , tmpData.isMain
                           , tmpData.isOfficial
                           , tmpData.UnitId
                           , tmpData.PositionId
                           , tmpData.PositionLevelId
                           , tmpData.DateIn
                           , tmpData.DateSend
                           , COALESCE (tmpData.DateOut, zc_DateEnd()) AS DateOut
                           --
                           , tmpPersonal.UnitId           AS UnitId_object
                           , tmpPersonal.PositionId       AS PositionId_object
                           , tmpPersonal.PositionLevelId  AS PositionLevelId_object
                           , tmpPersonal.DateIn           AS DateIn_object
                           , tmpPersonal.DateSend         AS DateSend_object
                           , tmpPersonal.DateOut          AS DateOut_object
                           , tmpPersonal.isOfficial       AS isOfficial_object
                           , tmpPersonal.isErased         AS isErased_object
                      FROM tmpData
                           LEFT JOIN tmpPersonal_main AS tmpPersonal ON tmpPersonal.MemberId = tmpData.MemberId
                      ) AS tmp
                 WHERE COALESCE (tmp.isOfficial, FALSE)   <> COALESCE (tmp.isOfficial_object, FALSE)
                    OR COALESCE (tmp.UnitId,0)            <> COALESCE (tmp.UnitId_object,0)
                    OR COALESCE (tmp.PositionId,0)        <> COALESCE (tmp.PositionId_object,0)
                    OR COALESCE (tmp.PositionLevelId,0)   <> COALESCE (tmp.PositionLevelId_object,0)
                    OR COALESCE (tmp.DateIn, zc_DateEnd())  <> COALESCE (tmp.DateIn_object, zc_DateEnd())
                    OR COALESCE (tmp.DateSend, zc_DateEnd())<> COALESCE (tmp.DateSend_object, zc_DateEnd())
                    OR COALESCE (tmp.DateOut, zc_DateEnd()) <> COALESCE (tmp.DateOut_object, zc_DateEnd())
                    
               )
      --
      SELECT CASE WHEN COALESCE (tmp.UnitId,0) <> COALESCE (tmp.UnitId_object,0) THEN 'Подразделение'
                  WHEN COALESCE (tmp.PositionId,0)        <> COALESCE (tmp.PositionId_object,0) THEN 'Должность'
                  WHEN COALESCE (tmp.PositionLevelId,0)   <> COALESCE (tmp.PositionLevelId_object,0) THEN 'Разряд должности'
                  WHEN COALESCE (tmp.DateIn, zc_DateEnd())  <> COALESCE (tmp.DateIn_object, zc_DateEnd()) THEN 'Дата приема'
                  WHEN COALESCE (tmp.DateSend, zc_DateEnd())<> COALESCE (tmp.DateSend_object, zc_DateEnd()) THEN 'Дата перевода'
                  WHEN COALESCE (tmp.DateOut, zc_DateEnd()) <> COALESCE (tmp.DateOut_object, zc_DateEnd()) THEN 'Дата увольнения'
                  ELSE ''
             END                            ::TVarChar  AS Text_control
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
           --
           , Object_Position_object.Id             ::Integer   AS PositionId_object
           , Object_Position_object.ValueData      ::TVarChar  AS PositionName_object
           , Object_PositionLevel_object.Id        ::Integer   AS PositionLevelId_object
           , Object_PositionLevel_object.ValueData ::TVarChar  AS PositionLevelName_object
           , Object_Unit_object.Id                 ::Integer   AS UnitId_object
           , Object_Unit_object.ValueData          ::TVarChar  AS UnitName_object
           , tmp.DateIn_object                     ::TDateTime AS DateIn_object
           , tmp.DateSend_object                   ::TDateTime AS DateSend_object
           , tmp.DateOut_object                    ::TDateTime AS DateOut_object
           , tmp.isOfficial_object                 ::Boolean   AS isOfficial_object
           , tmp.isErased_object                   ::Boolean   AS isErased_object
      FROM tmpErr AS tmp
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmp.PositionId
           LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmp.PositionLevelId
           --
           LEFT JOIN Object AS Object_Unit_object ON Object_Unit_object.Id = tmp.UnitId_object
           LEFT JOIN Object AS Object_Position_object ON Object_Position_object.Id = tmp.PositionId_object
           LEFT JOIN Object AS Object_PositionLevel_object ON Object_PositionLevel_object.Id = tmp.PositionLevelId_object
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
--SELECT * FROM gpReport_StaffListMember_control (inUnitId :=0 , inMemberId:= 0, inIsErased:=TRUE, inSession:= zfCalc_UserAdmin())    --8428 "Відділ маркетингу та реклами"
