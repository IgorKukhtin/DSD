-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PartionId Integer--, IdBarCode TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, Article_all TVarChar , EAN TVarChar 
             , GoodsGroupNameFull TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountDiff TFloat, AmountRemains_curr TFloat
             , Price TFloat
             , Summa TFloat
             , PartNumber TVarChar
             , Comment TVarChar
             , PartnerName TVarChar
             , OperDate_protocol TDateTime, UserName_protocol TVarChar
             , Ord Integer
             , isErased Boolean
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
                           , COALESCE (MIFloat_Price.ValueData, 0)        AS Price
                           , COALESCE (MIString_Comment.ValueData,'')     AS Comment
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , MovementItem.isErased
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
     , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                               , STRING_AGG (COALESCE (Object_Partner.ValueData, MIContainer.PartionId :: TVarChar, 'нет партии'), ';') AS PartnerName
                          FROM MovementItemContainer AS MIContainer
                               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = MIContainer.PartionId
                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.FromId
                          WHERE MIContainer.MovementId = inMovementId
                            AND MIContainer.DescId     = zc_MIContainer_Count()
                          GROUP BY MIContainer.MovementItemId
                         )
        , tmpProtocol AS (SELECT MovementItemProtocol.*
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                          FROM MovementItemProtocol
                          WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                         )
       -- Результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           --, zfFormat_BarCode (zc_BarCodePref_Object(), ObjectString_EAN.ValueData) AS IdBarCode
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , zfCalc_Article_all (ObjectString_Article.ValueData) ::TVarChar AS Article_all
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI.Amount                                               AS Amount
           , tmpRemains.Remains                                ::TFloat AS AmountRemains
           , (tmpMI.Amount - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff
           , tmpRemains.Amount                                 ::TFloat AS AmountRemains_curr
           , tmpMI.Price                  ::TFloat

           , (tmpMI.Amount * tmpMI.Price) ::TFloat AS Summa

           , tmpMI.PartNumber             ::TVarChar
           , tmpMI.Comment                ::TVarChar

           , COALESCE (Object_Partner.ValueData, '***' || tmpMIContainer.PartnerName) :: TVarChar AS PartnerName

           , tmpProtocol.OperDate  AS OperDate_protocol
           , Object_User.ValueData AS UserName_protocol

           , ROW_NUMBER() OVER (ORDER BY tmpMI.Id ASC) :: Integer AS Ord
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                                 AND tmpProtocol.Ord            = 1
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

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

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = tmpMI.Id
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.FromId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpMI.Id

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId := 23 , inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());
