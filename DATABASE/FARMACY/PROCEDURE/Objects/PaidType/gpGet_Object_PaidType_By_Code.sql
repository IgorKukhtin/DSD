DROP FUNCTION IF EXISTS gpGet_Object_PaidType_By_Code (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PaidType_By_Code(
    IN inCode        Integer,       -- ��� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, PaidTypeCode Integer, PaidTypeName TVarChar)
AS
$BODY$
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Price());
  IF NOT EXISTS(Select 1 from Object_PaidType_View Where Object_PaidType_View.PaidTypeCode = inCode) THEN
    PERFORM gpInsertUpdate_Object_PaidType(0,inCode,''); 
  END IF;
  RETURN QUERY
    SELECT
      Object_PaidType_View.Id
     ,Object_PaidType_View.PaidTypeCode
     ,Object_PaidType_View.PaidTypeName
    FROM Object_PaidType_View
    WHERE Object_PaidType_View.PaidTypeCode = inCode;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PaidType_By_Code (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 06.07.15                                                          *
*/

-- ����
-- SELECT * FROM gpGet_Object_PaidType_By_Code (1, '')
