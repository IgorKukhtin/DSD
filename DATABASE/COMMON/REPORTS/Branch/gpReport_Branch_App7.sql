 -- Function: gpReport_Branch_App7()

DROP FUNCTION IF EXISTS gpReport_Branch_App7 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- ������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (BranchName TVarChar
             
             , SummStart TFloat
             , SummEnd TFloat
             , SummEnd_calc TFloat
            
             , SummTotalIn TFloat
             , SummTotalOut TFloat

             ,StartAmount TFloat, StartAmountd TFloat, StartAmountk TFloat
             ,Debetsumm TFloat, Kreditsumm TFloat
             ,EndAmount TFloat, EndAmountd TFloat, EndAmountk  TFloat

              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
          vbUserId:= lpGetUserBySession (inSession);

    
    -- ���������
     RETURN QUERY
   
   SELECT  '������' ::TVarChar   AS BranchName
       
        , CAST (0         AS TFloat) AS SummStart
        , CAST (0              AS TFloat) AS SummEnd
        , CAST (0         AS TFloat) AS SummEnd_calc
     
        , CAST (0         AS TFloat) AS SummTotalIn
        , CAST (0        AS TFloat) AS SummTotalOut
        

        , CAST (0  AS TFloat) AS StartAmount
        , CAST (0 AS TFloat) AS StartAmountd
        , CAST (0 AS TFloat) AS StartAmountk
        , CAST (0 AS TFloat) AS Debetsumm
        , CAST (0 AS TFloat) AS Kreditsumm
        , CAST (0 AS TFloat) AS EndAmount
        , CAST (0 AS TFloat) AS EndAmountd
        , CAST (0 AS TFloat) AS EndAmountk

            
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.11.15         * 

*/

-- ����
-- SELECT * FROM gpReport_Branch_App7 (inStartDate:= '01.08.2015'::TDateTime, inEndDate:= '02.08.2015'::TDateTime, inBranchId:= 301310, inSession:= zfCalc_UserAdmin())  --���������
