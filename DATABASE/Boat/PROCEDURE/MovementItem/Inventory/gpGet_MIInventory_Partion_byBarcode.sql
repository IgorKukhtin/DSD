-- Function: gpGet_MIInventory_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MIInventory_Partion_byBarcode(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inBarCode           TVarChar   , --
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id                 Integer
             , PartionId          Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , PartNumber         TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupId       Integer
             , GoodsGroupName     TVarChar
             , MeasureName        TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , Price              TFloat
             , AmountRemains      TFloat
             , TotalCount         TFloat
             , OperCount          TFloat
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

     IF inBarCode = '' AND inPartNumber = '' THEN
       RETURN QUERY
       SELECT 0  :: Integer  AS Id
            , 0  :: Integer  AS PartionId
            , 0  :: Integer  AS GoodsId
            , 0  :: Integer  AS GoodsCode
            , '' :: TVarChar AS GoodsName
            , '' :: TVarChar AS Article
            , '' :: TVarChar AS PartNumber
            , '' :: TVarChar AS GoodsGroupNameFull
            , 0  :: Integer  AS GoodsGroupId
            , '' :: TVarChar AS GoodsGroupName
            , '' :: TVarChar AS MeasureName
            , 0  :: Integer  AS PartnerId
            , '' :: TVarChar AS PartnerName
            , 0  :: TFloat   AS Price
            , 0  :: TFloat   AS AmountRemains
            , 0  :: TFloat   AS TotalCount
            , 0  :: TFloat   AS OperCount
             ;
     END IF;
     

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
  
     -- из шапки берем подразделение для остатков
     vbUnitId := (SELECT MovementLinkObject.ObjectId 
                  FROM MovementLinkObject 
                  WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
                    AND MovementLinkObject.MovementId = inMovementId
                 );

     -- Результат
     RETURN QUERY
       WITH
       tmpRemains AS (SELECT Container.PartionId AS PartionId
                           , Container.Amount    AS Remains
                      FROM Container
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.ObjectId       = Container.ObjectId
                      WHERE Container.DescId        = zc_Container_Count()
                        AND Container.ObjectId      = vbGoodsId
                        AND Container.PartionId     = vbPartionId
                        AND Container.WhereObjectId = vbUnitId
                      --AND Container.Amount <> 0
                      )


       SELECT -1                               :: Integer AS Id
            , Object_PartionGoods.MovementItemId          AS PartionId
            , Object_Goods.Id                             AS GoodsId
            , Object_Goods.ObjectCode                     AS GoodsCode
            , Object_Goods.ValueData                      AS GoodsName
            , ObjectString_Article.ValueData              AS Article
            , vbPartNumber    ::TVarChar                  AS PartNumber
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_GoodsGroup.Id                        AS GoodsGroupId
            , Object_GoodsGroup.ValueData                 AS GoodsGroupName
            , Object_Measure.ValueData                    AS MeasureName
            , Object_Partner.ObjectCode                   AS PartnerId
            , Object_Partner.ValueData                    AS PartnerName
            , Object_PartionGoods.ekPrice                 AS Price
            , tmpRemains.Remains           :: TFloat      AS AmountRemains
            , (COALESCE (inAmount,1) + COALESCE ((SELECT SUM (MI.Amount) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = vbPartionId AND MI.isErased = FALSE), 0)
              )                                 :: TFloat AS TotalCount
            , COALESCE (inAmount,1)             :: TFloat AS OperCount

       FROM Object AS Object_Goods
 
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = Object_Goods.Id AND Object_PartionGoods.MovementItemId = vbPartionId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                 ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, ObjectLink_Goods_Partner.ChildObjectId)
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_Goods_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Goods_Measure.ChildObjectId)

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
    
            LEFT JOIN tmpRemains ON tmpRemains.PartionId = Object_PartionGoods.MovementItemId

       WHERE Object_Goods.Id = vbGoodsId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpGet_MIInventory_Partion_byBarcode (inMovementId := 0, inBarCode:= '6416868200539', inPartNumber:= '', inAmount:= 1, inSession:= zfCalc_UserAdmin());
