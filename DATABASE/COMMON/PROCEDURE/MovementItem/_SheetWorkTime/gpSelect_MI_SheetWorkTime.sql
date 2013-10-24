-- Function: gpSelect_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
          cur1 refcursor; 
          cur2 refcursor; 
          vbIndex integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SheetWorkTime());

     vbStartDate := date_trunc('month', inDate)                                ;    -- первое число месяца
     vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- последнее число месяца

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(vbStartDate, vbEndDate, '1 DAY'::interval) OperDate;

     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          (EXTRACT(DAY FROM tmpOperDate.OperDate))::TVarChar AS ValueField
               FROM tmpOperDate;  
     RETURN NEXT cur1;
    
     vbIndex := 0;
     -- именно так, из-за перехода времени кол-во дней может быть разное
     vbDayCount := (SELECT count(*) 
                     FROM tmpOperDate);

     vbCrossString := 'Key integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] AS Value'||vbIndex||'  '||
                          ', DAY' || vbIndex || '[2]::integer  AS TypeId'||vbIndex||' ';
     END LOOP;

     vbQueryText := '
          SELECT 
             View_Personal.PersonalId   AS PersonalId
           , View_Personal.PersonalCode AS PersonalCode
           , View_Personal.PersonalName AS PersonalName
           , Object_Position.Id         AS PositionId
           , Object_Position.ValueData  AS PositionName
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ValueData   AS UnitName
           , Object_PersonalGroup.Id         AS PersonalGroupId
           , Object_PersonalGroup.ValueData  AS PersonalGroupName'
           || vbFieldNameText ||
          ' FROM
          (SELECT * FROM crosstab(
	''SELECT ARRAY[PersonalId, ObjectLink_Personal_Position.ChildObjectId,
                       ObjectLink_Personal_Unit.ChildObjectId, ObjectLink_Personal_PersonalGroup.ChildObjectId]::integer[],
	         OperDate, 
	         ARRAY[''''8 hour'''', ''''0'''']::VarChar[]
	    FROM tmpOperDate, Object_Personal_View 
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                            ON ObjectLink_Personal_Position.ObjectId = Object_Personal_View.PersonalId
                           AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                            ON ObjectLink_Personal_Unit.ObjectId = Object_Personal_View.PersonalId
                           AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
       LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                            ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal_View.PersonalId
                           AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
       WHERE ObjectLink_Personal_Unit.ChildObjectId = '||inUnitId::TVarChar||'


        ORDER BY PersonalId'',
         ''SELECT OperDate FROM tmpOperDate'')
         AS ct('||vbCrossString||')) AS D
      LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = D.Key[1]
      LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
      LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = D.Key[3]
      LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]';

     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.13                         *
 05.10.13                         *

*/

-- тест
--BEGIN;
--  SELECT * FROM gpSelect_MovementItem_SheetWorkTime(now(), 0, '');
--  fetch all "<unnamed portal 2>";
--END;
