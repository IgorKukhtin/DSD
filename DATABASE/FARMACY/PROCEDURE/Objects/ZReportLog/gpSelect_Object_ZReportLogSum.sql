--  gpSelect_Object_ZReportLogSum()

DROP FUNCTION IF EXISTS gpSelect_Object_ZReportLogSum (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ZReportLogSum(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UnitID Integer, UnitCode Integer, UnitName TVarChar

             , SummaCash TFloat
             , SummaCard TFloat
             , SummaTotal TFloat
             
             , ColorRA_calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);

     -- Результат
  RETURN QUERY
  WITH tmpZReportLog AS (SELECT * FROM gpSelect_Object_ZReportLog(inStartDate := inStartDate, inEndDate := inEndDate, inUnitId := inUnitId,  inSession := inSession))

  SELECT ZReportLog.OperDate
       , Object_Unit.ID            AS UnitID
       , Object_Unit.ObjectCode    AS UnitCode
       , Object_Unit.ValueData     AS UnitName

       , SUM(ZReportLog.SummaCash)::TFloat    AS SummaCash
       , SUM(ZReportLog.SummaCard)::TFloat    AS SummaCard
        
       , SUM(ZReportLog.SummaTotal)::TFloat   AS SummaTotal

       , zc_Color_White()          AS ColorRA_calc
  FROM tmpZReportLog AS ZReportLog 
  
       INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = ZReportLog.UnitId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                            
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ZReportLog.UnitId

  GROUP BY ZReportLog.OperDate
         , Object_Unit.ID
         , Object_Unit.ObjectCode
         , Object_Unit.ValueData 
  ORDER BY ZReportLog.OperDate
         , Object_Unit.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.08.21                                                                                    *
*/

-- тест
-- 

select * from gpSelect_Object_ZReportLogSum(inStartDate := ('05.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inUnitId := 10779386 ,  inSession := '3');