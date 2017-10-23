-- Function: gpGet_Object_Member_ScalePSW (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member_ScalePSW (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member_ScalePSW(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_Member_ScalePSW());


     -- ���������
     RETURN QUERY
       SELECT Object.Id, Object.ObjectCode AS Code, Object.ValueData AS Name
       FROM Object 
       WHERE Object.Id = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.17                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Member_ScalePSW (inId:= 13117, inSession:= zfCalc_UserAdmin())
