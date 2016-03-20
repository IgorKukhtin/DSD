-- Function: gpInsertMask_MI_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertMask_MI_SheetWorkTime(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertMask_MI_SheetWorkTime(
    IN inUnitId              Integer   , -- Подразделение
    IN inOperDate            TDateTime , -- дата
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbStartDatePrevious TDateTime;
   DECLARE vbEndDatePrevious TDateTime;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


--SELECT '01.02.2016'::TDateTime - INTERVAL '1 DAY', ('01.02.2016'::TDateTime - INTERVAL '1 MONTH') 
       -- нач. и кон. даты предыдущего периода
       vbStartDatePrevious := inOperDate - INTERVAL '1 MONTH';
       vbEndDatePrevious := inOperDate - INTERVAL '1 DAY';

       -- кон. дата текущего периода
      vbStartDate := vbEndDatePrevious + INTERVAL '1 DAY';
      vbEndDate := (inOperDate + INTERVAL '1 MONTH' )- INTERVAL '1 DAY';

     
       CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

       CREATE TEMP TABLE tmpSheetWorkTime ON COMMIT DROP AS
         SELECT  Movement.operdate                             AS OperDate
               , tmpWeekDay.Number                             AS Number
               , tmpWeekDay.DayOfWeekName                      AS DayOfWeekName
               , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS PersonalId
               , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
               , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
               , MIObject_WorkTimeKind.ObjectId                AS WorkTimeKindId
               , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
            
         FROM Movement  
           JOIN MovementLinkObject AS MovementLinkObject_Unit
                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  AND MovementLinkObject_Unit.ObjectId = inUnitId  --377605  --183290 --377605-- inUnitId          183290    "АП_3 ул_Батумская_13 КЗДЦПМСП_9"
           JOIN MovementItem AS MI_SheetWorkTime 
                             ON MI_SheetWorkTime.MovementId = Movement.Id
                            AND MI_SheetWorkTime.DescId = zc_MI_Master()
                            AND MI_SheetWorkTime.isErased = FALSE
           JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                            ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                           AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind() 
                                           AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Work()
           LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName 
                                  ON ObjectString_WorkTimeKind_ShortName.ObjectId = MIObject_WorkTimeKind.ObjectId  
                                 AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()       
           LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                            ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                            AND MIObject_Position.DescId = zc_MILinkObject_Position()                                  
           LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                            ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                           AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()

           LEFT JOIN zfCalc_DayOfWeekName (Movement.operdate) AS tmpWeekDay ON 1=1
           
          WHERE Movement.operDate between vbStartDatePrevious and vbEndDatePrevious
            AND Movement.DescId = zc_Movement_SheetWorkTime()
            AND COALESCE(MI_SheetWorkTime.ObjectId, 0)<>0
          ORDER BY 4,1;

       -- таблица сотрудников из пердыдущей
       CREATE TEMP TABLE tmpPersonal ON COMMIT DROP AS
         SELECT  DISTINCT tmpSheetWorkTime.PersonalId       
                        , tmpSheetWorkTime.PositionId    
                        , tmpSheetWorkTime.PersonalGroupId 
                        , tmpSheetWorkTime.ShortName        
                        , tmpSheetWorkTime.WorkTimeKindId   
                  FROM tmpSheetWorkTime;
                  
       -- таблица работающих по 5/2
       CREATE TEMP TABLE tmpWeekPersonal ON COMMIT DROP AS
        SELECT tmp.PersonalId, tmp.WorkStr, CASE WHEN position('1,2,3,4,5' in tmp.WorkStr) >0 THEN TRUE ELSE FALSE END AS WorkWeek
        FROM (
              SELECT tmp.PersonalId, string_agg(tmp.DayOfWeekName, ',' ) as WorkStr
              FROM  (SELECT tmpSheetWorkTime.PersonalId, tmpSheetWorkTime.Number :: TVarChar AS DayOfWeekName
                     FROM tmpSheetWorkTime
                     ) tmp
              GROUP BY tmp.PersonalId) AS tmp
              WHERE position('1,2,3,4,5' in tmp.WorkStr) >0;

       -- 2 последнии рабочии даты предыдущего месяца
       CREATE TEMP TABLE tmpLastWorkday ON COMMIT DROP AS                        
        SELECT tmp.PersonalId, tmp.operdate
        FROM(
             SELECT tmpSheetWorkTime.PersonalId, tmpSheetWorkTime.operdate, ROW_NUMBER()OVER(PARTITION BY tmpSheetWorkTime.PersonalId Order By tmpSheetWorkTime.PersonalId , tmpSheetWorkTime.operdate DESC) AS Ord
             FROM tmpSheetWorkTime
                  LEFT JOIN tmpWeekPersonal ON tmpWeekPersonal.PersonalId = tmpSheetWorkTime.PersonalId
             where tmpWeekPersonal.PersonalId isnull
             ) as tmp
        Where tmp.Ord in (1,2);
    
       -- оперделяем сколько рабочих дней было в последние 2 дня месяца () и последнюю рабочую дату
       CREATE TEMP TABLE tmpLastWorkday2 ON COMMIT DROP AS                        
          SELECT tmpLastWorkday.PersonalId, tmp.NDay, Max (tmpLastWorkday.operdate) AS LastWorkDay
          FROM tmpLastWorkday
               LEFT JOIN (SELECT tmp.PersonalId,  sum (NDay) AS NDay
                          FROM (SELECT tmpLastWorkday.PersonalId, tmpLastWorkday.operdate, CASE WHEN tmpLastWorkday.operdate >= vbEndDatePrevious - INTERVAL '1 DAY' /*'28.02.2016' */ THEN 1 ELSE 0 END AS NDay
                                FROM tmpLastWorkday) AS tmp                  
                          GROUP BY PersonalId
                          )as tmp ON tmp.PersonalId = tmpLastWorkday.PersonalId
          GROUP BY tmpLastWorkday.PersonalId, tmp.NDay;

       --интервалы дат для работающих 2/2
       -- даты работы с 01-го числа месяца РРВВ
       CREATE TEMP TABLE tmpListDatePPBB ON COMMIT DROP AS                        
        SELECT generate_series(vbStartDate, vbEndDate, '4 day'::interval) as OperDate
           union
        SELECT generate_series(vbStartDate + interval '1 day', vbEndDate, '4 day'::interval) as OperDate;
        
        -- даты работы с 02-го числа месяца ВРРВ
       CREATE TEMP TABLE tmpListDateBPPB  ON COMMIT DROP AS 
          SELECT generate_series(vbStartDate + interval '2 day', vbEndDate, '4 day'::interval) as OperDate
           union
          SELECT generate_series(vbStartDate + interval '1 day', vbEndDate, '4 day'::interval) as OperDate;                        

       -- даты работы с 03-го числа месяца ВВРР
       CREATE TEMP TABLE tmpListDateBBPP ON COMMIT DROP AS 
          SELECT generate_series(vbStartDate + interval '2 day', vbEndDate, '4 day'::interval) as OperDate
           union
          SELECT generate_series(vbStartDate + interval '3 day', vbEndDate, '4 day'::interval) as OperDate;
          
       -- даты работы с 01-го числа месяца РВВР
       CREATE TEMP TABLE tmpListDatePBBP ON COMMIT DROP AS 
         SELECT generate_series(vbStartDate + interval '3 day', vbEndDate, '4 day'::interval) as OperDate
          union
         SELECT generate_series(vbStartDate, vbEndDate, '4 day'::interval) as OperDate;

       -- таблица сотрудников и дат 2/2
       CREATE TEMP TABLE tmpListAll ON COMMIT DROP AS 
         SELECT tmpListDatePPBB.OperDate,  tmpLastWorkday2.PersonalId
         FROM tmpListDatePPBB
              LEFT JOIN tmpLastWorkday2 ON tmpLastWorkday2.NDay = 0
       Union
         SELECT tmpListDatePBBP.OperDate,  tmpLastWorkday2.PersonalId
         FROM tmpListDatePBBP
              LEFT JOIN tmpLastWorkday2 ON tmpLastWorkday2.NDay = 1
                            And tmpLastWorkday2.LastWorkDay = vbEndDatePrevious
       Union
         SELECT tmpListDateBBPP.OperDate,  tmpLastWorkday2.PersonalId
         FROM tmpListDateBBPP
              LEFT JOIN tmpLastWorkday2 ON tmpLastWorkday2.NDay = 2
                            And tmpLastWorkday2.LastWorkDay = vbEndDatePrevious
      Union
         SELECT tmpListDateBPPB.OperDate,  tmpLastWorkday2.PersonalId
         FROM tmpListDateBPPB
              LEFT JOIN tmpLastWorkday2 ON tmpLastWorkday2.NDay = 1
                            And tmpLastWorkday2.LastWorkDay = vbEndDatePrevious - interval '1 day';
         

       -- вставляем данные для  работающих 5/2
       PERFORM gpInsertUpdate_MovementItem_SheetWorkTime( inPersonalId      := tmpPersonal.PersonalId       ::integer 
                                                        , inPositionId      := tmpPersonal.PositionId       ::integer  
                                                        , inUnitId          := inUnitId                     ::integer  
                                                        , inPersonalGroupId := tmpPersonal.PersonalGroupId  ::integer
                                                        , inOperDate        := tmpOperDate.OperDate         ::TDateTime
                                                        , ioValue           := tmpPersonal.ShortName        ::TVarChar
                                                        , ioTypeId          := tmpPersonal.WorkTimeKindId   ::integer 
                                                        , inSession         := inSession
                                                         )
       FROM tmpOperDate
           LEFT JOIN tmpWeekPersonal ON 1=1
           LEFT JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpWeekPersonal.PersonalId
           LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
       WHERE tmpWeekDay.Number not in (6,7);
   

       -- вставляем данные для  работающих 2/2
       PERFORM gpInsertUpdate_MovementItem_SheetWorkTime( inPersonalId      := COALESCE(tmpPersonal.PersonalId,0)       ::integer 
                                                        , inPositionId      := COALESCE(tmpPersonal.PositionId ,0)      ::integer  
                                                        , inUnitId          := inUnitId                     ::integer  
                                                        , inPersonalGroupId := COALESCE(tmpPersonal.PersonalGroupId,0)  ::integer
                                                        , inOperDate        := tmpListAll.OperDate          ::TDateTime
                                                        , ioValue           := COALESCE(tmpPersonal.ShortName,'Р')        ::TVarChar
                                                        , ioTypeId          := COALESCE(tmpPersonal.WorkTimeKindId)   ::integer 
                                                        , inSession         := inSession
                                                         )
       FROM tmpListAll
            JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpListAll.PersonalId;

 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  18.03.16        *

*/

-- тест
-- SELECT * FROM gpInsertMask_MI_SheetWorkTime (, inSession:= '2')


SELECT * FROM gpInsertMask_MI_SheetWorkTime(inUnitId := 375626  ::integer , inOperDate:=('01.02.2016') ::TDateTime , inSession := '3'::TVarChar);


--select * from gpSelect_MovementItem_SheetWorkTime(inDate := ('01.01.2016')::TDateTime , inUnitId := 375626 , inisErased := 'False' ,  inSession := '3');