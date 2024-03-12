-- Function: gpGet_Goods_MobilebyBarcode()

DROP FUNCTION IF EXISTS gpGet_Goods_MobilebyBarcode ( TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_MobilebyBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , CountGoods         Integer
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbCountGoods Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF SUBSTRING(inBarCode, 1, 2) = '00'
     THEN
       SELECT COUNT(*), MAX(Object.Id)
       INTO vbCountGoods, vbGoodsId
       FROM Object
       WHERE Object.DescId   = zc_Object_Goods()
         AND Object.Id = inBarCode::Integer;     
     ELSE
       SELECT COUNT(*), MAX(Object.Id)
       INTO vbCountGoods, vbGoodsId
       FROM Object
            INNER JOIN ObjectString AS ObjectString_EAN
                                    ON ObjectString_EAN.ObjectId  = Object.Id
                                   AND ObjectString_EAN.DescId    = zc_ObjectString_EAN()
                                   AND ObjectString_EAN.ValueData ILIKE TRIM (inBarCode)||'%'
       WHERE Object.DescId   = zc_Object_Goods();
     END IF;

     -- Нашли
     IF COALESCE(vbCountGoods, 0) = 1
     THEN

       -- Результат
       RETURN QUERY
         SELECT Object_Goods.Id                             AS GoodsId
              , Object_Goods.ObjectCode                     AS GoodsCode
              , Object_Goods.ValueData                      AS GoodsName
              , ObjectString_Article.ValueData              AS Article
              , vbCountGoods                                AS CountGoods
         FROM Object AS Object_Goods
              LEFT JOIN ObjectString AS ObjectString_Article
                                     ON ObjectString_Article.ObjectId = Object_Goods.Id
                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()
         WHERE Object_Goods.Id = vbGoodsId
        ;
        
     ELSE 

       RETURN QUERY
         SELECT 0::Integer                          AS GoodsId
              , NULL::Integer                       AS GoodsCode
              , NULL::TVarChar                      AS GoodsName
              , NULL::TVarChar                      AS Article
              , COALESCE(vbCountGoods, 0)           AS CountGoods;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.03.24                                                       *
*/

-- тест
-- 
select * from gpGet_Goods_MobilebyBarcode(inBarCode := '000000197941', inSession := '5');