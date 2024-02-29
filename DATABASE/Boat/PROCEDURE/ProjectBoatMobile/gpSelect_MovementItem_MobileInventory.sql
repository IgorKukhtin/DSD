-- Function: gpSelect_MovementItem_MobileInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileInventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileInventory(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar, PartNumber TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountDiff TFloat, AmountRemains_curr TFloat
             , Price TFloat, Summa TFloat
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Данные для остатков
     SELECT Movement.OperDate, Movement.StatusId, MLO_Unit.ObjectId
            INTO vbOperDate, vbStatusId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;


     -- Результат такой
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_Price.ValueData, 0)::TFloat           AS Price
                           , COALESCE (MIString_Comment.ValueData,'')::TVarChar      AS Comment
                           , COALESCE (MIString_PartNumber.ValueData, '')::TVarChar  AS PartNumber
                           , MILinkObject_Partner.ObjectId                           AS PartnerId
                           , MILO_PartionCell.ObjectId                               AS PartionCellId
                           , MovementItem.isErased
                           , MIFloat_MovementId.ValueData :: Integer                 AS MovementId_OrderClient
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                            ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()

                          LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                          LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                           ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                          AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                     )

         , tmpRemains AS (SELECT Container.Id       AS ContainerId
                               , Container.ObjectId AS GoodsId
                               , Container.Amount
                               , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) AS Remains
                               , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                          FROM Container
                               LEFT JOIN MovementItemString AS MIString_PartNumber
                                                            ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                           AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId =  Container.Id
                                                              AND MIContainer.OperDate    >= vbOperDate
                                                              AND vbStatusId              =  zc_Enum_Status_Complete()
                          WHERE Container.WhereObjectId = vbUnitId
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                          GROUP BY Container.Id
                                 , Container.ObjectId
                                 , Container.Amount
                                 , COALESCE (MIString_PartNumber.ValueData, '')
                          HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) <> 0
                              OR Container.Amount <> 0
                         )

       -- Результат
       SELECT
             tmpMI.Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , ObjectString_EAN.ValueData          AS EAN
           , Object_GoodsGroup.Id                AS GoodsGroupId
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           , tmpMI.PartNumber                    AS PartNumber

           , tmpMI.Amount                                               AS Amount
           , tmpRemains.Remains                                ::TFloat AS AmountRemains
           , (tmpMI.Amount - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff
           , tmpRemains.Amount                                 ::TFloat AS AmountRemains_curr
             -- цена
           , tmpMI.Price                                       ::TFloat AS Price
           , (tmpMI.Amount * tmpMI.Price) ::TFloat                      AS Summa

       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMI.PartionCellId

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_EKPrice
                                  ON ObjectFloat_Goods_EKPrice.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Goods_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
            LEFT JOIN (SELECT tmpRemains.GoodsId, tmpRemains.PartNumber, SUM (tmpRemains.Amount) AS Amount, SUM (tmpRemains.Remains) AS Remains
                       FROM tmpRemains
                       GROUP BY tmpRemains.GoodsId, tmpRemains.PartNumber
                      ) AS tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                     AND tmpRemains.PartNumber = tmpMI.PartNumber

            LEFT JOIN ObjectLink AS OL_Goods_Partner
                                 ON OL_Goods_Partner.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = tmpMI.Id  
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (tmpMI.PartnerId, Object_PartionGoods.FromId, OL_Goods_Partner.ChildObjectId)

            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

            LEFT JOIN ObjectString AS ObjectString_CIN
                                   ON ObjectString_CIN.ObjectId = Object_Product.Id
                                  AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()  
            
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileInventory (inMovementId := 703 , inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());