-- Function: gpSelect_Object_GoodsPhoto(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPhoto(
    IN inGoodsId      Integer, 
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsCondition());

   RETURN QUERY 
     SELECT 
           Object_GoodsPhoto.Id        AS Id,
           Object_GoodsPhoto.ValueData AS FileName
     FROM Object AS Object_GoodsPhoto
          JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
            ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
           AND ObjectLink_GoodsPhoto_Goods.DescId = zc_ObjectLink_GoodsPhoto_Goods()
           AND ObjectLink_GoodsPhoto_Goods.ChildObjectId = inGoodsId
     WHERE Object_GoodsPhoto.DescId = zc_Object_GoodsPhoto(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsCondition ('2')