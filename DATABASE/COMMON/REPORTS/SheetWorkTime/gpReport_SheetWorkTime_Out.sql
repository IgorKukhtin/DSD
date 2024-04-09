-- Function: gpReport_SheetWorkTime_Out()

DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Out(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime_Out(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
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
        , WorkTimeKindId Integer
        , WorkTimeKindName TVarChar
        , ShortName TVarChar
        , OperDate TDateTime
        , DateIn TDateTime
        , DateOut TDateTime
        , Amount TFloat
        , HoursDay TFloat
        , ErrorCode Integer
        , ErrorText TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inStartDate, inEndDate, '1 DAY'::interval) OperDate;

    -- Результат
    RETURN QUERY
    WITH
    -- сотрудники дата приема , увольнения
    tmpListAll AS (SELECT Object_Personal_View.MemberId
                        , Object_Personal_View.PersonalId
                        , Object_Personal_View.PositionId
                        , Object_Personal_View.PositionLevelId
                        , Object_Personal_View.DateIn
                        , Object_Personal_View.DateOut
                        , Object_Personal_View.UnitId
                        , Object_Personal_View.isMain
                   FROM Object_Personal_View
                   WHERE (Object_Personal_View.UnitId = inUnitId OR inUnitId = 0)
                   )
  -- принятые и уволенные
  , tmpList AS (SELECT tmpListAll.*
                FROM tmpListAll
                WHERE ((tmpListAll.DateOut >= inStartDate AND tmpListAll.DateOut <= inEndDate)
                    OR (tmpListAll.DateIn >= inStartDate AND tmpListAll.DateIn <= inEndDate))
               )

  , tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                          , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                          , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                          , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                          , ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId AS StaffListSummKindId
                     FROM OBJECT AS Object_StaffList
                           INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                 ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
                           LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                                ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                               AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()

                           LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                                ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                               AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit() 
                           LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                                 ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                                AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()

                           LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                                                ON ObjectLink_StaffListSumm_StaffList.ChildObjectId = Object_StaffList.Id
                                               AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()

                           LEFT JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffListSummKind
                                                ON ObjectLink_StaffListSumm_StaffListSummKind.ObjectId = ObjectLink_StaffListSumm_StaffList.ObjectId
                                               AND ObjectLink_StaffListSumm_StaffListSummKind.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()
                           -- ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId
                      WHERE Object_StaffList.DescId = zc_Object_StaffList()
                        AND Object_StaffList.isErased = False
                      GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                             , ObjectLink_StaffList_Position.ChildObjectId
                             , ObjectLink_StaffList_PositionLevel.ChildObjectId
                             , ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId
                      HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                    )

   -- рабочее время из табеля
  , tmpMovement AS (SELECT tmpOperDate.operdate
                         , MI_SheetWorkTime.Amount
                         , CASE WHEN COALESCE(MIObject_PositionLevel.ObjectId, 0) = 3970383 THEN 2 * MI_SheetWorkTime.Amount ELSE MI_SheetWorkTime.Amount END AS Amount_calc
                         , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                         , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                         , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                         , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                         , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS WorkTimeKindId
                         , COALESCE (ObjectFloat_WorkTimeKind_Tax.ValueData,0) AS WorkTimeKind_Tax
                         , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                         , MovementLinkObject_Unit.ObjectId AS UnitId
                    FROM tmpOperDate
                         JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                      AND Movement.DescId = zc_Movement_SheetWorkTime()
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                         JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                         LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_Position.DescId = zc_MILinkObject_Position()
                         LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                         LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                          ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                         LEFT JOIN ObjectFloat AS ObjectFloat_WorkTimeKind_Tax
                                               ON ObjectFloat_WorkTimeKind_Tax.ObjectId = CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                              AND ObjectFloat_WorkTimeKind_Tax.DescId = zc_ObjectFloat_WorkTimeKind_Tax()

                         LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                                ON ObjectString_WorkTimeKind_ShortName.ObjectId = CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                               AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                         LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                    WHERE (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                          )


  , tmpError AS (SELECT 1 AS ErrorCode, 'дата приема' AS ErrorText
           UNION SELECT 2 AS ErrorCode, 'дата увольнения' AS ErrorText
           UNION SELECT 3 AS ErrorCode, 'факт часов меньше смены' AS ErrorText
           UNION SELECT 4 AS ErrorCode, 'факт часов больше смены' AS ErrorText
           UNION SELECT 5 AS ErrorCode, 'больше 24 часов' AS ErrorText
           UNION SELECT 6 AS ErrorCode, 'не протабелированны' AS ErrorText
           UNION SELECT 7 AS ErrorCode, 'Не начислена ЗП' AS ErrorText
           UNION SELECT 8 AS ErrorCode, 'меньше нормы' AS ErrorText
           UNION SELECT 9 AS ErrorCode, 'больше нормы' AS ErrorText
                 )
  , tmpRes1 AS (-- ошибки 1, 2
               SELECT tmp.operdate
                    , tmp.Amount
                    , tmp.Amount_calc
                    , tmp.MemberId
                    , tmp.PositionId
                    , tmp.PositionLevelId
                    , tmp.PersonalGroupId
                    , tmp.WorkTimeKindId
                    , tmp.ShortName
                    , tmp.UnitId
                    , COALESCE (tmpList.DateIn, tmpList_out.DateIn) AS DateIn
                    , COALESCE (tmpList.DateOut, tmpList_out.DateOut) AS DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                    , CASE WHEN tmpList.MemberId IS NOT NULL THEN 1
                           WHEN tmpList_out.MemberId IS NOT NULL THEN 2
                      END AS ErrorCode
               FROM tmpMovement AS tmp
                 -- если был принят не сначала месяца или уволен в течении месяца отмечаем Х
                 --
                 LEFT JOIN tmpList ON tmpList.DateIn   > tmp.OperDate
                                  AND tmpList.MemberId = tmp.MemberId
                                  AND tmpList.PositionId = tmp.PositionId
                                  AND COALESCE (tmpList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                  AND tmpList.UnitId     = tmp.UnitId
                                  AND tmp.Amount            <> 0
                 LEFT JOIN tmpList AS tmpList_out
                                   ON tmpList_out.DateOut   < tmp.OperDate  -- <=
                                  AND tmpList_out.MemberId = tmp.MemberId
                                  AND tmpList_out.PositionId = tmp.PositionId
                                  AND COALESCE (tmpList_out.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                  AND tmpList_out.UnitId     = tmp.UnitId
                                  AND tmp.Amount            <> 0

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL
               WHERE tmpList.MemberId IS NOT NULL or tmpList_out.MemberId IS NOT NULL
               )

  , tmpRes2 AS (--ошибки 3,4
               SELECT tmp.operdate
                    , tmp.Amount
                    , tmp.Amount_calc
                    , tmp.MemberId
                    , tmp.PositionId
                    , tmp.PositionLevelId
                    , tmp.PersonalGroupId
                    , tmp.WorkTimeKindId
                    , tmp.ShortName
                    , tmp.UnitId
                    , tmpListAll.DateIn
                    , tmpListAll.DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                    , CASE WHEN tmp.Amount_calc < COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 3
                           WHEN tmp.Amount_calc > COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 4
                      END AS ErrorCode
               FROM tmpMovement AS tmp
                 LEFT JOIN tmpListAll ON tmpListAll.MemberId = tmp.MemberId
                                     AND tmpListAll.PositionId = tmp.PositionId
                                     AND COALESCE (tmpListAll.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                     AND tmpListAll.UnitId     = tmp.UnitId

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL
               WHERE (tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_Work()
                                          , zc_Enum_WorkTimeKind_WorkD()
                                          , zc_Enum_WorkTimeKind_WorkN()
                                          , zc_Enum_WorkTimeKind_WorkDayOff()
                                          , zc_Enum_WorkTimeKind_RemoteAccess()
                                          , zc_Enum_WorkTimeKind_Trainee50()
                                          )
                      OR tmp.WorkTimeKind_Tax <> 0)
                 AND tmp.Amount_calc <> COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0)
               )
/*
Проверка продолжительности смен сотрудников (больше или меньше нормы), у которых при начислении ЗП выставлен Тип суммы:
	6.9.1. Доплата за 1 день на человека; --12110
	6.9.2 Фонд за месяц (по дням);        --582717
*/               
  , tmpRes2_2 AS (--ошибки 8,9
                  SELECT tmp.operdate
                       , tmp.Amount
                       , tmp.Amount_calc
                       , tmp.MemberId
                       , tmp.PositionId
                       , tmp.PositionLevelId
                       , tmp.PersonalGroupId
                       , tmp.WorkTimeKindId
                       , tmp.ShortName
                       , tmp.UnitId
                       , tmpListAll.DateIn
                       , tmpListAll.DateOut
                       , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                       , CASE WHEN tmp.Amount_calc < COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 8
                              WHEN tmp.Amount_calc > COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 9
                         END AS ErrorCode
                  FROM tmpMovement AS tmp
                    LEFT JOIN tmpListAll ON tmpListAll.MemberId = tmp.MemberId
                                        AND tmpListAll.PositionId = tmp.PositionId
                                        AND COALESCE (tmpListAll.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                        AND tmpListAll.UnitId     = tmp.UnitId
   
                    LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                          AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                          AND tmpStaffList.UnitId     = tmp.UnitId
                    --второй раз без подразделения
                    LEFT JOIN tmpStaffList AS tmpStaffList2
                                           ON tmpStaffList2.PositionId = tmp.PositionId
                                          AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                          AND tmpStaffList.PositionId  IS  NULL
                  WHERE (tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_Work()
                                             , zc_Enum_WorkTimeKind_WorkD()
                                             , zc_Enum_WorkTimeKind_WorkN()
                                             , zc_Enum_WorkTimeKind_WorkDayOff()
                                             , zc_Enum_WorkTimeKind_RemoteAccess()
                                             , zc_Enum_WorkTimeKind_Trainee50()
                                             )
                         OR tmp.WorkTimeKind_Tax <> 0)
                    AND tmp.Amount_calc <> COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0)
                    AND COALESCE (tmpStaffList.StaffListSummKindId, tmpStaffList2.StaffListSummKindId,0) IN (12110, 582717)
               )


/*
не выводим (больше/меньше продолжительности смены и больше 24 часов) для должностей, у которых в графе «Разряд» указано:
		доплата за погр.убоя ручная;   --1673855
		доплата за погр.убоя погрузчик;--1673854
		с доплатой за вождение кары;   --3515083
		з доплатою за мийку скотовозів;--4158388
		доплата за обрыв жира;         --1673853
		с доплатой за клубочки;        --12465
		0,5 ставки                     --3970383

*/
  , tmpRes3 AS (--ошибки 5
               SELECT tmp.operdate
                    , SUM (tmp.Amount)  AS Amount
                    , SUM (tmp.Amount_calc) AS Amount_calc
                    , tmp.MemberId
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.PositionId ELSE 0 END)      AS PositionId
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.PositionLevelId ELSE 0 END) AS PositionLevelId
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.PersonalGroupId ELSE 0 END) AS PersonalGroupId
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.WorkTimeKindId ELSE 0 END)  AS WorkTimeKindId
                    
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.ShortName ELSE '' END) ::TVarChar     AS ShortName
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmp.UnitId ELSE 0 END)          AS UnitId
                         
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmpListAll.DateIn ELSE NULL END)  :: TDateTime AS DateIn
                    , MAX (CASE WHEN tmpListAll.isMain = TRUE THEN tmpListAll.DateOut ELSE NULL END) :: TDateTime AS DateOut
                    , MAX (COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0)) AS HoursDay
                    , 5 AS ErrorCode
               FROM tmpMovement AS tmp
                 LEFT JOIN tmpListAll ON tmpListAll.MemberId = tmp.MemberId
                                     AND tmpListAll.PositionId = tmp.PositionId
                                     AND COALESCE (tmpListAll.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                     AND tmpListAll.UnitId     = tmp.UnitId

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL
               WHERE (tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_Work()
                                          , zc_Enum_WorkTimeKind_WorkD()
                                          , zc_Enum_WorkTimeKind_WorkN()
                                          , zc_Enum_WorkTimeKind_WorkDayOff()
                                          , zc_Enum_WorkTimeKind_RemoteAccess()
                                          , zc_Enum_WorkTimeKind_Trainee50()
                                          )
                     OR tmp.WorkTimeKind_Tax <> 0)
                 AND tmp.PositionLevelId NOT IN (1673855,1673854,3515083,4158388,1673853,12465,3970383)
               GROUP BY tmp.operdate
                      , tmp.MemberId
               HAVING SUM (tmp.Amount_calc) > 24
               )
  -- список всех сотрудников по основной должности работающих в тек. периоде
  , tmpPersonal_work AS (SELECT tmpListAll.*
                         FROM tmpListAll
                         WHERE tmpListAll.isMain = TRUE
                         AND ((tmpListAll.DateIn BETWEEN inStartDate AND inEndDate)
                           OR (tmpListAll.DateOut BETWEEN inStartDate AND inEndDate)
                           OR (tmpListAll.DateIn < inStartDate
                           AND tmpListAll.DateOut > inEndDate)
                             )
                         )

  , tmpRes4 AS (--ошибки 6
               SELECT NULL ::TDateTime AS OperDate
                    , 0  ::TFloat AS Amount
                    , 0  ::TFloat AS Amount_calc
                    , tmpPersonal_work.MemberId
                    , tmpPersonal_work.PositionId
                    , tmpPersonal_work.PositionLevelId
                    , 0       AS PersonalGroupId
                    , 0       AS WorkTimeKindId
                    , '' ::TVarChar     AS ShortName
                    , tmpPersonal_work.UnitId
                    , tmpPersonal_work.DateIn
                    , tmpPersonal_work.DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) ::TFloat AS HoursDay
                    , 6 AS ErrorCode
               FROM tmpPersonal_work
                 LEFT JOIN tmpMovement AS tmp
                                       ON tmp.MemberId = tmpPersonal_work.MemberId
                                      AND tmp.PositionId = tmpPersonal_work.PositionId
                                      AND COALESCE (tmp.PositionLevelId,0) = COALESCE (tmpPersonal_work.PositionLevelId,0)
                                      AND tmp.UnitId     = tmpPersonal_work.UnitId
                                     
                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpPersonal_work.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpPersonal_work.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmpPersonal_work.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmpPersonal_work.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpPersonal_work.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL
               WHERE tmp.MemberId IS NULL
               )

  -- начисление ЗП
  , tmpMov AS (SELECT MovementDate_ServiceDate.MovementId             AS Id
               FROM MovementDate AS MovementDate_ServiceDate
                    JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                 AND Movement.DescId = zc_Movement_PersonalService()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
               WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                 AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
               )
  , tmpPersonalService AS (SELECT MovementItem.ObjectId                    AS PersonalId
                                , MILinkObject_Unit.ObjectId               AS UnitId
                                , MILinkObject_Position.ObjectId           AS PositionId
                                , MILinkObject_Member.ObjectId             AS MemberId
                                , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                 ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                                 ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                     ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                           WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.isErased = FALSE
                             AND COALESCE (MovementItem.Amount,0) <> 0
                             AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                           )
                             
  , tmpRes5 AS (-- ошибки 7 - Не начислена ЗП
               SELECT tmp.operdate
                    , tmp.Amount
                    , tmp.Amount_calc
                    , tmp.MemberId
                    , tmp.PositionId
                    , tmp.PositionLevelId
                    , tmp.PersonalGroupId
                    , tmp.WorkTimeKindId
                    , tmp.ShortName
                    , tmp.UnitId
                    , tmp.DateIn
                    , tmp.DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                    , 7 AS ErrorCode
               FROM (SELECT MIN (tmp.OperDate) ::TDateTime AS OperDate
                          , MAX (tmp.Amount)      ::TFloat AS Amount
                          , MAX (tmp.Amount_calc) ::TFloat AS Amount_calc
                          , tmp.MemberId
                          , tmp.PositionId
                          , tmp.PositionLevelId
                          , tmp.PersonalGroupId
                          , 0 AS WorkTimeKindId
                          , '' :: TVarChar AS ShortName
                          , tmp.UnitId
                          , tmpListAll.DateIn
                          , tmpListAll.DateOut
                     FROM tmpMovement AS tmp
                          INNER JOIN tmpListAll ON tmpListAll.MemberId = tmp.MemberId
                                               AND tmpListAll.PositionId = tmp.PositionId
                                               AND COALESCE (tmpListAll.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                               AND tmpListAll.UnitId     = tmp.UnitId
                                               AND tmpListAll.isMain     = TRUE
                     GROUP BY tmp.MemberId
                            , tmp.PositionId
                            , tmp.PositionLevelId
                            , tmp.PersonalGroupId
                            , tmp.UnitId
                            , tmpListAll.DateIn
                            , tmpListAll.DateOut
                     ) AS tmp

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.PositionId  IS  NULL                                       
                 --
                 LEFT JOIN tmpPersonalService ON tmpPersonalService.MemberId_Personal = tmp.MemberId
                                             AND tmpPersonalService.PositionId        = tmp.PositionId
                                             AND tmpPersonalService.UnitId            = tmp.UnitId
               WHERE tmpPersonalService.MemberId_Personal IS NULL
               )
   --
  , tmpRes AS (SELECT tmpRes1.*
               FROM tmpRes1
             UNION
               SELECT tmpRes2.*
               FROM tmpRes2
            UNION
               SELECT tmpRes3.*
               FROM tmpRes3
              UNION
               SELECT tmpRes4.*
               FROM tmpRes4
             UNION
               SELECT tmpRes5.*
               FROM tmpRes5
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
        , Object_WorkTimeKind.Id          AS WorkTimeKindId
        , Object_WorkTimeKind.ValueData   AS WorkTimeKindName
        , tmpRes.ShortName ::TVarChar
        , tmpRes.OperDate :: TDateTime
        , tmpRes.DateIn
        , tmpRes.DateOut
        , tmpRes.Amount   ::TFloat
        , tmpRes.HoursDay ::TFloat
        
        , tmpError.ErrorCode ::Integer
        , tmpError.ErrorText ::TVarChar
        
   FROM tmpRes
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpRes.MemberId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpRes.PositionId
        LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpRes.PositionLevelId
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpRes.PersonalGroupId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpRes.UnitId
        LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpRes.WorkTimeKindId
        LEFT JOIN tmpError ON tmpError.ErrorCode = tmpRes.ErrorCode
   ;




END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.21         *
*/

-- тест
---  SELECT * from gpReport_SheetWorkTime_Out (inStartDate:= '01.06.2021'::TDateTime, inEndDate:= '30.06.2021'::TDateTime, inUnitId := 8459 , inSession := zfCalc_UserAdmin());
--select * from gpReport_SheetWorkTime_Out(inStartDate := ('01.06.2021')::TDateTime , inEndDate := ('30.06.2021')::TDateTime , inUnitId := 8438 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e'::TVarChar);