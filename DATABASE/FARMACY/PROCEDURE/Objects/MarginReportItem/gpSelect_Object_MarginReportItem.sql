--Function: gpSelect_Object_MarginReportItem(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginReportItem(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MarginReportItem(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginReportItem(
    IN inMarginReportId  Integer,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MarginReportId Integer, MarginReportName TVarChar 
             , UnitId Integer, UnitName TVarChar
             , Percent1 TFloat
             , Percent2 TFloat
             , Percent3 TFloat
             , Percent4 TFloat
             , Percent5 TFloat
             , Percent6 TFloat
             , Percent7 TFloat
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginReportItem());

   RETURN QUERY 
   SELECT Object_MarginReportItem.Id        AS Id 
        , Object_MarginReport.ObjectCode    AS MarginReportId
        , Object_MarginReport.ValueData     AS MarginReportName

        , Object_Unit.ObjectCode            AS UnitId
        , Object_Unit.ValueData             AS UnitName

        , ObjectFloat_Percent1.ValueData    AS Percent1 
        , ObjectFloat_Percent2.ValueData    AS Percent2
        , ObjectFloat_Percent3.ValueData    AS Percent3
        , ObjectFloat_Percent4.ValueData    AS Percent4
        , ObjectFloat_Percent5.ValueData    AS Percent5
        , ObjectFloat_Percent6.ValueData    AS Percent6
        , ObjectFloat_Percent7.ValueData    AS Percent7 
 
        , Object_MarginReportItem.isErased  AS isErased

   FROM Object AS Object_MarginReportItem
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent1 	
                              ON ObjectFloat_Percent1.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent1.DescId = zc_ObjectFloat_MarginReportItem_Percent1()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent2 	
                              ON ObjectFloat_Percent2.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent2.DescId = zc_ObjectFloat_MarginReportItem_Percent2()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent3 	
                              ON ObjectFloat_Percent3.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent3.DescId = zc_ObjectFloat_MarginReportItem_Percent3()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent4 	
                              ON ObjectFloat_Percent4.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent4.DescId = zc_ObjectFloat_MarginReportItem_Percent4()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent5 	
                              ON ObjectFloat_Percent5.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent5.DescId = zc_ObjectFloat_MarginReportItem_Percent5()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent6 	
                              ON ObjectFloat_Percent6.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent6.DescId = zc_ObjectFloat_MarginReportItem_Percent6()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent7 	
                              ON ObjectFloat_Percent7.ObjectId = Object_MarginReportItem.Id
                             AND ObjectFloat_Percent7.DescId = zc_ObjectFloat_MarginReportItem_Percent7()
  
        INNER JOIN ObjectLink AS ObjectLink_MarginReport
                             ON ObjectLink_MarginReport.DescId = zc_ObjectLink_MarginReportItem_MarginReport()
                            AND ObjectLink_MarginReport.ObjectId = Object_MarginReportItem.Id 
                            AND (ObjectLink_MarginReport.ChildObjectId = inMarginReportId OR inMarginReportId = 0)
        LEFT JOIN Object AS Object_MarginReport ON Object_MarginReport.Id = ObjectLink_MarginReport.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit
                             ON ObjectLink_Unit.DescId = zc_ObjectLink_MarginReportItem_Unit()
                            AND ObjectLink_Unit.ObjectId = Object_MarginReportItem.Id 
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

   WHERE Object_MarginReportItem.DescId = zc_Object_MarginReportItem();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_MarginReportItem(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginReportItem('2')