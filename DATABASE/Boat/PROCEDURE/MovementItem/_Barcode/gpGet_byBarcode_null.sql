-- Function: gpGet_byBarcode_null()

DROP FUNCTION IF EXISTS gpGet_byBarcode_null (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_byBarcode_null(
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (BarCode    TVarChar
             , PartNumber TVarChar
             , Amount     TFloat
              )
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY

       SELECT ''::TVarChar AS BarCode
            , ''::TVarChar AS PartNumber
            , 1 ::TFloat   AS Amount;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.03.22         *
*/

-- ����
-- SELECT * FROM gpGet_byBarcode_null (inSession:= zfCalc_UserAdmin());
