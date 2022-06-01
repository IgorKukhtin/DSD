-- Function: gpSelect_Object_Cash_Parent()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash_Parent (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash_Parent(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ��� 
    IN inisLeaf      Boolean ,      -- ���������� ��� ��� ������ ������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , isLeaf Boolean
             , CurrencyId Integer, CurrencyName TVarChar
             , ParentId Integer, ParentName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ShortName TVarChar, GroupNameFull TVarChar
             , NPP Integer
             , Amount TFloat
             , isUserAll Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       SELECT tmp.Id
            , tmp.Code
            , tmp.Name
            , tmp.isErased
            , tmp.isLeaf
            , tmp.CurrencyId
            , tmp.CurrencyName
            , tmp.ParentId
            , tmp.ParentName
            , tmp.PaidKindId
            , tmp.PaidKindName
            , tmp.ShortName
            , tmp.GroupNameFull
            , tmp.NPP
            , tmp.Amount
            , tmp.isUserAll
            , tmp.InsertName
            , tmp.InsertDate
            , tmp.UpdateName
            , tmp.UpdateDate
       FROM gpSelect_Object_Cash(inIsShowAll, inSession)  AS tmp
       WHERE tmp.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Cash_Parent())   
          OR inisLeaf = True   --������ ������ ��� ��� ��������
      ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Cash_Parent (true, true, zfCalc_UserAdmin())
