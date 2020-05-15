-- Function:  gpReport_ImplementationPeriod()

DROP FUNCTION IF EXISTS gpReport_ImplementationPeriod (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_ImplementationPeriod(
    IN inDateStart         TDateTime,  -- Дата начала
    IN inDateFinal         TDateTime,  -- Двта конца
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitID               Integer
             , UnitCode             Integer   --
             , UnitName             TVarChar  --
             , JuridicalCode        Integer   --
             , JuridicalName        TVarChar  --

             , SummaSelling         TFloat    -- Сумма реализации
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

     inDateStart := DATE_TRUNC ('day', inDateStart);
     inDateFinal   := DATE_TRUNC ('day', inDateFinal) + interval '1 day';


      -- Результат
      RETURN QUERY
        WITH tmpRealization AS (SELECT AnalysisContainerItem.UnitID
                                     , Sum(COALESCE(AnalysisContainerItem.AmountCheckSumJuridical, 0) + COALESCE(AnalysisContainerItem.AmountSaleSumJuridical, 0)) AS AmountSumJuridical
                                     , Sum(COALESCE(AnalysisContainerItem.AmountCheckSum, 0) + COALESCE(AnalysisContainerItem.AmountSaleSum, 0))          AS AmountSum
                                FROM AnalysisContainerItem
                                WHERE AnalysisContainerItem.OperDate >= inDateStart
                                  AND AnalysisContainerItem.OperDate < inDateFinal
                                GROUP BY AnalysisContainerItem.UnitID)

        SELECT tmpRealization.UnitId
             , Object_Unit.ObjectCode
             , Object_Unit.ValueData
             , Object_Juridical.ObjectCode
             , Object_Juridical.ValueData
             , ROUND(tmpRealization.AmountSum, 2) ::TFloat
        FROM tmpRealization

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpRealization.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = tmpRealization.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        WHERE ROUND(tmpRealization.AmountSum, 2) <> 0
        ORDER BY tmpRealization.UnitId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.19                                                       *

*/

-- тест
-- select * from gpReport_ImplementationPeriod(inDateStart := ('01.01.2020')::TDateTime , inDateFinal := ('31.01.2020')::TDateTime , inSession := '3');