-- Function: gpSelect_Object_AlternativeGoodsCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AdditionalGoodsChild(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AdditionalGoodsChild(
    IN inRetailId    Integer,       -- �������� ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsMainName TVarChar
             , GoodsId Integer    
             ) AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());

   RETURN QUERY 
     SELECT 
           Object_AdditionalGoods_View.Id               
         , Object_AdditionalGoods_View.GoodsMainId
         , Object_AdditionalGoods_View.GoodsMainName
         , Object_AdditionalGoods_View.GoodsId
         
     FROM Object_AdditionalGoods_View
           
     WHERE Object_AdditionalGoods_View.RetailId = inRetailId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AdditionalGoodsChild (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.08.14                        *

*/

-- ����
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
