-- Function: gpSelect_Period_byRemainsOLAPTable()
DROP FUNCTION IF EXISTS gpSelect_Period_byRemainsOLAPTable (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Period_byRemainsOLAPTable(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (StartDate TDateTime, EndDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

 
      RETURN QUERY
         WITH 
         tmpDate AS (SELECT generate_series ( inStartDate, inEndDate, '1 MONTH' :: INTERVAL) AS OperDate)

         SELECT tmpDate.OperDate ::TDateTime
              , (tmpDate.OperDate + INTERVAL '1 MONTH' - INTERVAL '1 Day') :: TDateTime
         FROM tmpDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.06.20         *
*/

-- ����
-- select * from  gpSelect_Period_byRemainsOLAPTable (inStartDate :='01.01.2020':: TDateTime, inEndDate:= '01.10.2020':: TDateTime , inSession := '5' ::TVarChar)