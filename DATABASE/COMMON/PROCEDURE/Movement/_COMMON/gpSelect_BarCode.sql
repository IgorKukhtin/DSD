-- Function: gpSelect_BarCode()

DROP FUNCTION IF EXISTS gpSelect_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_BarCode(
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       SELECT NULL :: TVarChar AS BarCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.18         *
*/

-- ����
-- SELECT * FROM gpSelect_BarCode (inSession:= zfCalc_UserAdmin())
