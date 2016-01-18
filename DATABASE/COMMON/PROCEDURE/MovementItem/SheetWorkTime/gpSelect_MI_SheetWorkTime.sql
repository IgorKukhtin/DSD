-- Function: gpSelect_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- ������ ������������
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
          cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     vbStartDate := date_trunc('month', inDate)                                ;    -- ������ ����� ������
     vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- ��������� ����� ������

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(vbStartDate, vbEndDate, '1 DAY'::interval) OperDate;

     -- ���������� ��������� �������� � ����
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          (EXTRACT(DAY FROM tmpOperDate.OperDate))::TVarChar AS ValueField
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
          SELECT Object_Member.Id           AS MemberId
               , Object_Member.ObjectCode   AS MemberCode
               , Object_Member.ValueData    AS MemberName
               , Object_Position.Id         AS PositionId
               , Object_Position.ValueData  AS PositionName
               , Object_PositionLevel.Id         AS PositionLevelId
               , Object_PositionLevel.ValueData  AS PositionLevelName
               , Object_PersonalGroup.Id         AS PersonalGroupId
               , Object_PersonalGroup.ValueData  AS PersonalGroupName
               , False AS isErased '
               || vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.MemberId, Object_Data.MemberId)               -- AS MemberId
                                               , COALESCE (Movement_Data.PositionId, Object_Data.PositionId)           -- AS PositionId
                                               , COALESCE (Movement_Data.PositionLevelId, Object_Data.PositionLevelId) -- AS PositionLevelId
                                               , COALESCE (Movement_Data.PersonalGroupId, Object_Data.PersonalGroupId) -- AS PersonalGroupId
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.OperDate, Object_Data.OperDate) AS OperDate
                                         , ARRAY[zfCalc_ViewWorkHour (COALESCE(Movement_Data.Amount, 0), Movement_Data.ShortName) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId, 0) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT tmpOperDate.operdate
                                               , MI_SheetWorkTime.Amount
                                               , COALESCE(MI_SheetWorkTime.ObjectId, 0) AS MemberId
                                               , COALESCE(MIObject_Position.ObjectId, 0) AS PositionId
                                               , COALESCE(MIObject_PositionLevel.ObjectId, 0) AS PositionLevelId
                                               , COALESCE(MIObject_PersonalGroup.ObjectId, 0) AS PersonalGroupId
                                               , MIObject_WorkTimeKind.ObjectId
                                               , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                                          FROM tmpOperDate
                                               JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                                             AND Movement.DescId = zc_Movement_SheetWorkTime()
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
                                               LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName 
                                                                                ON ObjectString_WorkTimeKind_ShortName.ObjectId = MIObject_WorkTimeKind.ObjectId  
                                                                               AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()       
                                               LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                                ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                               AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                                          WHERE MovementLinkObject_Unit.ObjectId = '|| inUnitId :: TVarChar ||
                                        ') AS Movement_Data
                                        FULL JOIN  
                                         (SELECT tmpOperDate.operdate, 0, 
                                                 COALESCE(MemberId, 0) AS MemberId, 
                                                 COALESCE(ObjectLink_Personal_Position.ChildObjectId, 0) AS PositionId, 
                                                 COALESCE(ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId, 
                                                 COALESCE(ObjectLink_Personal_PersonalGroup.ChildObjectId, 0)  AS PersonalGroupId  
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
                                  order by 1,2''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.Key[1]
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.Key[3]
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]';

     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*   
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.14                         * Replace inPersonalId <> inMemberId
 30.11.13                                        * add isErased = FALSE
 30.11.13                                        * parse
 25.11.13                         * Add PositionLevel
 25.10.13                         *
 19.10.13                         *
 05.10.13                         *
*/

-- ����
-- BEGIN;
--  SELECT * FROM gpSelect_MovementItem_SheetWorkTime(now(), 0, '');
--  fetch all "<unnamed portal 10>";
-- END;

