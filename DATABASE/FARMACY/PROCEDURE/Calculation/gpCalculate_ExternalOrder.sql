-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpCalculate_ExternalOrder (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpCalculate_ExternalOrder(
    IN inInternalOrder Integer  ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
--     vbUserId:= lpGetUserBySession (inSession);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpCalculate_ExternalOrder (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')