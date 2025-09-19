-- Function: gpGet_Goods_MobilebyBarcode()

DROP FUNCTION IF EXISTS gpGet_Goods_MobilebyBarcode ( TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_MobilebyBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , CountGoods         Integer
             , BarCodePref        TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbCountGoods Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF SUBSTRING(inBarCode, 1, 4) = zc_BarCodePref_Object()
     THEN
       SELECT COUNT(*), MAX(Object.Id)
       INTO vbCountGoods, vbGoodsId
       FROM Object
       WHERE Object.DescId   = zc_Object_Goods()
         AND Object.ObjectCode = SUBSTRING(inBarCode, 5, 8)::Integer;     
     ELSE
       SELECT COUNT(*), MAX(Object.Id)
       INTO vbCountGoods, vbGoodsId
       FROM Object
            INNER JOIN ObjectString AS ObjectString_EAN
                                    ON ObjectString_EAN.ObjectId  = Object.Id
                                   AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                   AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)||'%'
       WHERE Object.DescId   = zc_Object_Goods();
       
       IF vbCountGoods = 0
       THEN 
          SELECT COUNT(*), MAX(Object.Id)
          INTO vbCountGoods, vbGoodsId
          FROM Object
               INNER JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId  = Object.Id
                                      AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                      AND ObjectString_Article.ValueData ILIKE TRIM (inBarCode)||'%'
          WHERE Object.DescId   = zc_Object_Goods();
       END IF;

       IF vbCountGoods = 0
       THEN 
          SELECT COUNT(*), MAX(Object.Id)
          INTO vbCountGoods, vbGoodsId
          FROM Object
               INNER JOIN ObjectString AS ObjectString_ArticleVergl
                                       ON ObjectString_ArticleVergl.ObjectId  = Object.Id
                                      AND ObjectString_ArticleVergl.DescId    = zc_ObjectString_ArticleVergl()
                                      AND ObjectString_ArticleVergl.ValueData ILIKE TRIM (inBarCode)||'%'
          WHERE Object.DescId   = zc_Object_Goods();
       END IF;

     END IF;

     -- �����
     IF COALESCE(vbCountGoods, 0) = 1
     THEN

       -- ���������
       RETURN QUERY
         SELECT Object_Goods.Id                             AS GoodsId
              , Object_Goods.ObjectCode                     AS GoodsCode
              , Object_Goods.ValueData                      AS GoodsName
              , ObjectString_Article.ValueData              AS Article
              , vbCountGoods                                AS CountGoods
              , zc_BarCodePref_Object()::TVarChar           AS BarCodePref
         FROM Object AS Object_Goods
              LEFT JOIN ObjectString AS ObjectString_Article
                                     ON ObjectString_Article.ObjectId = Object_Goods.Id
                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()
         WHERE Object_Goods.Id = vbGoodsId
        ;
        
     ELSE 

       -- RAISE EXCEPTION '������.�������� �/� = <%> �� ������.', inBarCode;

       RETURN QUERY
         SELECT 0::Integer                          AS GoodsId
              , NULL::Integer                       AS GoodsCode
              , NULL::TVarChar                      AS GoodsName
              , NULL::TVarChar                      AS Article
              , COALESCE(vbCountGoods, 0)           AS CountGoods
              , zc_BarCodePref_Object()::TVarChar   AS BarCodePref;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.24                                                       *
*/

-- ����
-- select * from gpGet_Goods_MobilebyBarcode(inBarCode := '0000001977548', inSession := '5');
