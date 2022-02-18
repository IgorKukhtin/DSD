-- Function: gpGet_MIInventory_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MIInventory_Partion_byBarcode(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id                 Integer
             , PartionId          Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupId       Integer
             , GoodsGroupName     TVarChar
             , MeasureName        TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , Price              TFloat
             , AmountRemains      TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbGoodsId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF inBarCode = '' THEN
       RETURN QUERY
       SELECT 0  :: Integer  AS Id
            , 0  :: Integer  AS PartionId
            , 0  :: Integer  AS GoodsId
            , 0  :: Integer  AS GoodsCode
            , '' :: TVarChar AS GoodsName
            , '' :: TVarChar AS Article
            , '' :: TVarChar AS GoodsGroupNameFull
            , 0  :: Integer  AS GoodsGroupId
            , '' :: TVarChar AS GoodsGroupName
            , '' :: TVarChar AS MeasureName
            , 0  :: Integer  AS PartnerId
            , '' :: TVarChar AS PartnerName
            , 0  :: TFloat   AS Price
            , 0  :: TFloat   AS AmountRemains
             ;
     END IF;
     

     -- Нашли
     SELECT tmp.PartionId
          , tmp.GoodsId
       INTO vbPartionId, vbGoodsId
     FROM gpGet_Partion_byBarcode (inBarCode, inSession) AS tmp;

     -- проверка
     IF COALESCE (vbPartionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Ошибка в Штрихкоде <%>.', inBarCode;
     END IF;

     /*-- проверка
     IF zfCalc_SummBarCode (inBarCode) <> SUBSTRING (inBarCode FROM 13 FOR 1)
     THEN
         RAISE EXCEPTION 'Ошибка.Ошибка в Контрольной цифре <%> для Штрихкода = <%>.', zfCalc_SummBarCode (inBarCode), inBarCode;
     END IF;
     */
     
     -- из шапки берем подразделение для остатков
     vbUnitId := (SELECT MovementLinkObject.ObjectId 
                  FROM MovementLinkObject 
                  WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
                    AND MovementLinkObject.MovementId = inMovementId
                  );


     -- Результат
     RETURN QUERY
       WITH
       tmpRemains AS (SELECT Container.ObjectId AS GoodsId
                           , CAST (SUM (COALESCE (Container.Amount,0)) AS NUMERIC (16,0)) AS Remains
                      FROM Container
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.ObjectId       = Container.ObjectId
                      WHERE Container.DescId = zc_Container_Count()
                        AND Container.ObjectId = vbGoodsId
                        AND (Container.WhereObjectId = vbUnitId OR COALESCE (vbUnitId,0) = 0)
                        AND COALESCE (Container.Amount,0) <> 0
                      GROUP BY Container.ObjectId 
                      )


       SELECT -1                               :: Integer AS Id
            , Object_PartionGoods.MovementItemId          AS PartionId
            , Object_Goods.Id                             AS GoodsId
            , Object_Goods.ObjectCode                     AS GoodsCode
            , Object_Goods.ValueData                      AS GoodsName
            , ObjectString_Article.ValueData              AS Article
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_GoodsGroup.Id                        AS GoodsGroupId
            , Object_GoodsGroup.ValueData                 AS GoodsGroupName
            , Object_Measure.ValueData                    AS MeasureName
            , Object_Partner.ObjectCode                   AS PartnerId
            , Object_Partner.ValueData                    AS PartnerName
            , Object_PartionGoods.ekPrice                 AS Price
            , tmpRemains.Remains           :: TFloat      AS AmountRemains

       FROM Object_PartionGoods
 
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = Object_PartionGoods.ObjectId
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = Object_PartionGoods.FromId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_PartionGoods.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_PartionGoods.ObjectId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                    
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_PartionGoods.ObjectId

       WHERE Object_PartionGoods.MovementItemId = vbPartionId
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
-- SELECT * FROM gpGet_MIInventory_Partion_byBarcode (inMovementId := 0, inBarCode:= '2210002798265'::TVarChar, inSession:= zfCalc_UserAdmin());