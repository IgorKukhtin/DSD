-- Function: gpSelect_MI_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_BarCode(
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, BarCode TVarChar, BarCode_str TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       SELECT 0    :: Integer  AS Id
            , NULL :: TVarChar AS BarCode
            , NULL :: TVarChar AS BarCode_str;
  
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
