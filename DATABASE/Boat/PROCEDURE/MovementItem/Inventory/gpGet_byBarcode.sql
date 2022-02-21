-- Function: gpGet_byBarcode()

DROP FUNCTION IF EXISTS gpGet_byBarcode ( TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
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

       SELECT inBarCode    AS BarCode
            , inPartNumber AS PartNumber
            , inAmount     AS Amount;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.22         *
*/

-- ����
-- SELECT * FROM gpGet_byBarcode (inBarCode:= '2210002798265'::TVarChar, inPartNumber:= 'czscz'::TVarChar, inAmount:=0, inSession:= zfCalc_UserAdmin());
