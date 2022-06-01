-- Function: gpSelect_Object_InfoMoney_Parent()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Parent (Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Parent (Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_Parent(
    IN inisService   Boolean,       -- ���������� ������ �� ���������� �� / ���
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inisLeaf      Boolean ,      -- ���������� ��� ��� ������ ������
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
   DECLARE vbAccessKeyAll Boolean;
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
   WHERE tmp.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_InfoMoney_Parent())
      OR inisLeaf = TRUE   --������ "������"   ��� ��� 
   
      /*WHERE (COALESCE (tmp.isService, FALSE) = inisService OR inisService = FALSE)
    AND ( ((inKindName = 'zc_Enum_InfoMoney_In' AND tmp.InfoMoneyKindId = zc_Enum_InfoMoney_In()) OR COALESCE (tmp.InfoMoneyKindId,0)=0)  
         OR ((inKindName = 'zc_Enum_InfoMoney_Out' AND tmp.InfoMoneyKindId = zc_Enum_InfoMoney_Out()) OR COALESCE (tmp.InfoMoneyKindId,0)=0)
         OR COALESCE (inKindName,'') = ''  
        )*/
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.22         *
 16.01.22         * inKindName
 14.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney_Parent (TRUE, FALSE,FALSE, 'zc_Enum_InfoMoney_In'::TVarChar, zfCalc_UserAdmin())