-- Function: gpSelect_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_Object_SheetWorkTime(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SheetWorkTime(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DayKindId Integer, DayKindCode Integer, DayKindName TVarChar
             , StartTime Time, WorkTime Time, DayOffPeriodDate TDateTime
             , Comment TVarChar, DayOffPeriod TVarChar, DayOffWeek TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_SheetWorkTime());

     RETURN QUERY 
     SELECT 
           Object_SheetWorkTime.Id              AS Id 
         , Object_SheetWorkTime.ObjectCode      AS Code
         , Object_SheetWorkTime.ValueData       AS Name
         
         , Object_DayKind.Id                    AS DayKindId
         , Object_DayKind.ObjectCode            AS DayKindCode
         , Object_DayKind.ValueData             AS DayKindName
       
         , ObjectDate_Start.ValueData        :: Time      AS StartTime
         , ObjectDate_Work.ValueData         :: Time      AS WorkTime
         , ObjectDate_DayOffPeriod.ValueData :: TDateTime AS DayOffPeriodDate
         
         , ObjectString_Comment.ValueData       AS Comment
         , ObjectString_DayOffPeriod.ValueData  AS DayOffPeriod                                                                                                       
         , (CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 1) ::TFloat = 1 THEN 'Пн., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 2) ::TFloat = 2 THEN 'Вт., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 3) ::TFloat = 3 THEN 'Ср., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 4) ::TFloat = 4 THEN 'Чт., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 5) ::TFloat = 5 THEN 'Пт., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 6) ::TFloat = 6 THEN 'Сб., ' ELSE '' END ||
            CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 7) ::TFloat = 7 THEN 'Вс., ' ELSE '' END)     ::TVarChar  AS DayOffWeek

         , Object_SheetWorkTime.isErased        AS isErased
         
     FROM Object AS Object_SheetWorkTime
  
          LEFT JOIN ObjectDate AS ObjectDate_Start
                               ON ObjectDate_Start.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_Start.DescId = zc_ObjectDate_SheetWorkTime_Start()

          LEFT JOIN ObjectDate AS ObjectDate_Work
                               ON ObjectDate_Work.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_Work.DescId = zc_ObjectDate_SheetWorkTime_Work()

          LEFT JOIN ObjectDate AS ObjectDate_DayOffPeriod
                               ON ObjectDate_DayOffPeriod.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_DayOffPeriod.DescId = zc_ObjectDate_SheetWorkTime_DayOffPeriod()
          
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_SheetWorkTime_Comment()

          LEFT JOIN ObjectString AS ObjectString_DayOffPeriod
                                 ON ObjectString_DayOffPeriod.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_DayOffPeriod.DescId = zc_ObjectString_SheetWorkTime_DayOffPeriod()

          LEFT JOIN ObjectString AS ObjectString_DayOffWeek
                                 ON ObjectString_DayOffWeek.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_DayOffWeek.DescId = zc_ObjectString_SheetWorkTime_DayOffWeek()

          LEFT JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind
                               ON ObjectLink_SheetWorkTime_DayKind.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
          LEFT JOIN Object AS Object_DayKind ON Object_DayKind.Id = ObjectLink_SheetWorkTime_DayKind.ChildObjectId          

     WHERE Object_SheetWorkTime.DescId = zc_Object_SheetWorkTime()

      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name

            , 0 AS DayKindId
            , 0 AS DayKindCode
            , '' :: TVarChar AS DayKindName
       
            , NULL :: Time      AS StartTime
            , NULL :: Time      AS WorkTime
            , NULL :: TDateTime AS DayOffPeriodDate
         
            , '' :: TVarChar AS Comment
            , '' :: TVarChar AS DayOffPeriod
            , '' :: TVarChar AS DayOffWeek

            , FALSE AS isErased
     ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.16         *   
*/

-- тест
-- SELECT * FROM gpSelect_Object_SheetWorkTime (zfCalc_UserAdmin())
