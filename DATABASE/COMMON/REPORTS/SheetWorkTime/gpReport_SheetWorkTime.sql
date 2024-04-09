-- Function: gpReport_SheetWorkTime()

--DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , --
    IN inMemberId    Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE cur1 refcursor; 
          cur2 refcursor;
          cur3 refcursor;
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText  Text;
          vbQueryText2 Text;
          vbFieldNameText Text;
          vbUnits Text;
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    SELECT 
        STRING_AGG(T0.Id::TVarChar,',')
    INTO
        vbUnits
    FROM 
        gpSelect_Object_UnitSheetWorkTime (inSession) AS T0
    WHERE
        COALESCE(inUnitId,0) = 0
        OR
        T0.Id = inUnitId;

    IF COALESCE(vbUnits,'') = ''
    THEN
        vbUnits := '(0)';
    ELSE
        vbUnits := '('||vbUnits||')';
    END IF;


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inStartDate, inEndDate, '1 DAY'::interval) OperDate;


     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
       SELECT tmpOperDate.operdate
            , MI_SheetWorkTime.Amount
            , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
            , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
            , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
            , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
            , MIObject_WorkTimeKind.ObjectId
            , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
            , MovementLinkObject_Unit.ObjectId              AS UnitId
            , COALESCE (ObjectBoolean_NoSheetCalc.ValueData, FALSE) ::Boolean AS isNoSheetCalc
            , CASE WHEN -- ЦЕХ упаковки
                        -- inUnitId = 8451
                        MovementLinkObject_Unit.ObjectId = 8451
                        THEN CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE COALESCE (MIObject_WorkTimeKind.ObjectId, 0) END
                   ELSE 0
              END AS WorkTimeKindId_key
       FROM tmpOperDate
            JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                         AND Movement.DescId = zc_Movement_SheetWorkTime()
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                   AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId =0)
            JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                 AND MI_SheetWorkTime.isErased = FALSE
            LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                             ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_Position.DescId = zc_MILinkObject_Position() 
            LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                             ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
            LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                             ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind() 
            LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName 
                                             ON ObjectString_WorkTimeKind_ShortName.ObjectId = MIObject_WorkTimeKind.ObjectId  
                                            AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()       
            LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                             ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetCalc
                                    ON ObjectBoolean_NoSheetCalc.ObjectId = COALESCE(MIObject_PositionLevel.ObjectId, 0)
                                   AND ObjectBoolean_NoSheetCalc.DescId = zc_ObjectBoolean_PositionLevel_NoSheetCalc()
       WHERE (COALESCE(MI_SheetWorkTime.ObjectId, 0) = inMemberId OR inMemberId = 0)
          AND COALESCE (MIObject_WorkTimeKind.ObjectId,0) <> 0
     ;

     CREATE TEMP TABLE tmpPersonal ON COMMIT DROP AS
       SELECT *
       FROM (SELECT Object_Personal_View.MemberId
                  , Object_Personal_View.PersonalId
                  , Object_Personal_View.PositionId
                  , Object_Personal_View.PositionLevelId
                  , Object_Personal_View.PersonalGroupId
                  , Object_Personal_View.UnitId
                  , Object_Personal_View.DateIn
                  , CASE WHEN Object_Personal_View.DateOut = zc_DateEnd() THEN NULL ELSE Object_Personal_View.DateOut END ::TDateTime AS DateOut
                  , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.UnitId, Object_Personal_View.MemberId, Object_Personal_View.PositionId, Object_Personal_View.PositionLevelId
                                       ORDER BY CASE WHEN Object_Personal_View.isErased = TRUE THEN 1 ELSE 0 END ASC
                                       ) AS Ord_find
             FROM Object_Personal_View
             WHERE (Object_Personal_View.UnitId = inUnitId OR inUnitId =0)
               AND (Object_Personal_View.MemberId = inMemberId OR inMemberId =0)
            ) AS tmp
       WHERE tmp.Ord_find = 1
      ;

     -- данные из штатного расписания
     CREATE TEMP TABLE tmpStaffList ON COMMIT DROP AS
       SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
            , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
            , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
            , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay              -- 2.Дневной пл.ч. на человека
            , Object_StaffListSummKind.ValueData                AS StaffListSummKindName --тип суммы
       FROM Object AS Object_StaffList
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
                                 AND 1=0
             LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId

        WHERE Object_StaffList.DescId = zc_Object_StaffList()
          AND Object_StaffList.isErased = False
        GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
               , ObjectLink_StaffList_Position.ChildObjectId
               , ObjectLink_StaffList_PositionLevel.ChildObjectId
               , Object_StaffListSummKind.ValueData
        HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
        ;

  -- данные для итогов
  CREATE TEMP TABLE tmpTotal ON COMMIT DROP AS
    SELECT tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.UnitId, tmp.WorkTimeKindId_key
          , SUM (COALESCE (tmp.Amount,0)) ::TFLoat AS Amount
          , tmp.ObjectId
    FROM (--кол-во часов
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
               , SUM (COALESCE (tmpMI.Amount,0)) AS Amount
               , 1  AS ObjectId
          FROM tmpOperDate
               JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                         AND COALESCE (tmpMI.Amount,0) <> 0
                         AND tmpMI.isNoSheetCalc = FALSE
          GROUP BY tmpOperDate.operdate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
        UNION
          -- кол-во смен 
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
               , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) AS Amount
               , 2  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
        UNION
          -- Кол-во шт.ед
          SELECT tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.UnitId, tmp.WorkTimeKindId_key
               , SUM (COALESCE (tmp.Amount,0)) AS Amount
               , 3  AS ObjectId
          FROM (SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
                     , CASE WHEN COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay) <> 0
                                THEN tmpMI.Amount / COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay)
                            ELSE 1
                       END AS Amount
                 FROM tmpOperDate
                      JOIN tmpMI ON tmpMI.OperDate = tmpOperDate.OperDate
                                     AND tmpMI.ObjectId NOT IN (zc_Enum_WorkTimeKind_Quit()
                                                              , zc_Enum_WorkTimeKind_DayOff()
                                                              , zc_Enum_WorkTimeKind_Holiday()
                                                              , zc_Enum_WorkTimeKind_Hospital()
                                                              , zc_Enum_WorkTimeKind_HolidayNoZp()
                                                              , zc_Enum_WorkTimeKind_HospitalDoc()
                                                             )
                                     AND tmpMI.isNoSheetCalc = FALSE
                                     AND COALESCE (tmpMI.Amount,0) <> 0
                      -- данные из штатного расписания
                      LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpMI.PositionId
                                            AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                            AND tmpStaffList.UnitId     = inUnitId
                      --второй раз без подразделения
                      LEFT JOIN tmpStaffList AS tmpStaffList2
                                             ON tmpStaffList2.PositionId = tmpMI.PositionId
                                            AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                            AND tmpStaffList.PositionId IS NULL
                 ) AS tmp
          GROUP BY tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.UnitId, tmp.WorkTimeKindId_key
        UNION
          -- Кол-во БЛ
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
               , SUM (1) AS Amount
               , 4  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId IN ( zc_Enum_WorkTimeKind_Hospital(), zc_Enum_WorkTimeKind_HospitalDoc())
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
        UNION
          -- Кол-во отпуска
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
               , SUM (1) AS Amount
               , 5  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Holiday()
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
        UNION
          -- Кол-во прогулов
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
               , SUM (1) AS Amount
               , 6  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Skip()
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.UnitId, tmpMI.WorkTimeKindId_key
    )AS tmp
    GROUP BY tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.UnitId, tmp.ObjectId, tmp.WorkTimeKindId_key
    ;



     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          (EXTRACT(DAY FROM tmpOperDate.OperDate))::TVarChar||'.'||(EXTRACT(MONTH FROM tmpOperDate.OperDate))::TVarChar AS ValueField
               FROM tmpOperDate;  
     RETURN NEXT cur1;

     vbIndex := 0;
     -- именно так, из-за перехода времени кол-во дней может быть разное
     vbDayCount := (SELECT count(*) 
                     FROM tmpOperDate);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] AS Value'||vbIndex||'  '||
                          ', DAY' || vbIndex || '[2]::Integer  AS TypeId'||vbIndex||' ';
     END LOOP;

     vbQueryText := '
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
               , tmpPersonal.DateIn
               , tmpPersonal.DateOut
               , tmpStaffList.HoursDay  ::TFLoat
               , tmpTotal.Amount_1 ::TFloat
               , tmpTotal.Amount_2 ::TFloat
               , tmpTotal.Amount_3 ::TFloat
               , tmpTotal.Amount_4 ::TFloat
               , tmpTotal.Amount_5 ::TFloat
               , tmpTotal.Amount_6 ::TFloat
               , tmpStaffList.StaffListSummKindName ::TVarChar
               '
               || vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[Movement_Data.MemberId                             -- AS MemberId
                                               , Movement_Data.PositionId                           -- AS PositionId
                                               , Movement_Data.PositionLevelId                      -- AS PositionLevelId
                                               , Movement_Data.PersonalGroupId                      -- AS PersonalGroupId
                                               , Movement_Data.UnitId                               -- AS UnitId
                                               , COALESCE (Movement_Data.WorkTimeKindId_key, 0)     -- AS WorkTimeKindId_key
                                                ] :: Integer[]
                                         , Movement_Data.OperDate AS OperDate
                                         , ARRAY[zfCalc_ViewWorkHour (COALESCE(Movement_Data.Amount, 0), Movement_Data.ShortName) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId, zc_Enum_WorkTimeKind_Work()) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT *
                                           FROM tmpMI
                                        ) AS Movement_Data
                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.Key[1]
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.Key[3]
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = D.Key[5]
         LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = D.Key[6]

         LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = D.Key[2]
                               AND tmpStaffList.PositionLevelId = D.Key[3]
                               AND tmpStaffList.UnitId     = D.Key[5]

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId        = D.Key[1]
                              AND tmpPersonal.PositionId      = D.Key[2]
                              AND tmpPersonal.PositionLevelId = D.Key[3]
                              AND tmpPersonal.PersonalGroupId = D.Key[4]
                              AND tmpPersonal.UnitId          = D.Key[5]

         LEFT JOIN (SELECT tmpTotal.MemberId
                         , tmpTotal.PositionId
                         , tmpTotal.PositionLevelId
                         , tmpTotal.PersonalGroupId
                         , tmpTotal.UnitId
                         , tmpTotal.WorkTimeKindId_key
                         --, tmpTotal.StorageLineId
                         , SUM (CASE WHEN tmpTotal.ObjectId = 1 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_1
                         , SUM (CASE WHEN tmpTotal.ObjectId = 2 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_2
                         , SUM (CASE WHEN tmpTotal.ObjectId = 3 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_3
                         , SUM (CASE WHEN tmpTotal.ObjectId = 4 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_4
                         , SUM (CASE WHEN tmpTotal.ObjectId = 5 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_5
                         , SUM (CASE WHEN tmpTotal.ObjectId = 6 THEN COALESCE (tmpTotal.Amount,0) ELSE 0 END) AS Amount_6
                    FROM tmpTotal
                    GROUP BY tmpTotal.MemberId
                           , tmpTotal.PositionId
                           , tmpTotal.PositionLevelId
                           , tmpTotal.PersonalGroupId
                           , tmpTotal.UnitId
                           , tmpTotal.WorkTimeKindId_key
                          -- , tmpTotal.StorageLineId
                    ) AS tmpTotal ON tmpTotal.MemberId                     = D.Key[1]
                                 AND COALESCE(tmpTotal.PositionId, 0)      = D.Key[2]
                                 AND COALESCE(tmpTotal.PositionLevelId, 0) = D.Key[3]
                                 AND COALESCE(tmpTotal.PersonalGroupId, 0) = D.Key[4]
                                 AND COALESCE(tmpTotal.UnitId, 0)          = D.Key[5]
                                 AND COALESCE(tmpTotal.WorkTimeKindId_key, 0) = D.Key[6]
                              --   AND COALESCE(tmpTotal.StorageLineId, 0)   = D.Key[5]

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
                                    FROM (SELECT tmpTotal.operdate
                                               , tmpTotal.ObjectId
                                               , SUM (tmpTotal.Amount) AS Amount
                                          FROM tmpTotal
                                          GROUP BY tmpTotal.operdate, tmpTotal.ObjectId
                                        ) AS Movement_Data
                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
        FULL JOIN (SELECT 1 AS Id, ''1.кол-во часов''    AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 1) :: TFloat AS TotalAmount
             UNION SELECT 2 AS Id, ''2.кол-во смен''     AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 2) :: TFloat AS TotalAmount
             UNION SELECT 3 AS Id, ''3.Кол-во шт.ед''    AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 3) :: TFloat AS TotalAmount
             UNION SELECT 4 AS Id, ''4.Кол-во БЛ''       AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 4) :: TFloat AS TotalAmount
             UNION SELECT 5 AS Id, ''5.Кол-во отпуска''  AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 5) :: TFloat AS TotalAmount
             UNION SELECT 6 AS Id, ''6.Кол-во прогулов'' AS ValueData, (SELECT SUM (COALESCE (tmpTotal.Amount,0)) FROM tmpTotal WHERE tmpTotal.ObjectId = 6) :: TFloat AS TotalAmount
                   )AS tmp ON tmp.Id = D.Key[1]
         ';


     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

     OPEN cur3 FOR EXECUTE vbQueryText2;  
     RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_SheetWorkTime (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 01.09.21         * add inMemberId
 07.01.14                                                          *
*/

-- тест
/* BEGIN;
  SELECT * FROM gpReport_SheetWorkTime('20150701', '20150830', 0, '5');
  fetch all "<unnamed portal 10>";
 END;*/

