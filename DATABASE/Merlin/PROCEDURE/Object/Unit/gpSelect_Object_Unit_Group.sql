-- Function: gpSelect_Object_Unit (Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Parent (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Parent(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���   
    IN inisLeaf      Boolean ,      -- ���������� ��� ��� ������ ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameFull TVarChar
             , Phone TVarChar, GroupNameFull TVarChar
             , Comment TVarChar
             , ParentId Integer, ParentName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , isLeaf Boolean
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY

       SELECT
             Object_Unit.Id
           , Object_Unit.Code
           , Object_Unit.Name
           , Object_Unit.NameFull ::TVarChar
           , Object_Unit.Phone
           , Object_Unit.GroupNameFull
           , Object_Unit.Comment
           , Object_Unit.ParentId
           , Object_Unit.ParentName

           , Object_Unit.InsertName
           , Object_Unit.InsertDate
           , Object_Unit.UpdateName
           , Object_Unit.UpdateDate
           
           , Object_Unit.isLeaf
           , Object_Unit.isErased

       FROM gpSelect_Object_Unit (inIsShowAll, inSession) AS Object_Unit
       WHERE Object_Unit.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Parent())
          OR inisLeaf = TRUE   --������ "������"   ��� ��� 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
 26.05.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit_Parent (TRUE, false, zfCalc_UserAdmin())
