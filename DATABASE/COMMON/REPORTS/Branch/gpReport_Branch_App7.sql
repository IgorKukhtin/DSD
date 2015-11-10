 -- Function: gpReport_Branch_App7()

DROP FUNCTION IF EXISTS gpReport_Branch_App7 (TDateTime, TDateTime,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Branch_App7(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inBranchId           Integer,    -- Филиал
    IN inSession            TVarChar    -- сессия пользователя
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

    
    -- Результат
     RETURN QUERY
   
   SELECT  'Филиал' ::TVarChar   AS BranchName
       
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.11.15         * 

*/

-- тест
-- SELECT * FROM gpReport_Branch_App7 (inStartDate:= '01.08.2015'::TDateTime, inEndDate:= '02.08.2015'::TDateTime, inBranchId:= 301310, inSession:= zfCalc_UserAdmin())  --запорожье
