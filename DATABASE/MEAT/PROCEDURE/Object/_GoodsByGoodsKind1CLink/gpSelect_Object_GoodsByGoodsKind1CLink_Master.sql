-- Function: gpSelect_Object_GoodsByGoodsKind1CLink_Master (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind1CLink_Master (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink_Master(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MasterId TVarChar
             , GoodsKindId Integer
             , GoodsKindName TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink_Master());
   
     -- ���������
     RETURN QUERY 
       SELECT
             0 ::Integer Id
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
            , (COALESCE (Object_GoodsByGoodsKind_View.GoodsId, 0) :: TVarChar || '_' || COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) :: TVarChar) :: TVarChar AS MasterId
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindName

       FROM Object_GoodsByGoodsKind_View
      UNION ALL
       SELECT
             0 ::Integer Id
           , Object.Id AS GoodsId
           , Object.ObjectCode AS GoodsCode
           , Object.ValueData AS GoodsName
            , (COALESCE (Object.Id, 0) :: TVarChar || '_'|| '0') :: TVarChar AS MasterId
           , 0 ::Integer AS GoodsKindId
           , '' ::TVarChar AS GoodsKindName
       FROM Object
       WHERE Object.DescId = zc_Object_Goods()
         AND Object.Id IN (7645, 7601, 6779, 6816) -- �������
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink_Master (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.14                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink_Master (zfCalc_UserAdmin())
