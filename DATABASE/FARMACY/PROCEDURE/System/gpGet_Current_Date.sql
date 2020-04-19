-- Function: gpGet_Current_Date()

DROP FUNCTION IF EXISTS gpGet_Current_Date (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Current_Date(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TDateTime
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     RETURN CURRENT_DATE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.03.18         *

*/

-- ����
-- SELECT * FROM gpGet_Current_Date (inSession:= '2')