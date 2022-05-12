-- Function: gpGet_MIInventory_byBarcode()

DROP FUNCTION IF EXISTS gpGet_byBarcode ( TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Send_byBarcode (Integer, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MIInventory_byBarcode (Integer, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_byBarcode (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_byBarcode(
    IN inMovementId        Integer    , -- ���� ������� <��������>
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbGoodsId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inBarCode,'') = '' -- AND COALESCE (inPartNumber,'') = ''
     THEN
         -- ���������
         RETURN QUERY
           SELECT NULL  :: Integer  AS GoodsId
                , 0  :: Integer  AS GoodsCode
                , NULL :: TVarChar AS GoodsName
                , '' :: TVarChar AS Article
                 ;

     ELSE
         -- �����
         vbGoodsId:= (SELECT tmp.GoodsId FROM gpGet_Partion_byBarcode (inBarCode, inPartNumber, inSession) AS tmp);
    
         -- ���������
         RETURN QUERY
           SELECT Object_Goods.Id                             AS GoodsId
                , Object_Goods.ObjectCode                     AS GoodsCode
                , Object_Goods.ValueData                      AS GoodsName
                , ObjectString_Article.ValueData              AS Article
           FROM Object AS Object_Goods
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()
           WHERE Object_Goods.Id = vbGoodsId
          ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.22         *
*/

-- ����
-- SELECT * FROM gpGet_MI_byBarcode (inMovementId := 0, inBarCode:= '6416868200539', inPartNumber:= '', inAmount:= 1, inSession:= zfCalc_UserAdmin());
