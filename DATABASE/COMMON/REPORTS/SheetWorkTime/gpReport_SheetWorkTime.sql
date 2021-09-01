-- Function: gpReport_SheetWorkTime()

--DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SheetWorkTime(TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime(
    IN inDateStart   TDateTime , --
    IN inDateEnd     TDateTime , --
    IN inUnitId      Integer   , --
    IN inMemberId    Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
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


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inDateStart, inDateEnd, '1 DAY'::interval) OperDate;

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
               , Object_PersonalGroup.ValueData  AS PersonalGroupName'
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
                                    FROM (SELECT tmpOperDate.operdate
                                               , MI_SheetWorkTime.Amount
                                               , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                               , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                               , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                               , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                               , MIObject_WorkTimeKind.ObjectId
                                               , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                                               , MovementLinkObject_Unit.ObjectId              AS UnitId
                                          FROM tmpOperDate
                                               JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                                            AND Movement.DescId = zc_Movement_SheetWorkTime()
                                               JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
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
                                          WHERE MovementLinkObject_Unit.ObjectId in '||vbUnits||'
                                            AND (COALESCE(MI_SheetWorkTime.ObjectId, 0) = '||inMemberId||' OR '||inMemberId||' = 0)'
                                        ') AS Movement_Data
                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.Key[1]
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.Key[3]
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = D.Key[5]';

     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

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

