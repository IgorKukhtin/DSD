-- Function: gpSelect_Object_GoodsTree (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTree (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTree(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer, GoodsGroupName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsGroup());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name
           , Object_Parent.Id                   AS ParentId
           , Object_Parent.ValueData            AS GoodsGroupName
           , Object_GoodsGroup.isErased         AS isErased
           
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
              AND (Object_GoodsGroup.isErased = FALSE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
09.03.17                                                            *

        
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroup (TRUE, zfCalc_UserAdmin())