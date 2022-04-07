-- Function: gpGet_MI_Send_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MI_Send_byBarcode (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send_byBarcode(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id                 Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , Article            TVarChar
             , PartNumber         TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupId       Integer
             , GoodsGroupName     TVarChar
             , CountForPrice      TFloat
             , OperPrice          TFloat
             , TotalCount         TFloat
             , Amount             TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbGoodsId   Integer;
   DECLARE vbPartNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inBarCode,'') = '' AND COALESCE (inPartNumber,'') = '' THEN
       RETURN QUERY
       SELECT -1 :: Integer  AS Id
            , 0  :: Integer  AS GoodsId
            , 0  :: Integer  AS GoodsCode
            , '' :: TVarChar AS GoodsName
            , 0  :: Integer  AS PartnerId
            , '' :: TVarChar AS PartnerName
            , '' :: TVarChar AS Article
            , '' :: TVarChar AS PartNumber
            , '' :: TVarChar AS GoodsGroupNameFull
            , 0  :: Integer  AS GoodsGroupId
            , '' :: TVarChar AS GoodsGroupName
            , 1  :: TFloat   AS CountForPrice
            , 0  :: TFloat   AS OperPrice
            , 0  :: TFloat   AS TotalCount
            , 1  :: TFloat   AS Amount
             ;
     ELSE
    

     -- Нашли
     SELECT tmp.PartionId
          , tmp.GoodsId
          , tmp.PartNumber
            INTO vbPartionId, vbGoodsId, vbPartNumber
     FROM gpGet_Partion_byBarcode (inBarCode, inPartNumber, inSession) AS tmp;

     -- проверка
     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Ошибка в Штрихкоде <%>  или  S/N <%>.', inBarCode, inPartNumber;
     END IF;
  
     -- Результат
     RETURN QUERY
       SELECT -1                               :: Integer AS Id
            , Object_Goods.Id                             AS GoodsId
            , Object_Goods.ObjectCode                     AS GoodsCode
            , Object_Goods.ValueData                      AS GoodsName
            , Object_Partner.ObjectCode                   AS PartnerId
            , Object_Partner.ValueData                    AS PartnerName
            , ObjectString_Article.ValueData              AS Article
            , inPartNumber    ::TVarChar                  AS PartNumber
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_GoodsGroup.Id                        AS GoodsGroupId
            , Object_GoodsGroup.ValueData                 AS GoodsGroupName
            , 1 :: TFloat AS CountForPrice
            , Object_PartionGoods.ekPrice                 AS OperPrice
            , (COALESCE (inAmount,1) + COALESCE ((SELECT SUM (MI.Amount)
                                                  FROM MovementItem AS MI
                                                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                  WHERE MI.MovementId = inMovementId
                                                    AND MI.DescId = zc_MI_Master()
                                                    AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE
                                                    AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                                                    ), 0)
              )                                 :: TFloat AS TotalCount
            , COALESCE (inAmount,1)             :: TFloat AS Amount

       FROM Object AS Object_Goods
 
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = Object_Goods.Id AND Object_PartionGoods.MovementItemId = vbPartionId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                 ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_Goods_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, ObjectLink_Goods_Partner.ChildObjectId)

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.22         *
*/

-- тест
--