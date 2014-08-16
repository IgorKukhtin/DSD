-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BranchLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BranchLink(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, BranchLinkName TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- ���������
     RETURN QUERY 
         SELECT Object_BranchLink_View.id,
                Object_BranchLink_View.BranchLinkName
       FROM Object_BranchLink_View;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.08.14                        * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin()) WHERE Code = 