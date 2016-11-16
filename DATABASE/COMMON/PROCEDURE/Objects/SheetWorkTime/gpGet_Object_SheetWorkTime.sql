-- Function: gpGet_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpGet_Object_SheetWorkTime(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SheetWorkTime(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DayKindId Integer, DayKindCode Integer, DayKindName TVarChar
             , StartTime TDateTime, WorkTime TDateTime, DayOffPeriodDate TDateTime
             , Comment TVarChar, DayOffPeriod TVarChar
             , Value1 Boolean, Value2 Boolean, Value3 Boolean, Value4 Boolean, Value5 Boolean, Value6 Boolean, Value7 Boolean
             , isErased Boolean) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_SheetWorkTime());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SheetWorkTime()) AS Code
           , CAST ('' as TVarChar)  AS Name
 
           , CAST (0 as Integer)    AS DayKindId
           , CAST (0 as Integer)    AS DayKindCode
           , CAST ('' as TVarChar)  AS DayKindName
           
          
           , zc_DateStart() :: TDateTime      AS StartTime
           , zc_DateStart() :: TDateTime      AS WorkTime
           , CURRENT_DATE :: TDateTime AS DayOffPeriodDate
           
           , CAST ('' as TVarChar)  AS Comment
           , CAST ('' as TVarChar)  AS DayOffPeriod

           , FALSE                  AS Value1
           , FALSE                  AS Value2
           , FALSE                  AS Value3
           , FALSE                  AS Value4
           , FALSE                  AS Value5
           , FALSE                  AS Value6
           , FALSE                  AS Value7
           
           , FALSE                  AS isErased
           ;           
   ELSE
     RETURN QUERY 
       
       SELECT 
           Object_SheetWorkTime.Id              AS Id 
         , Object_SheetWorkTime.ObjectCode      AS Code
         , Object_SheetWorkTime.ValueData       AS Name
         
         , Object_DayKind.Id                    AS DayKindId
         , Object_DayKind.ObjectCode            AS DayKindCode
         , Object_DayKind.ValueData             AS DayKindName
       
         , ObjectDate_Start.ValueData        :: TDateTime AS StartTime
         , ObjectDate_Work.ValueData         :: TDateTime AS WorkTime
         , ObjectDate_DayOffPeriod.ValueData :: TDateTime AS DayOffPeriodDate
         
         , ObjectString_Comment.ValueData       AS Comment
         , ObjectString_DayOffPeriod.ValueData  AS DayOffPeriod    
                                                                                                   
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 1) ::TFloat = 1 THEN TRUE ELSE FALSE END AS Value1
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 2) ::TFloat = 2 THEN TRUE ELSE FALSE END AS Value2
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 3) ::TFloat = 3 THEN TRUE ELSE FALSE END AS Value3
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 4) ::TFloat = 4 THEN TRUE ELSE FALSE END AS Value4
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 5) ::TFloat = 5 THEN TRUE ELSE FALSE END AS Value5
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 6) ::TFloat = 6 THEN TRUE ELSE FALSE END AS Value6
         , CASE WHEN zfCalc_Word_Split (inValue:= ObjectString_DayOffWeek.ValueData, inSep:= ',', inIndex:= 7) ::TFloat = 7 THEN TRUE ELSE FALSE END AS Value7

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
                          
       WHERE Object_SheetWorkTime.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_SheetWorkTime(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.16         *            
*/

-- тест
-- SELECT * FROM gpGet_Object_SheetWorkTime(0, '2')