-- Function: gpSelect_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               NameFull TVarChar, NameUser TVarChar, ValueData TVarChar,
               ParentId Integer, ParentName TVarChar,
               isErased boolean, isLeaf boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ���������
   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code
           , Object_ToolsWeighing_View.Name
           , Object_ToolsWeighing_View.NameFull
           , Object_ToolsWeighing_View.NameUser
           , Object_ToolsWeighing_View.ValueData
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.ParentName
           , Object_ToolsWeighing_View.isErased
           , Object_ToolsWeighing_View.isLeaf
       FROM Object_ToolsWeighing_View

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighing (zfCalc_UserAdmin())
