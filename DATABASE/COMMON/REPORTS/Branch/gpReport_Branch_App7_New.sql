-- Function: gpReport_Branch_App7_New()

DROP FUNCTION IF EXISTS gpReport_Branch_App7_New (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7_New(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- ������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (NomStr integer, InfoText TVarChar
              , Amount2 TFloat, Amount3 TFloat, Amount4 TFloat, Amount5 TFloat
             , Amount7 TFloat, Amount9 TFloat, Amount11 TFloat, Amount12 TFloat      
             , Amount2_Rashod TFloat, Amount3_Rashod TFloat, Amount4_Rashod TFloat, Amount5_Rashod TFloat
             , Amount7_Rashod TFloat, Amount9_Rashod TFloat, Amount11_Rashod TFloat, Amount12_Rashod TFloat       
              )
AS
$BODY$
   
BEGIN

    -- ���������
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

            , SUM (CASE WHEN tmpList.BranchCode = 2 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount2_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 3 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount3_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 4 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount4_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 5 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount5_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 7 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount7_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 9 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount9_Rashod
            , SUM (CASE WHEN tmpList.BranchCode = 11 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount11_Rashod
            , SUM (CASE WHEN tmpList.BranchCode > 11 THEN tmpList.Amount_Rashod ELSE 0 END) ::TFloat AS Amount12_Rashod
            
       FROM(
            SELECT 1 AS NomStr, '��������� ������� ��������� �� ������� ��������' AS InfoText, tmp.BranchCode, tmp.GoodsSummStart AS Amount, 0 AS Amount_Rashod  FROM tmp 
          UNION All
            SELECT 10 AS NomStr, '�������� ������� ��������� �� ������� ��������' AS InfoText, tmp.BranchCode, tmp.GoodsSummEnd AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 5 AS NomStr, '�������� ��������� �� �����' AS InfoText, tmp.BranchCode, tmp.GoodsSummIn AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 5 AS NomStr, '�������� ��������� �� �����' AS InfoText, tmp.BranchCode, 0 AS Amount , tmp.GoodsSummOut AS Amount_Rashod FROM tmp
          UNION All
            SELECT 7 AS NomStr, '���������� ��������� �� ����� �� �2 (�������� �� ������� ���������)' AS InfoText, tmp.BranchCode, (tmp.GoodsSummSale_sf-tmp.GoodsSummReturnIn_sf) AS Amount, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 2 AS NomStr, '��������� ������� �������� ������� � ������' AS InfoText, tmp.BranchCode, tmp.CashSummStart, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 11 AS NomStr, '�������� ������� �������� ������� � ������' AS InfoText, tmp.BranchCode, tmp.CashSummEnd, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 6 AS NomStr, '�������� ���. �� -� �� �����' AS InfoText, tmp.BranchCode, tmp.CashSummIn AS Amount, 0 AS Amount_Rashod FROM tmp
          UNION All
            SELECT 6 AS NomStr, '�������� ���. �� -� �� �����' AS InfoText, tmp.BranchCode, 0 AS Amount, tmp.CashSummOut AS Amount_Rashod FROM tmp
          UNION All
            SELECT 8 AS NomStr, '��������' AS InfoText, tmp.BranchCode, 0 AS Amount, tmp.CashAmount AS Amount_Rashod FROM tmp
          UNION All
            SELECT 3 AS NomStr, '������������� ����������� �2 (���)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummstart AS Amount, 0 AS Amount_Rashod  FROM tmp
          UNION All
            SELECT 12 AS NomStr,  '������������� ����������� �2 (���)' AS InfoText, tmp.BranchCode, tmp.JuridicalSummEnd AS Amount , 0 as Amount_Rashod FROM tmp
          /*UNION All
            SELECT  8 AS NomStr, '�������' AS InfoText, tmp.BranchCode, tmp.JuridicalSummIn AS Amount, 0 as Amount_Rashod FROM tmp
          UNION All
            SELECT  8 AS NomStr, '�������' AS InfoText, tmp.BranchCode, tmp.JuridicalSummOut AS Amount, 0 AS Amount_Rashod FROM tmp*/
        ) AS tmpList
       GROUP BY tmpList.NomStr , tmpList.InfoText
       ORDER BY 1

      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.11.15         * 

*/

--
--SELECT * FROM gpReport_Branch_App7_New (inStartDate:= '31.07.2015'::TDateTime, inEndDate:= '03.08.2015'::TDateTime, inBranchId:= 0, inSession:= zfCalc_UserAdmin())  --8374