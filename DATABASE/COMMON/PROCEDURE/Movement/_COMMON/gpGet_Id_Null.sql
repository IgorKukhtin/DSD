-- Function: gpGet_Id_Nul()

DROP FUNCTION IF EXISTS gpGet_Id_Nul (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Id_Nul(
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (Id TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       SELECT NULL :: Integer AS Id;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.23         *
*/

-- ����
-- SELECT * FROM gpGet_Id_Nul (inSession:= zfCalc_UserAdmin())
