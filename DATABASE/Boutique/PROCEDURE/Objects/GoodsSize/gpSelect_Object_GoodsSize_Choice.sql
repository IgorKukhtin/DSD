-- Function: gpSelect_Object_GoodsSize_Choice (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSize_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSize_Choice(
    IN inGoodsId     Integer,
    IN inSession     TVarChar       --  ������ ������������
)
RETURNS TABLE (Id          Integer
             , Code        Integer
             , Name        TVarChar
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       SELECT DISTINCT
             Object_GoodsSize.Id            AS id
           , Object_GoodsSize.ObjectCode    AS Code
           , Object_GoodsSize.ValueData     AS Name
       
       FROM Object_PartionGoods 
            LEFT JOIN Object AS Object_GoodsSize on Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId
       WHERE Object_PartionGoods.GoodsId = inGoodsId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
30.06.17          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsSize_Choice (0, zfCalc_UserAdmin())