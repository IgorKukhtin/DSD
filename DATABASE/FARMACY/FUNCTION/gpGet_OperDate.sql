-- Function: gpGet_OperDate()

DROP FUNCTION IF EXISTS gpGet_OperDate(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OperDate(
   OUT OperDate              TDateTime,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime
AS
$BODY$
BEGIN
  OperDate := CURRENT_DATE;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.04.20                                                       *
*/

-- SELECT * FROM gpGet_OperDate (inSession := zfCalc_UserAdmin())