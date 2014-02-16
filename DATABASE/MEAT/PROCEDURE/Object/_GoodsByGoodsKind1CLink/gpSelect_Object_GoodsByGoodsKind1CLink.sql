-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MasterId TVarChar, BranchId Integer, BranchName TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- ���������
     RETURN QUERY 
       SELECT Object_GoodsByGoodsKind1CLink.Id               AS Id
            , Object_GoodsByGoodsKind1CLink.ObjectCode       AS Code
            , Object_GoodsByGoodsKind1CLink.ValueData        AS Name
            , (COALESCE (ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId, 0) :: TVarChar || '_' || COALESCE (ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId, 0) :: TVarChar) :: TVarChar AS MasterId
            , Object_Branch.Id
            , Object_Branch.ValueData
       FROM Object AS Object_GoodsByGoodsKind1CLink
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                 ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                 ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                 ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId   
       WHERE Object_GoodsByGoodsKind1CLink.DescId = zc_Object_GoodsByGoodsKind1CLink();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.14                                        * all
 28.01.14                        * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin()) WHERE Code = 