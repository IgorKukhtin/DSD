-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , WeightPackage TFloat, WeightTotal TFloat
             , isOrder Boolean)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT
             Object_GoodsByGoodsKind_View.Id 
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindName
           
           , COALESCE (ObjectFloat_WeightPackage.ValueData,0)::TFloat  AS WeightPackage
           , COALESCE (ObjectFloat_WeightTotal.ValueData,0)  ::TFloat  AS WeightTotal
           , COALESCE (ObjectBoolean_Order.ValueData, False)           AS isOrder
           
       FROM Object_GoodsByGoodsKind_View
           LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                 ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

           LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                 ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                   ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id 
                                  AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()

;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.15        * add redmine 17.03.2015
 29.01.14                        * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind(zfCalc_UerAdmin())