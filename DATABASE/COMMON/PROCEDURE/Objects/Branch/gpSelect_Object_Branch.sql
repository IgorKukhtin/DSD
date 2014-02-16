-- Function: gpSelect_Object_Branch(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Branch (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Branch(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());
   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ���������
   RETURN QUERY 
   SELECT Object.Id           AS Id
        , Object.ObjectCode   AS Code
        , Object.ValueData    AS Name
        , Object.isErased     AS isErased
   FROM Object
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object.AccessKeyId
   WHERE Object.DescId = zc_Object_Branch()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Branch(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 10.05.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())