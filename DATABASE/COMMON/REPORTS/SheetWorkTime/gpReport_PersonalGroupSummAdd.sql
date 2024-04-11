-- Function: gpReport_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpReport_PersonalGroupSummAdd (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PersonalGroupSummAdd(
    IN inOperDate    TDateTime , -- месяц начисления
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (
          UnitId Integer
        , UnitName TVarChar
        , MemberId Integer
        , MemberCode Integer
        , MemberName TVarChar
        , PositionId Integer
        , PositionName TVarChar
        , PositionLevelId Integer
        , PositionLevelName TVarChar
        , PersonalGroupId Integer
        , PersonalGroupName TVarChar 
        
        , PersonalServiceListId  Integer
        , PersonalServiceListName TVarChar
        , MI_Id_PersonalService      Integer
        , MovementId_PersonalService Integer
        , InvNumber_PersonalService  TVarChar
        , SummAdd_PersonalService TFloat

        , NormHour   TFloat
        , TotalSumm  TFloat
        , Hour_work  TFloat
        , Day_skip   TFloat
        , Summ_Hour  TFloat
        , SummAdd    TFloat
        , isSkip     Boolean
)
AS
$BODY$
 DECLARE vbStartDate TDateTime;
         vbEndDate TDateTime;
 DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);



     --переопределили - нач. месяца
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate);
     
     vbStartDate := inOperDate;
     vbEndDate := vbStartDate + INTERVAL '1 Month' - INTERVAL '1 Day';

     --
     --CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
     --  AS SELECT generate_series(vbStartDate, vbEndDate, '1 DAY'::interval) OperDate;

    -- Результат
    RETURN QUERY
    WITH
    tmpOperDate AS ( SELECT generate_series(vbStartDate, vbEndDate, '1 DAY'::interval) OperDate) 

  , tmpPersonal AS (SELECT ObjectLink_Personal_Member.ChildObjectId         AS MemberId
                         , ObjectLink_Personal_Member.ObjectId              AS PersonalId
                         , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
                         , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
                         , ObjectLink_Personal_PositionLevel.ChildObjectId  AS PositionLevelId
                         
                         , ObjectLink_PersonalServiceList.ChildObjectId     AS PersonalServiceListId
                         , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
                         , COALESCE (ObjectBoolean_Main.ValueData, FALSE) AS isMain
                         , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                              -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                              ORDER BY CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                     , CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                     , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                     , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                     , ObjectLink_Personal_Member.ObjectId
                                             ) AS Ord
                         , ObjectDate_DateIn.ValueData                            AS DateIn
                         , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd())  AS DateOut
                    FROM ObjectLink AS ObjectLink_Personal_Member
                         LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                              ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                              ON ObjectLink_Personal_PositionLevel.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                         LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                              ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                 ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                 ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                         LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                              ON ObjectDate_DateIn.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
                         LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                              ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                             AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                    WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                      AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                      AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) >= '10.01.2024'
                   )

  , tmpMovement AS (
                    SELECT Movement.*
                         , MovementLinkObject_Unit.ObjectId AS UnitId
                         , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                      AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                      ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                     AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                        -- LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId
                    WHERE Movement.OperDate = inOperDate
                      AND Movement.DescId = zc_Movement_PersonalGroupSummAdd()
                      --AND Movement.StatusId <> zc_Enum_Status_Erased()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )

  , tmpMFloat_NormHour AS (SELECT MovementFloat_NormHour.*
                        FROM  MovementFloat AS MovementFloat_NormHour
                        WHERE MovementFloat_NormHour.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementFloat_NormHour.DescId = zc_MovementFloat_NormHour()
                        )

  , tmpMI AS (SELECT MovementItem.Id
                   , MovementItem.MovementId
                   , MovementItem.Amount                 AS Amount
                   , MovementItem.ObjectId               AS PositionId
                   , MILinkObject_PositionLevel.ObjectId AS PositionLevelId
              FROM MovementItem 
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                    ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
              )  

  /*
  
      zc_Enum_WorkTimeKind_Work(),      Рабочие часы'  
      zc_Enum_WorkTimeKind_Holiday(),   Отпуск'        
      zc_Enum_WorkTimeKind_Hospital(),  Больничный'    
      zc_Enum_WorkTimeKind_Skip(),      Прогул'        
      zc_Enum_WorkTimeKind_Trainee50(), Стажер50%'     
      zc_Enum_WorkTimeKind_Trainee(),   Стажер'        
      zc_Enum_WorkTimeKind_Quit(),      Увольнение'    
      zc_Enum_WorkTimeKind_Trial(),     пробная смена' 
      zc_Enum_WorkTimeKind_DayOff(),    Выходной'      
      zc_Enum_WorkTimeKind_Trip(),      'Командировка' 
      zc_Enum_WorkTimeKind_Medicday(),  'Санобработка' 
      zc_Enum_WorkTimeKind_Inventory(), 'Инвентаризация
     
  */
   -- рабочее время из табеля
  , tmpSheetWorkTime AS (SELECT SUM (COALESCE (MI_SheetWorkTime.Amount,0)) AS Amount
                              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip() THEN 1 ELSE 0 END) AS Day_skip
                              , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                              , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                              , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                              , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM tmpOperDate
                             JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                           AND Movement.DescId = zc_Movement_SheetWorkTime()
                                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                              JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              JOIN MovementItem AS MI_SheetWorkTime
                                                ON MI_SheetWorkTime.MovementId = Movement.Id
                                               AND MI_SheetWorkTime.isErased = FALSE
                                               AND MI_SheetWorkTime.DescId = zc_MI_Master()
                              LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                               ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_Position.DescId = zc_MILinkObject_Position()
                              LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                               ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 

                              -- отсечем не нужные должности и разряд должности
                              INNER JOIN tmpMI ON tmpMI.PositionId = COALESCE(MIObject_Position.ObjectId, 0)
                                              AND COALESCE(tmpMI.PositionLevelId,0) = COALESCE(MIObject_PositionLevel.ObjectId, 0) 

                              LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
      
                              LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                               ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                              AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                              INNER JOIN (SELECT DISTINCT tmpMovement.UnitId, COALESCE (tmpMovement.PersonalGroupId,0) AS PersonalGroupId
                                          FROM tmpMovement) AS tmp
                                                            ON tmp.UnitId = MovementLinkObject_Unit.ObjectId
                                                           AND (tmp.PersonalGroupId = COALESCE(MIObject_PersonalGroup.ObjectId, 0) OR COALESCE (tmp.PersonalGroupId,0) = 0)

                         --WHERE (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                         GROUP BY COALESCE(MI_SheetWorkTime.ObjectId, 0)
                              , COALESCE(MIObject_Position.ObjectId, 0)
                              , COALESCE(MIObject_PositionLevel.ObjectId, 0)
                              , COALESCE(MIObject_PersonalGroup.ObjectId, 0)
                              , MovementLinkObject_Unit.ObjectId
                         )
