-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PaidType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PaidType(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, PaidTypeCode Integer, PaidTypeName TVarChar) 
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
  vbUserId:= lpGetUserBySession (inSession);
  -- ����������� �� �������� ��������� �����������
  -- ���������
  RETURN QUERY
    SELECT 
      PaidType.Id
     ,PaidType.PaidTypeCode
     ,PaidType.PaidTypeName
    FROM Object_PaidType_View AS PaidType
    ORDER BY
      PaidType.PaidTypeCode;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PaidType(TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�
 06.07.15                                                          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_PaidType ('3');