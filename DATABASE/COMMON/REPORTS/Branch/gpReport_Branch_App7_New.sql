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
             , Amount TFloat      
             , Amount2_Rashod TFloat, Amount3_Rashod TFloat, Amount4_Rashod TFloat, Amount5_Rashod TFloat
             , Amount7_Rashod TFloat, Amount9_Rashod TFloat, Amount11_Rashod TFloat, Amount12_Rashod TFloat       
             , Amount_Rashod TFloat 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


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
            , SUM (CASE WHEN tmpList.BranchCode = 12 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount12
            , SUM (CASE WHEN tmpList.BranchCode > 12 THEN tmpList.Amount ELSE 0 END) ::TFloat AS Amount

            , SUM (CASE WHEN tmpList.BranchCode = 2 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount2_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 3 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount3_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 4 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount4_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 5 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount5_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 7 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount7_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 9 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount9_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 11 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount11_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 12 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount12_Rashod
            , SUM (CASE WHEN tmpList.BranchCode > 12 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount_Rashod
            
       FROM(
            SELECT 1 AS NomStr, '1.Задолженность филиалов на нач.мес.' AS InfoText, tmp.BranchCode, (tmp.GoodsSummStart+tmp.CashSummStart+ tmp.JuridicalSummstart) AS Amount, 0 AS Amount_Rashod  FROM tmp 
          UNION All
            SELECT 2 AS NomStr, 'Начальный остаток продукции на складах филиалов' AS InfoText, tmp.BranchCode, tmp.GoodsSummStart AS Amount, 0 AS Amount_Rashod  FROM tmp 
          UNION All
            SELECT 3 AS NomStr, 'Начальный остаток денежных средств в кассах' AS InfoText, tmp.BranchCode, tmp.CashSummStart, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 4 AS NomStr, 'Задолженность покупателей ф2 (нач)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummstart AS Amount, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 5 AS NomStr, '2.Движение продукции за месяц' AS InfoText, tmp.BranchCode, tmp.GoodsSummIn AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 5 AS NomStr, '2.Движение продукции за месяц' AS InfoText, tmp.BranchCode, 0 AS Amount , tmp.GoodsSummOut AS Amount_Rashod FROM tmp
          UNION All
            SELECT 7 AS NomStr, '3.Движение ден. ср -в за месяц' AS InfoText, tmp.BranchCode, tmp.CashSummIn AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 7 AS NomStr, '3.Движение ден. ср -в за месяц' AS InfoText, tmp.BranchCode, 0 AS Amount, tmp.CashSummOut AS Amount_Rashod FROM tmp
          UNION All
            SELECT 9 AS NomStr, '4.Реализация продукции за месяц по ф2 (отгрузка за минусом возвратов)' AS InfoText, tmp.BranchCode, (tmp.GoodsSummSale_sf-tmp.GoodsSummReturnIn_sf) AS Amount, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 10 AS NomStr, '             Оплачено' AS InfoText, tmp.BranchCode, 0 AS Amount, tmp.CashAmount AS Amount_Rashod FROM tmp
          UNION All
            SELECT 11 AS NomStr, '5.Всего обороты за месяц (2+3+4)' AS InfoText, tmp.BranchCode
                 , tmp.GoodsSummIn  + tmp.CashSummIn  + (tmp.GoodsSummSale_sf-tmp.GoodsSummReturnIn_sf) AS Amount
                 , tmp.GoodsSummOut + tmp.CashSummOut + tmp.CashAmount                                  AS Amount_Rashod
            FROM tmp
          UNION All
            SELECT 12 AS NomStr, '6.Задолженность филиала' AS InfoText, tmp.BranchCode, tmp.GoodsSummEnd + tmp.CashSummEnd + tmp.JuridicalSummEnd AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 13 AS NomStr, 'Конечный остаток продукции на складах филиалов' AS InfoText, tmp.BranchCode, tmp.GoodsSummEnd AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 14 AS NomStr, 'Конечный остаток денежных средств в кассах' AS InfoText, tmp.BranchCode, tmp.CashSummEnd, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 15 AS NomStr,  'Задолженность покупателей ф2 (кон)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummEnd AS Amount , 0 as Amount_Rashod FROM tmp
          /*UNION All
            SELECT  8 AS NomStr, 'Продажа' AS InfoText, tmp.BranchCode, tmp.JuridicalSummIn AS Amount, 0 as Amount_Rashod FROM tmp
          UNION All
            SELECT  8 AS NomStr, 'Продажа' AS InfoText, tmp.BranchCode, tmp.JuridicalSummOut AS Amount, 0 AS Amount_Rashod FROM tmp*/
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
--SELECT * FROM gpReport_Branch_App7_New (inStartDate:= '31.07.2015'::TDateTime, inEndDate:= '03.08.2015'::TDateTime, inBranchId:= 0, inSession:= zfCalc_UserAdmin())  --8374