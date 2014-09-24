-- Function: gpCompletePeriod_Movement_FounderService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_FounderService (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpCompletePeriod_Movement_FounderService(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompletePeriod_FounderService());

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.14         *
*/

-- ����
-- SELECT * FROM gpCompletePeriod_Movement_FounderService (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
