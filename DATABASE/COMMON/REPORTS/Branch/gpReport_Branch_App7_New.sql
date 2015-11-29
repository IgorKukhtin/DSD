-- Function: gpReport_Branch_App7_New()

DROP FUNCTION IF EXISTS gpReport_Branch_App7_New (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7_New(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (NomStr integer, InfoText TVarChar
              , Amount2 TFloat, Amount3 TFloat, Amount4 TFloat, Amount5 TFloat
             , Amount7 TFloat, Amount9 TFloat, Amount11 TFloat, Amount12 TFloat          
              )
AS
$BODY$
   
BEGIN

    -- Результат
     RETURN QUERY
     WITH tmp AS (SELECT * FROM gpReport_Branch_App7 (inStartDate:= inStartDate, inEndDate:= inEndDate, inBranchId:= inBranchId, inSession:= inSession) )             

       SELECT tmpList.NomStr , tmpList.InfoText  ::TVarChar AS InfoText     
            , SUM (CASE WHEN tmpList.BranchCode = 2 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount2
            , SUM (CASE WHEN tmpList.BranchCode = 3 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount3
            , SUM (CASE WHEN tmpList.BranchCode = 4 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount4
            , SUM (CASE WHEN tmpList.BranchCode = 5 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount5
            , SUM (CASE WHEN tmpList.BranchCode = 7 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount7
            , SUM (CASE WHEN tmpList.BranchCode = 9 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount9
            , SUM (CASE WHEN tmpList.BranchCode = 11 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount11
            , SUM (CASE WHEN tmpList.BranchCode > 11 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount12
            
       FROM(
            SELECT 1 AS NomStr, 'Сумма Нач.ост. на складе' AS InfoText, tmp.BranchCode, tmp.GoodsSummStart AS Amount FROM tmp 
          UNION All
            SELECT    2 AS NomStr, 'Сумма Кон.ост. на складе' AS InfoText, tmp.BranchCode, tmp.GoodsSummEnd AS Amount FROM tmp
          UNION All
            SELECT   3 AS NomStr, 'Сумма приход на склад' AS InfoText, tmp.BranchCode, tmp.GoodsSummIn AS Amount FROM tmp
          UNION All
            SELECT   4 AS NomStr, 'Сумма расход со склада' AS InfoText, tmp.BranchCode, tmp.GoodsSummOut AS Amount FROM tmp
          UNION All
            SELECT   5 AS NomStr, 'Сумма продажи Ф2' AS InfoText, tmp.BranchCode, tmp.GoodsSummSale_sf AS Amount FROM tmp
          UNION All
            SELECT   6 AS NomStr, 'Сумма возврата Ф2' AS InfoText, tmp.BranchCode, tmp.GoodsSummReturnIn_sf AS Amount FROM tmp
          UNION All
            SELECT   7 AS NomStr, 'Касса нач.остаток' AS InfoText, tmp.BranchCode, tmp.CashSummStart FROM tmp
          UNION All
            SELECT   8 AS NomStr, 'Касса кон.остаток' AS InfoText, tmp.BranchCode, tmp.CashSummEnd FROM tmp
          UNION All
            SELECT   9 AS NomStr, 'Касса приход' AS InfoText, tmp.BranchCode, tmp.CashSummIn AS Amount FROM tmp
          UNION All
            SELECT   10 AS NomStr, 'Касса расход' AS InfoText, tmp.BranchCode, tmp.CashSummOut AS Amount FROM tmp
          UNION All
            SELECT   11 AS NomStr, 'Касса (оплата)' AS InfoText, tmp.BranchCode, tmp.CashAmount AS Amount FROM tmp
          UNION All
            SELECT   12 AS NomStr, 'Долги (нач.)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummstart AS Amount FROM tmp
          UNION All
            SELECT  13 AS NomStr,  'Долги (кон)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummEnd AS Amount FROM tmp
          UNION All
            SELECT   14 AS NomStr, 'Дебет' AS InfoText, tmp.BranchCode, tmp.JuridicalSummIn AS Amount FROM tmp
          UNION All
            SELECT   15 AS NomStr, 'Кредит' AS InfoText, tmp.BranchCode, tmp.JuridicalSummOut AS Amount FROM tmp
        ) AS tmpList
       GROUP BY tmpList.NomStr , tmpList.InfoText
       ORDER BY 1

      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.11.15         * 

*/

--
--SELECT * FROM gpReport_Branch_App7_New (inStartDate:= '31.07.2015'::TDateTime, inEndDate:= '03.08.2015'::TDateTime, inBranchId:= 8374, inSession:= zfCalc_UserAdmin())  --8374