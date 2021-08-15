-- Function: gpSelect_Object_ZReportLog()

DROP FUNCTION IF EXISTS gpSelect_Object_ZReportLog(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ZReportLog(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ZReport Integer, FiscalNumber TVarChar
             
             , DateZReport TDateTime
             , OperDate TDateTime

             , SummaCash TFloat
             , SummaCard TFloat
             , SummaTotal TFloat
            
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar

             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ZReportLog());

   RETURN QUERY
   SELECT
          Object_ZReportLog.Id         AS Id
        , Object_ZReportLog.ObjectCode AS ZReport
        , Object_ZReportLog.ValueData  AS FiscalNumber
        
        , ObjectDate_Date.ValueData    AS DateZReport
        , DATE_TRUNC ('DAY', ObjectDate_Date.ValueData)::TDateTime AS OperDate

        , ObjectFloat_SummaCash.ValueData    AS SummaCash
        , ObjectFloat_SummaCard.ValueData    AS SummaCard
        
        , (COALESCE(ObjectFloat_SummaCash.ValueData, 0) +
          COALESCE(ObjectFloat_SummaCard.ValueData, 0))::TFloat    AS SummaTotal

        , Object_Unit.ID                     AS UnitId
        , Object_Unit.ObjectCode             AS UnitCode
        , Object_Unit.ValueData              AS UnitName

        , Object_User.ID                     AS UserId
        , Object_User.ObjectCode             AS UserCode
        , Object_User.ValueData              AS UserName

        , Object_ZReportLog.isErased   AS isErased
   FROM Object AS Object_ZReportLog
                          
        LEFT JOIN ObjectDate AS ObjectDate_Date
                             ON ObjectDate_Date.ObjectId = Object_ZReportLog.Id
                            AND ObjectDate_Date.DescId = zc_ObjectDate_ZReportLog_Date()

        LEFT JOIN ObjectFloat AS ObjectFloat_SummaCash
                              ON ObjectFloat_SummaCash.ObjectId = Object_ZReportLog.Id
                             AND ObjectFloat_SummaCash.DescId = zc_ObjectFloat_ZReportLog_SummaCash()
        LEFT JOIN ObjectFloat AS ObjectFloat_SummaCard
                              ON ObjectFloat_SummaCard.ObjectId = Object_ZReportLog.Id
                             AND ObjectFloat_SummaCard.DescId = zc_ObjectFloat_ZReportLog_SummaCard()

        LEFT JOIN ObjectLink AS ObjectLink_ZReportLog_Unit
                             ON ObjectLink_ZReportLog_Unit.ObjectId = Object_ZReportLog.Id
                            AND ObjectLink_ZReportLog_Unit.DescId = zc_ObjectLink_ZReportLog_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ZReportLog_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ZReportLog_User
                             ON ObjectLink_ZReportLog_User.ObjectId = Object_ZReportLog.Id
                            AND ObjectLink_ZReportLog_User.DescId = zc_ObjectLink_ZReportLog_User()
        LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_ZReportLog_User.ChildObjectId

   WHERE Object_ZReportLog.DescId = zc_Object_ZReportLog()
     AND ObjectDate_Date.ValueData >= DATE_TRUNC ('DAY', inStartDate) 
     AND ObjectDate_Date.ValueData < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
     AND (ObjectLink_ZReportLog_Unit.ChildObjectId = inUnitId OR inUnitId = 0);

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.05.18         *
*/

-- тест
-- 

SELECT * FROM gpSelect_Object_ZReportLog(inStartDate := ('05.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inUnitId := 10779386 ,  inSession := '3')