-- Function: gpGetDate_MovementJournal()

DROP FUNCTION IF EXISTS gpGetDate_MovementJournal (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGetDate_MovementJournal(
    IN inStartDate      TDateTime,  --
    IN inEndDate        TDateTime,  --
   OUT outStartDate     TDateTime,  -- 
   OUT outEndDate       TDateTime,  --
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     SELECT DATE_TRUNC ('MONTH', inStartDate) :: TDateTime
         , (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') :: TDateTime
       INTO outStartDate, outEndDate
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.05.18         *

*/

-- ����
-- SELECT * FROM gpGetDate_MovementJournal ('07.04.2018', '07.05.2018', inSession:= '2')