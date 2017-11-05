-- Function: gpGet_Object_GoodsReportSaleInf()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsReportSaleInf(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsReportSaleInf(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UpdateId Integer, UpdateName TVarChar
             , UpdateDate TDateTime, StartDate TDateTime, EndDate TDateTime
             , Week TFloat
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
       SELECT Object_Update.Id                      AS UpdateId
            , Object_Update.ValueData               AS UpdateName
            , ObjectDate_Protocol_Update.ValueData  AS UpdateDate
            , ObjectDate_Start.ValueData            AS StartDate
            , ObjectDate_End.ValueData              AS EndDate
            , ObjectFloat_Week.ValueData            AS Week

       FROM Object AS Object_GoodsReportSaleInf
       
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_GoodsReportSaleInf.Id
                                AND ObjectDate_Start.DescId = zc_ObjectDate_GoodsReportSaleInf_Start()

            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_GoodsReportSaleInf.Id
                                AND ObjectDate_End.DescId = zc_ObjectDate_GoodsReportSaleInf_End()
                                
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsReportSaleInf.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
                                
            LEFT JOIN ObjectFloat AS ObjectFloat_Week
                                  ON ObjectFloat_Week.ObjectId = Object_GoodsReportSaleInf.Id
                                 AND ObjectFloat_Week.DescId = zc_ObjectFloat_GoodsReportSaleInf_Week()
                                
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Object_GoodsReportSaleInf.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 
      WHERE Object_GoodsReportSaleInf.DescId = zc_Object_GoodsReportSaleInf()
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.17         *

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsReportSaleInf ('2')


