-- Function: gpSelect_Inventory_BarCode()

DROP FUNCTION IF EXISTS gpSelect_Inventory_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_BarCode(
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar
              )
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
 01.03.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Inventory_BarCode (inSession:= zfCalc_UserAdmin())
