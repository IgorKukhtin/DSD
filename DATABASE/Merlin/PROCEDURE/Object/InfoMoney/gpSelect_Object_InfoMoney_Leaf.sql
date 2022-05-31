-- Function: gpSelect_Object_InfoMoney_Leaf()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Leaf (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Leaf (Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_Leaf(
    IN inIsService   Boolean,       -- ���������� ������ �� ���������� �� / ���
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inKindName    TVarChar,      -- ����� ������ ���������� ������ ������ ��� ������ ������ 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , ParentId Integer, ParentName TVarChar
             , GroupNameFull TVarChar
             , isUserAll Boolean, isService Boolean, isLeaf Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT tmp.Id          AS Id 
        , tmp.Code
        , tmp.Name
        , tmp.isErased
        
        , tmp.InfoMoneyKindId
        , tmp.InfoMoneyKindName
        , tmp.ParentId
        , tmp.ParentName
        
        , tmp.GroupNameFull
        , tmp.isUserAll
        , tmp.isService
        , tmp.isLeaf

        , tmp.InsertName
        , tmp.InsertDate
        , tmp.UpdateName
        , tmp.UpdateDate
   FROM gpSelect_Object_InfoMoney (inIsShowAll, inSession) AS tmp
   WHERE tmp.Id NOT IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_InfoMoney_Parent())
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney_Parent (TRUE, FALSE,FALSE, 'zc_Enum_InfoMoney_In'::TVarChar, zfCalc_UserAdmin())