/*
               WHERE (tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_Work()
                                          , zc_Enum_WorkTimeKind_WorkD()
                                          , zc_Enum_WorkTimeKind_WorkN()
                                          , zc_Enum_WorkTimeKind_WorkDayOff()
                                          , zc_Enum_WorkTimeKind_RemoteAccess()
                                          , zc_Enum_WorkTimeKind_Trainee50()
                                          )
                     OR tmp.WorkTimeKind_Tax <> 0)
*/
 

  , tmpRes AS (SELECT tmpMovement.Id AS MovementId
                    , tmpMovement.InvNumber
                    , MovementFloat_NormHour.ValueData AS NormHour
                    , tmpMI.Amount                     AS TotalSumm
                    , CASE WHEN COALESCE (MovementFloat_NormHour.ValueData,0) <> 0 THEN tmpMI.Amount / MovementFloat_NormHour.ValueData ELSE 0 END AS Summ_Hour
                    , tmpSheetWorkTime.MemberId
                    , tmpSheetWorkTime.PositionId
                    , tmpSheetWorkTime.PositionLevelId
                    , tmpSheetWorkTime.PersonalGroupId
                    , tmpSheetWorkTime.UnitId  
                    , tmpPersonal.PersonalServiceListId
                    , tmpSheetWorkTime.Amount          AS Hour_work
                    , tmpSheetWorkTime.Day_skip        AS Day_skip
                    , CASE WHEN COALESCE (tmpSkip.Day_skip,0) <> 0 THEN TRUE ELSE FALSE END AS isSkip 
                   -- , ShortName
               FROM tmpMovement
                   LEFT JOIN tmpMFloat_NormHour AS MovementFloat_NormHour
                                                ON MovementFloat_NormHour.MovementId = tmpMovement.Id
                                               AND MovementFloat_NormHour.DescId = zc_MovementFloat_NormHour()

                   INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovement.Id
                   
                   INNER JOIN tmpSheetWorkTime ON tmpSheetWorkTime.PositionId = tmpMI.PositionId
                                              AND COALESCE (tmpSheetWorkTime.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                              AND COALESCE (tmpSheetWorkTime.Amount,0) > 0
                                              AND tmpSheetWorkTime.UnitId = tmpMovement.UnitId
                                              AND COALESCE (tmpSheetWorkTime.PersonalGroupId,0) = COALESCE (tmpMovement.PersonalGroupId,0)   
                   --привязываем еще раз чтоб по физ. лицу привязать прогулы (если прогул по любой должности нет премии)
                   LEFT JOIN (SELECT tmp.MemberId, SUM (COALESCE (tmp.Day_skip,0)) AS Day_skip
                              FROM tmpSheetWorkTime AS tmp
                              WHERE COALESCE (tmp.Day_skip,0) <> 0
                              GROUP BY tmp.MemberId) AS tmpSkip
                                                     ON tmpSkip.MemberId = tmpSheetWorkTime.MemberId 

                   LEFT JOIN tmpPersonal ON tmpPersonal.MemberId        = tmpSheetWorkTime.MemberId
                                        AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (tmpSheetWorkTime.PositionLevelId,0)
                                        AND tmpPersonal.PositionId      = tmpSheetWorkTime.PositionId
                                        AND tmpPersonal.UnitId          = tmpSheetWorkTime.UnitId
               ) 

  -- сумму из основной ведомости по фио из колонки "Премия" 
  , tmpPersonalService AS (SELECT Movement.Id                                      AS MovementId
                                , MovementItem.Id                                  AS MovementItemId
                                , ObjectLink_Personal_Member.ChildObjectId         AS MemberId       --MemberId_Personal 
                                , MILinkObject_Position.ObjectId                   AS PositionId
                                , MILinkObject_PositionLevel.ObjectId              AS PositionLevelId
                                , MovementLinkObject_PersonalServiceList.ObjectId  AS PersonalServiceListId
                                , (COALESCE (MIFloat_SummAdd.ValueData,0))         AS SummAdd
                           FROM MovementDate AS MovementDate_ServiceDate
                               JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                            AND Movement.DescId = zc_Movement_PersonalService()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                            ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                    ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                   AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                           ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

                           WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inOperDate) AND (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                            AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                           --GROUP BY ObjectLink_Personal_Member.ChildObjectId
                           --       , MovementLinkObject_PersonalServiceList.ObjectId
                           )


   ---
   SELECT Object_Unit.Id                  AS UnitId
        , Object_Unit.ValueData           AS UnitName
        , Object_Member.Id                AS MemberId
        , Object_Member.ObjectCode        AS MemberCode
        , Object_Member.ValueData         AS MemberName
        , Object_Position.Id              AS PositionId
        , Object_Position.ValueData       AS PositionName
        , Object_PositionLevel.Id         AS PositionLevelId
        , Object_PositionLevel.ValueData  AS PositionLevelName
        , Object_PersonalGroup.Id         AS PersonalGroupId
        , Object_PersonalGroup.ValueData  AS PersonalGroupName    
        
        , Object_PersonalServiceList.Id        AS PersonalServiceListId
        , Object_PersonalServiceList.ValueData AS PersonalServiceListName
        , tmpPersonalService.MovementItemId  ::Integer  AS MI_Id_PersonalService
        , CASE WHEN COALESCE (tmpPersonalService.MovementId,0) = 0 THEN -1 ELSE tmpPersonalService.MovementId END ::Integer AS MovementId_PersonalService
        , ('№ ' || Movement_PersonalService.InvNumber || ' от ' || Movement_PersonalService.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PersonalService
         
        , tmpPersonalService.SummAdd ::TFloat  AS SummAdd_PersonalService
        
        , tmpRes.NormHour   ::TFloat
        , tmpRes.TotalSumm  ::TFloat
        , tmpRes.Hour_work  ::TFloat
        , tmpRes.Day_skip   ::TFloat
        , tmpRes.Summ_Hour  ::TFloat
        , CASE WHEN tmpRes.Hour_work <=72 OR tmpRes.isSkip = TRUE THEN 0
               WHEN tmpRes.Hour_work >= tmpRes.NormHour THEN tmpRes.TotalSumm
               ELSE tmpRes.Summ_hour * tmpRes.Hour_work
          END ::TFloat AS SummAdd
        , tmpRes.isSkip ::Boolean AS isSkip
        
   FROM tmpRes
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpRes.MemberId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpRes.PositionId
        LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpRes.PositionLevelId
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpRes.PersonalGroupId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpRes.UnitId       
        
        LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpRes.PersonalServiceListId 

        LEFT JOIN tmpPersonalService ON tmpPersonalService.MemberId        = tmpRes.MemberId
                                    AND tmpPersonalService.PositionId      = tmpRes.PositionId
                                    AND COALESCE (tmpPersonalService.PositionLevelId,0) = COALESCE (tmpRes.PositionLevelId,0)
                                    AND tmpPersonalService.PersonalServiceListId = tmpRes.PersonalServiceListId
                                    --PositionLevel нет в мастере PersonalService

        LEFT JOIN Movement AS Movement_PersonalService ON Movement_PersonalService.Id = tmpPersonalService.MovementId 
   ;




END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.03.24         *
*/

-- тест
-- SELECT * from gpReport_PersonalGroupSummAdd (inOperDate:= '01.04.2024'::TDateTime, inUnitId := 0 , inSession := zfCalc_UserAdmin());