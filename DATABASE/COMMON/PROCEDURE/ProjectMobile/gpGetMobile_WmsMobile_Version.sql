-- Function: gpGetMobile_WmsMobile_Version (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_WmsMobile_Version (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_WmsMobile_Version(
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (APKFileName     TVarChar
             , MajorVersion    Integer
             , MinorVersion    Integer
)
AS
$BODY$
  DECLARE vbUserId     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       -- ���������
       SELECT OBJECT.ValueData
            , COALESCE(MajorVersion.ValueData, 0)::INTEGER
            , COALESCE(MinorVersion.ValueData, 0)::INTEGER 
       FROM OBJECT 
       LEFT JOIN ObjectFloat AS MajorVersion 
         ON MajorVersion.objectid = OBJECT.id AND MajorVersion.DescId = zc_ObjectFloat_Program_MajorVersion()
       LEFT JOIN ObjectFloat AS MinorVersion 
         ON MinorVersion.objectid = OBJECT.id AND MinorVersion.DescId = zc_ObjectFloat_Program_MinorVersion()
       WHERE Object.ValueData = 'WmsMobile.apk' AND Object.DescId = zc_Object_Program();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.   ������ �.�.
 26.08.26                                                                    *
*/
-- ����
-- SELECT * FROM gpGetMobile_WmsMobile_Version (inSession:= zfCalc_UserAdmin())
