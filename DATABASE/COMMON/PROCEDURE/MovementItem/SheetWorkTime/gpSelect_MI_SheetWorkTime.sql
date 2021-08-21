-- Function: gpSelect_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inisErased    Boolean   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor;
          cur2 refcursor;
          cur3 refcursor;
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbQueryText2 Text;
          vbFieldNameText Text;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     
     vbStartDate := DATE_TRUNC ('MONTH', inDate);
     vbEndDate   := DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
     
     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate;

     CREATE TEMP TABLE tmpDateOut_All ON COMMIT DROP AS
        WITH
        -- сотрудники дата приема , увольнения
        tmpList AS (SELECT Object_Personal_View.MemberId
                         , Object_Personal_View.PersonalId
                         , Object_Personal_View.PositionId
                         , Object_Personal_View.DateIn
                         , Object_Personal_View.DateOut
                    FROM Object_Personal_View
                    WHERE ((Object_Personal_View.DateOut >= vbStartDate AND Object_Personal_View.DateOut <= vbEndDate)
                        OR (Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate))
                      AND Object_Personal_View.UnitId = inUnitId
             -- and MemberId IN (3119489, 4507324)
                   )
        --
        SELECT tmpList.MemberId
             , tmpList.PersonalId
             , tmpList.PositionId
             , tmpOperDate.OperDate
             , 12918                                         AS WorkTimeKindId 
             , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
        FROM tmpOperDate
             LEFT JOIN tmpList ON tmpList.DateOut < tmpOperDate.OperDate
                               OR tmpList.DateIn > tmpOperDate.OperDate
             LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                    ON ObjectString_WorkTimeKind_ShortName.ObjectId = 12918 --  уволен  Х
                                   AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName();

     -- все данные за месяц
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            WITH
            tmpMovement AS (SELECT tmpOperDate.operdate
                               --, CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE MI_SheetWorkTime.Amount END AS Amount
                                 , MI_SheetWorkTime.Amount
                                 , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                 , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                 , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                 , COALESCE (ObjectBoolean_NoSheetCalc.ValueData, FALSE) ::Boolean AS isNoSheetCalc
                                 , COALESCE(MIObject_StorageLine.ObjectId, 0)    AS StorageLineId
                                 , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                 , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS ObjectId
                                 , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                                 , CASE WHEN MI_SheetWorkTime.isErased = TRUE THEN 0 ELSE 1 END AS isErased
                                 , CASE WHEN ObjectFloat_WorkTimeKind_Tax.ValueData > 0 AND COALESCE (MI_SheetWorkTime.Amount, 0) <> 0 AND MIObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_Quit()
                                             THEN zc_Color_GreenL()
                                        WHEN COALESCE (MI_SheetWorkTime.Amount, 0) <> 0 AND MIObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_Quit()
                                             THEN 13816530 -- светло серый  15395562
                                        WHEN tmpCalendar.isHoliday = TRUE THEN zc_Color_GreenL()
                                        WHEN tmpCalendar.Working = FALSE THEN zc_Color_Yelow()
                                        ELSE zc_Color_White()
                                   END AS Color_Calc
                                   --  выходн дни - желтым фоном + праздничные - зеленым, определяется в zc_Object_Calendar
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
                                 LEFT JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                  ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
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
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetCalc
                                                         ON ObjectBoolean_NoSheetCalc.ObjectId = COALESCE(MIObject_PositionLevel.ObjectId, 0)
                                                        AND ObjectBoolean_NoSheetCalc.DescId = zc_ObjectBoolean_PositionLevel_NoSheetCalc()

                                 LEFT JOIN gpSelect_Object_Calendar (vbStartDate, vbEndDate, inSession) AS tmpCalendar ON tmpCalendar.Value = tmpOperDate.OperDate
                            WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                            )
            -- связываем даты до приема, после увольнения с текущими
          , tmpDateOut AS (SELECT tmpDateOut_All.OperDate
                                , tmpDateOut_All.MemberId
                                , tmpDateOut_All.PositionId
                                , tmpMI.PositionLevelId
                                , tmpMI.StorageLineId
                                , tmpMI.PersonalGroupId
                                , zc_Color_White() AS Color_Calc
                                , tmpDateOut_All.WorkTimeKindId
                                , tmpDateOut_All.ShortName
                           FROM tmpDateOut_All
                                INNER JOIN (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, PositionLevelId, StorageLineId, PersonalGroupId 
                                            FROM tmpMovement AS tmpMI
                                           ) AS tmpMI ON tmpMI.MemberId   = tmpDateOut_All.MemberId
                                                     AND tmpMI.PositionId = tmpDateOut_All.PositionId
--                           WHERE 1=0
                           )
            -- объединяем даты увольнения и рабочие
            -- рабочий график
            SELECT tmp.OperDate
                 , tmp.Amount :: TFloat
               --, CASE WHEN COALESCE (tmpDateOut.WorkTimeKindId, tmp.ObjectId) = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE tmp.Amount END :: TFloat AS Amount
                 , tmp.MemberId
                 , tmp.PositionId
                 , tmp.PositionLevelId
                 , tmp.isNoSheetCalc
                 , tmp.StorageLineId
                 , tmp.PersonalGroupId
                 , COALESCE (tmpDateOut.WorkTimeKindId, tmp.ObjectId) AS ObjectId
                 , COALESCE (tmpDateOut.ShortName, tmp.ShortName)     AS ShortName
                 , tmp.isErased
                 , tmp.Color_Calc 
 
            FROM tmpMovement AS tmp
                 -- если был принят не сначала месяца или уволен в течении месяца отмечаем Х
                 LEFT JOIN tmpDateOut ON tmpDateOut.OperDate   = tmp.OperDate
                                     AND tmpDateOut.MemberId   = tmp.MemberId
                                     AND tmpDateOut.PositionId = tmp.PositionId
                                     AND tmp.Amount            = 0
          UNION
            -- дни увольнения (не рабочие)
            SELECT tmp.OperDate
                 , 0 :: TFloat AS Amount
                 , tmp.MemberId
                 , tmp.PositionId
                 , tmp.PositionLevelId
                 , FALSE AS isNoSheetCalc
                 , tmp.StorageLineId
                 , tmp.PersonalGroupId
                 , tmp.WorkTimeKindId AS ObjectId
                 , tmp.ShortName
                 , 1 AS isErased
                 , tmp.Color_Calc   
            FROM tmpDateOut AS tmp
                 LEFT JOIN tmpMovement ON tmpMovement.OperDate   = tmp.OperDate
                                      AND tmpMovement.MemberId   = tmp.MemberId
                                      AND tmpMovement.PositionId = tmp.PositionId
                                      AND tmpMovement.Amount     > 0
            WHERE tmpMovement.MemberId IS NULL
           ;

     vbIndex := 0;
     -- именно так, из-за перехода времени кол-во дней может быть разное
     vbDayCount := (SELECT COUNT(*) FROM tmpOperDate);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]';
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1]::VarChar AS Value' || vbIndex ||'  '||
                                             ', DAY' || vbIndex || '[2]::Integer AS TypeId' || vbIndex ||' '||
                                             ', DAY' || vbIndex || '[3]::Integer AS Color_Calc' || vbIndex ||' ';
     END LOOP;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;


     vbQueryText := '
        SELECT Object_Member.Id             AS MemberId
               , Object_Member.ObjectCode   AS MemberCode
               , Object_Member.ValueData    AS MemberName
               , Object_Position.Id         AS PositionId
               , Object_Position.ValueData  AS PositionName
               , Object_PositionLevel.Id         AS PositionLevelId
               , Object_PositionLevel.ValueData  AS PositionLevelName
               , Object_PersonalGroup.Id         AS PersonalGroupId
               , Object_PersonalGroup.ValueData  AS PersonalGroupName
               , Object_StorageLine.Id           AS StorageLineId
               , Object_StorageLine.ValueData    AS StorageLineName
               , CASE WHEN tmp.isErased = 0 THEN TRUE ELSE FALSE END AS isErased
              -- , CASE WHEN COALESCE (tmp.Amount, 0) <> 0 THEN zc_Color_Red() ELSE 0 END AS Color_Calc1
               , tmp.Amount                      AS AmountHours
               , tmp.CountDay::TFloat  '
               || vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.MemberId, Object_Data.MemberId)               -- AS MemberId
                                               , COALESCE (Movement_Data.PositionId, Object_Data.PositionId)           -- AS PositionId
                                               , COALESCE (Movement_Data.PositionLevelId, Object_Data.PositionLevelId) -- AS PositionLevelId
                                               , COALESCE (Movement_Data.PersonalGroupId, Object_Data.PersonalGroupId) -- AS PersonalGroupId
                                               , COALESCE (Movement_Data.StorageLineId, Object_Data.StorageLineId)     -- AS PositionLevelId
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.OperDate, Object_Data.OperDate) AS OperDate
                                         , ARRAY[(zfCalc_ViewWorkHour (COALESCE(Movement_Data.Amount, 0), COALESCE (Movement_Data.ShortName, ObjectString_WorkTimeKind_ShortName.ValueData))) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId,  COALESCE (tmpDateOut_All.WorkTimeKindId, 0)) :: VarChar
                                               , COALESCE (Movement_Data.Color_Calc, zc_Color_White()) :: VarChar
                                                ] :: TVarChar
                                    FROM (WITH tmpAll AS (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId
                                                               , tmpOperDate.OperDate
                                                          FROM (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId FROM tmpMI) AS tmpMI
                                                               CROSS JOIN tmpOperDate
                                                         )
                                          SELECT tmpAll.MemberId
                                               , tmpAll.PositionId
                                               , tmpAll.PositionLevelId
                                               , tmpAll.PersonalGroupId
                                               , tmpAll.StorageLineId
                                               , tmpAll.OperDate
                                               , tmpMI.Amount, tmpMI.ShortName
                                               , COALESCE (tmpMI.ObjectId, 0) AS ObjectId
                                               , COALESCE (tmpMI.Color_Calc, zc_Color_White()) AS Color_Calc
                                          FROM tmpAll
                                               LEFT JOIN tmpMI ON tmpMI.OperDate        = tmpAll.OperDate
                                                              AND tmpMI.MemberId        = tmpAll.MemberId
                                                              AND tmpMI.PositionId      = tmpAll.PositionId
                                                              AND tmpMI.PositionLevelId = tmpAll.PositionLevelId
                                                              AND tmpMI.PersonalGroupId = tmpAll.PersonalGroupId
                                                              AND tmpMI.StorageLineId   = tmpAll.StorageLineId
                                                              AND (tmpMI.isErased = 1 OR ' || inisErased :: TVarChar || ' = TRUE)
                                         ) AS Movement_Data
                                        FULL JOIN
                                         (SELECT tmpOperDate.OperDate, -- 0,
                                                 COALESCE(MemberId, 0) AS MemberId,
                                                 COALESCE(ObjectLink_Personal_Position.ChildObjectId, 0) AS PositionId,
                                                 COALESCE(ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId,
                                                 COALESCE(ObjectLink_Personal_PersonalGroup.ChildObjectId, 0)  AS PersonalGroupId,
                                                 COALESCE(Object_Personal_View.StorageLineId, 0)              AS StorageLineId
                                            FROM tmpOperDate, Object_Personal_View
                                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                                      ON ObjectLink_Personal_Position.ObjectId = Object_Personal_View.PersonalId
                                                                     AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                                      ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal_View.PersonalId
                                                                     AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                      ON ObjectLink_Personal_Unit.ObjectId = Object_Personal_View.PersonalId
                                                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                                      ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal_View.PersonalId
                                                                     AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                            WHERE Object_Personal_View.isErased = FALSE
                                              AND ObjectLink_Personal_Unit.ChildObjectId = ' || inUnitId :: TVarChar ||
                                        ') AS Object_Data
                                           ON Object_Data.OperDate = Movement_Data.OperDate
                                          AND Object_Data.MemberId = Movement_Data.MemberId
                                          AND Object_Data.PositionId = Movement_Data.PositionId
                                          AND Object_Data.PositionLevelId = Movement_Data.PositionLevelId
                                          AND Object_Data.PersonalGroupId = Movement_Data.PersonalGroupId
                                          AND Object_Data.StorageLineId = Movement_Data.StorageLineId

                                        LEFT JOIN tmpDateOut_All ON tmpDateOut_All.OperDate           = Object_Data.OperDate
                                                                AND tmpDateOut_All.MemberId           = Object_Data.MemberId
                                                                AND tmpDateOut_All.PositionId         = Object_Data.PositionId
                                                                AND COALESCE(Movement_Data.Amount, 0) = 0
                                        LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                                               ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpDateOut_All.WorkTimeKindId
                                                              AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()

                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.Key[1]
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.Key[3]
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]
         LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = D.Key[5]
         LEFT JOIN (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.isErased
                         , Sum (tmpMI.Amount) AS Amount
                         , Sum (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) AS CountDay 
                    FROM tmpMI
                    WHERE tmpMI.isErased = 1 OR ' || inisErased :: TVarChar || ' = TRUE
                    GROUP BY tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.isErased, tmpMI.StorageLineId
                   ) AS tmp ON tmp.MemberId = D.Key[1]
                           AND tmp.PositionId = D.Key[2]
                           AND tmp.PositionLevelId = D.Key[3]
                           AND tmp.PersonalGroupId = D.Key[4]
                           AND tmp.StorageLineId = D.Key[5]
        ';

     vbQueryText2 := '
        SELECT tmp.ValueData    AS Name
             , tmp.TotalAmount ::TFloat
        '
               || vbFieldNameText ||
        '
        FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[Movement_Data.ObjectId        -- AS MemberId
                                                ] :: Integer[]
                                         , Movement_Data.OperDate AS OperDate
                                         , ARRAY[ CAST (COALESCE(Movement_Data.Amount, 0)  AS NUMERIC (16,0)) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId, zc_Enum_WorkTimeKind_Work()) :: VarChar
                                                ] :: TVarChar
                                    FROM (--кол-во часов
                                          SELECT tmpOperDate.operdate
                                               , SUM (tmpMI.Amount) AS Amount
                                               , 1  AS ObjectId
                                          FROM tmpOperDate
                                               JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                         AND COALESCE (tmpMI.Amount,0) <> 0
                                                         AND tmpMI.isNoSheetCalc = FALSE
                                           Group by tmpOperDate.operdate
                                        UNION
                                          -- кол-во смен 
                                          SELECT tmpOperDate.operdate
                                               , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) AS Amount
                                               , 2  AS ObjectId
                                          FROM tmpOperDate
                                              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                        AND tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())
                                           Group by tmpOperDate.operdate
                                        UNION
                                          -- Кол-во шт.ед
                                          SELECT tmpOperDate.operdate
                                               , COUNT (MemberId) AS Amount
                                               , 3  AS ObjectId
                                          FROM tmpOperDate
                                              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                        --AND COALESCE (tmpMI.Amount,0) <> 0
                                                          AND tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())
                                                          AND tmpMI.isNoSheetCalc = FALSE
                                           Group by tmpOperDate.operdate
                                        UNION
                                          -- Кол-во БЛ
                                          SELECT tmpOperDate.operdate
                                               , SUM (1) AS Amount
                                               , 4  AS ObjectId
                                          FROM tmpOperDate
                                              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                        AND tmpMI.ObjectId IN ( zc_Enum_WorkTimeKind_Hospital(), zc_Enum_WorkTimeKind_HospitalDoc())
                                           Group by tmpOperDate.operdate
                                        UNION
                                          -- Кол-во отпуска
                                          SELECT tmpOperDate.operdate
                                               , SUM (1) AS Amount
                                               , 5  AS ObjectId
                                          FROM tmpOperDate
                                              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Holiday()
                                                        -- AND COALESCE (tmpMI.Amount,0) <> 0
                                           Group by tmpOperDate.operdate
                                        UNION
                                          -- Кол-во прогулов
                                          SELECT tmpOperDate.operdate
                                               , SUM (1) AS Amount
                                               , 6  AS ObjectId
                                          FROM tmpOperDate
                                              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                                                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Skip()
                                                       -- AND COALESCE (tmpMI.Amount,0) <> 0
                                           Group by tmpOperDate.operdate
                                        ) AS Movement_Data
                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
