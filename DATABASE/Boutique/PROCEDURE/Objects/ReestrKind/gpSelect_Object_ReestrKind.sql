-- Function: gpSelect_Object_ReestrKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReestrKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReestrKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_ReestrKind());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!������ ��� ������!!!
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
   THEN
       RETURN QUERY 
          SELECT
               Object_ReestrKind.Id           AS Id 
             , Object_ReestrKind.ObjectCode   AS Code
             , Object_ReestrKind.ValueData    AS Name
             , Object_ReestrKind.isErased     AS isErased
          FROM Object AS Object_ReestrKind
          WHERE Object_ReestrKind.DescId = zc_Object_ReestrKind();
  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReestrKind ('5')
