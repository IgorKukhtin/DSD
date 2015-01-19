-- Function: gpSelect_Scale_OperDate (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Scale_OperDate (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_OperDate(
    IN inSession     TVarChar      -- ������ ������������
)
RETURNS TABLE (OperDate  TDateTime)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
      SELECT DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) :: TDateTime AS OperDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_OperDate (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Scale_OperDate (zfCalc_UserAdmin())
