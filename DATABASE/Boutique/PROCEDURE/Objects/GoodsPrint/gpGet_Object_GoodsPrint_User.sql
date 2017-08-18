-- Function: gpGet_Object_Goods_BarCode()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPrint_User(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPrint_User(
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (UserId Integer
             , UserName TVarChar
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ���������
      RETURN QUERY
      SELECT vbUserId                          ::Integer  AS vbUserId
           , lfGet_Object_ValueData (vbUserId) ::TVarChar AS UserName
      ; 

   
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 18.08.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsPrint_User (zfCalc_UserAdmin())
