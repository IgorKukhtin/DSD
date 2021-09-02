-- Function: gpReport_SheetWorkTime()

--DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime(
    IN inDateStart   TDateTime , --
    IN inDateEnd     TDateTime , --
    IN inUnitId      Integer   , --
    IN inMemberId    Integer   , --
    IN inSession     TVarChar    -- ������ ������������
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
BEGIN

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


     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inDateStart, inDateEnd, '1 DAY'::interval) OperDate;


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
     ;

     CREATE TEMP TABLE tmpPersonal ON COMMIT DROP AS
       SELECT Object_Personal_View.MemberId
            , Object_Personal_View.PersonalId
            , Object_Personal_View.PositionId
            , Object_Personal_View.PositionLevelId
            , Object_Personal_View.PersonalGroupId
            , Object_Personal_View.UnitId
            , Object_Personal_View.DateIn
            , CASE WHEN Object_Personal_View.DateOut = zc_DateEnd() THEN NULL ELSE Object_Personal_View.DateOut END ::TDateTime AS DateOut
       FROM Object_Personal_View
       WHERE (Object_Personal_View.UnitId = inUnitId OR inUnitId =0)
         AND (Object_Personal_View.MemberId = inMemberId OR inMemberId =0)
       ;

     -- ������ �� �������� ����������
     CREATE TEMP TABLE tmpStaffList ON COMMIT DROP AS
       SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
            , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
            , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
            , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay              -- 2.������� ��.�. �� ��������
            , Object_StaffListSummKind.ValueData                AS StaffListSummKindName --��� �����
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
             LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId

        WHERE Object_StaffList.DescId = zc_Object_StaffList()
          AND Object_StaffList.isErased = False
        GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
               , ObjectLink_StaffList_Position.ChildObjectId
               , ObjectLink_StaffList_PositionLevel.ChildObjectId
               , Object_StaffListSummKind.ValueData
        HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
        ;

  -- ������ ��� ������
  CREATE TEMP TABLE tmpTotal ON COMMIT DROP AS
    SELECT tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId
          , SUM (tmp.Amount) ::TFLoat AS Amount
          , tmp.ObjectId
    FROM (--���-�� �����
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
               , SUM (tmpMI.Amount) AS Amount
               , 1  AS ObjectId
          FROM tmpOperDate
               JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                         AND COALESCE (tmpMI.Amount,0) <> 0
                         AND tmpMI.isNoSheetCalc = FALSE
          GROUP BY tmpOperDate.operdate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
        UNION
          -- ���-�� ���� 
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
               , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) AS Amount
               , 2  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
        UNION
          -- ���-�� ��.��
          SELECT tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId
               , SUM (tmp.Amount) AS Amount
               , 3  AS ObjectId
          FROM (SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
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
                      -- ������ �� �������� ����������
                      LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpMI.PositionId
                                            AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                            AND tmpStaffList.UnitId     = inUnitId
                      --������ ��� ��� �������������
                      LEFT JOIN tmpStaffList AS tmpStaffList2
                                             ON tmpStaffList2.PositionId = tmpMI.PositionId
                                            AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                            AND tmpStaffList.PositionId IS NULL
                 ) AS tmp
          GROUP BY tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId
        UNION
          -- ���-�� ��
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
               , SUM (1) AS Amount
               , 4  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId IN ( zc_Enum_WorkTimeKind_Hospital(), zc_Enum_WorkTimeKind_HospitalDoc())
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
        UNION
          -- ���-�� �������
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
               , SUM (1) AS Amount
               , 5  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Holiday()
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
        UNION
          -- ���-�� ��������
          SELECT tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
               , SUM (1) AS Amount
               , 6  AS ObjectId
          FROM tmpOperDate
              JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                        AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Skip()
          GROUP BY tmpOperDate.OperDate, tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId
    )AS tmp
    GROUP BY tmp.OperDate, tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.ObjectId
    ;



     -- ���������� ��������� �������� � ����
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          (EXTRACT(DAY FROM tmpOperDate.OperDate))::TVarChar||'.'||(EXTRACT(MONTH FROM tmpOperDate.OperDate))::TVarChar AS ValueField
               FROM tmpOperDate;  
     RETURN NEXT cur1;
    
    
    
     vbIndex := 0;
     -- ������ ���, ��-�� �������� ������� ���-�� ���� ����� ���� ������
     vbDayCount := (SELECT count(*) 
                     FROM tmpOperDate);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- ������ ������� ��� ������
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] AS Value'||vbIndex||'  '||
                          ', DAY' || vbIndex || '[2]::Integer  AS TypeId'||vbIndex||' ';
     END LOOP;

     vbQueryText := '
          SELECT Object_Unit.Id             AS UnitId
               , Object_Unit.ValueData      AS UnitName
               , Object_Member.Id           AS MemberId
               , Object_Member.ObjectCode   AS MemberCode
               , Object_Member.ValueData    AS MemberName
               , Object_Position.Id         AS PositionId
               , Object_Position.ValueData  AS PositionName
               , Object_PositionLevel.Id         AS PositionLevelId
               , Object_PositionLevel.ValueData  AS PositionLevelName
               , Object_PersonalGroup.Id         AS PersonalGroupId
               , Object_PersonalGroup.ValueData  AS PersonalGroupName
               , tmpPersonal.DateIn
               , tmpPersonal.DateOut
               , tmpStaffList.HoursDay  ::TFLoat
               , tmpStaffList.StaffListSummKindName ::TVarChar
               '
               || vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[Movement_Data.MemberId        -- AS MemberId
                                               , Movement_Data.PositionId      -- AS PositionId
                                               , Movement_Data.PositionLevelId -- AS PositionLevelId
                                               , Movement_Data.PersonalGroupId -- AS PersonalGroupId
                                               , Movement_Data.UnitId          -- AS MemberId
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

         LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = D.Key[2]
                               AND tmpStaffList.PositionLevelId = D.Key[3]
                               AND tmpStaffList.UnitId     = D.Key[5]

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId        = D.Key[1]
                              AND tmpPersonal.PositionId      = D.Key[2]
                              AND tmpPersonal.PositionLevelId = D.Key[3]
                              AND tmpPersonal.PersonalGroupId = D.Key[4]
                              AND tmpPersonal.UnitId          = D.Key[5]
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
        FULL JOIN (SELECT 1 AS Id, ''1.���-�� �����''    AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 1) :: TFloat AS TotalAmount
             UNION SELECT 2 AS Id, ''2.���-�� ����''     AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 2) :: TFloat AS TotalAmount
             UNION SELECT 3 AS Id, ''3.���-�� ��.��''    AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 3) :: TFloat AS TotalAmount
             UNION SELECT 4 AS Id, ''4.���-�� ��''       AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 4) :: TFloat AS TotalAmount
             UNION SELECT 5 AS Id, ''5.���-�� �������''  AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 5) :: TFloat AS TotalAmount
             UNION SELECT 6 AS Id, ''6.���-�� ��������'' AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 6) :: TFloat AS TotalAmount
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 01.09.21         * add inMemberId
 07.01.14                                                          *
*/

-- ����
/* BEGIN;
  SELECT * FROM gpReport_SheetWorkTime('20150701', '20150830', 0, '5');
  fetch all "<unnamed portal 10>";
 END;*/

