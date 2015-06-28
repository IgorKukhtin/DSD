DROP FUNCTION IF EXISTS gpSelect_AlternativeGroup_Goods(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AlternativeGroup_Goods(
	IN inIsShowDel     boolean,       -- ���������� 0-������ ������� ������ / 1 - ��� �� ��������� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (AlternativeGroupId Integer, 
  GoodsId Integer, GoodsCode INTEGER, GoodsName TVarChar, isErased boolean) 
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
BEGIN
  vbUserId:= lpGetUserBySession (inSession);
  -- ����������� �� �������� ��������� �����������
  vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
  -- ���������
  RETURN QUERY
    SELECT
      Object_AlternativeGroup_View.Id   as AlternativeGroupId,
	  Object_Goods_View.Id              as GoodsId,
	  Object_Goods_View.GoodsCodeInt    as GoodsCode,
	  Object_Goods_View.GoodsName       as GoodsName,
	  Object_Goods_View.IsErased        as isErased
    FROM Object_AlternativeGroup_View
	  INNER JOIN objectlink AS object_goodslink_alternativegroup
                            ON object_goodslink_alternativegroup.childobjectid = Object_AlternativeGroup_View.Id
                           AND object_goodslink_alternativegroup.descid = zc_ObjectLink_Goods_AlternativeGroup()
      Inner JOIN Object_Goods_View ON Object_Goods_View.ID = object_goodslink_alternativegroup.objectid
                    
	WHERE
      Object_Goods_View.ObjectId = vbobjectid
      AND
      (
        inIsShowDel = True
        or
        Object_Goods_View.iserased = False
      )
    ORDER BY
      GoodsName;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_AlternativeGroup_Goods(Boolean,TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 28.06.15                                                        *

*/

-- ����
-- SELECT * FROM gpSelect_AlternativeGroup_Goods (True,'3');