FULL JOIN (SELECT 1 AS Id, ''1.кол-во часов''    AS ValueData, (SELECT SUM (tmpMI.Amount) FROM tmpMI WHERE COALESCE (tmpMI.Amount,0) <> 0 AND tmpMI.isNoSheetCalc = FALSE) :: TFloat AS TotalAmount
     UNION SELECT 2 AS Id, ''2.кол-во смен''     AS ValueData, (SELECT SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) FROM tmpMI WHERE tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())) :: TFloat AS TotalAmount
     UNION SELECT 3 AS Id, ''3.Кол-во шт.ед''    AS ValueData, (SELECT COUNT (tmpMI.MemberId) FROM tmpMI WHERE tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff()) AND tmpMI.isNoSheetCalc = FALSE) :: TFloat AS TotalAmount
     UNION SELECT 4 AS Id, ''4.Кол-во БЛ''       AS ValueData, (SELECT SUM (1) FROM tmpMI WHERE tmpMI.ObjectId IN ( zc_Enum_WorkTimeKind_Hospital(), zc_Enum_WorkTimeKind_HospitalDoc())) :: TFloat AS TotalAmount
     UNION SELECT 5 AS Id, ''5.Кол-во отпуска''  AS ValueData, (SELECT SUM (1) FROM tmpMI WHERE tmpMI.ObjectId = zc_Enum_WorkTimeKind_Holiday()) :: TFloat AS TotalAmount
     UNION SELECT 6 AS Id, ''6.Кол-во прогулов'' AS ValueData, (SELECT SUM (1) FROM tmpMI WHERE tmpMI.ObjectId = zc_Enum_WorkTimeKind_Skip()) :: TFloat AS TotalAmount
           )AS tmp ON tmp.Id = D.Key[1]
         ';
     OPEN cur2 FOR EXECUTE vbQueryText;
     RETURN NEXT cur2;

     -- 1)кол-во часов 2)кол-во смен 3)Кол-во шт.ед 4)Кол-во отпуска 5)Кол-во прогулов
     OPEN cur3 FOR EXECUTE vbQueryText2; 
     RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.21         *
 23.01.20         *
 25.05.17         * StorageLineId
 25.03.16         * AmountHours
 20.01.16         *
 07.01.14                         * Replace inPersonalId <> inMemberId
 30.11.13                                        * add isErased = FALSE
 30.11.13                                        * parse
 25.11.13                         * Add PositionLevel
 25.10.13                         *
 19.10.13                         *
 05.10.13                         *
*/

/*
update  MovementItem set ObjectId = a.PersonalId
from (
select  MI_SheetWorkTime.Id, Object_Personal_View .PersonalId
from Movement
     JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
     left JOIN Object ON Object.Id = MI_SheetWorkTime.ObjectId
     left JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
     left JOIN Object_Personal_View  on Object_Personal_View .MemberId = MI_SheetWorkTime.ObjectId
where Movement.DescId = zc_Movement_SheetWorkTime()
) as a
where a.Id = MovementItem.Id
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inDate := NOW(), inUnitId:= 8465, inIsErased:= FALSE, inSession:= '5'); -- FETCH ALL "<unnamed portal 3>";

--select * from gpSelect_Object_WorkTimeKind( inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');