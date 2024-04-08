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
-- SELECT * from gpReport_PersonalGroupSummAdd (inOperDate:= '01.02.2024'::TDateTime, inUnitId := 0 , inSession := zfCalc_UserAdmin());