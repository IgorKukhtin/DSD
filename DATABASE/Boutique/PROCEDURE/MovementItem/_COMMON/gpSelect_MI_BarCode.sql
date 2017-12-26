-- Function: gpSelect_MI_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_BarCode(
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       SELECT NULL :: TVarChar AS BarCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.12.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_BarCode (inSession:= zfCalc_UserAdmin())
