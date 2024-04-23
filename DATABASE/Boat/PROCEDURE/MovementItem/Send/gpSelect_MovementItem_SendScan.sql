-- Function: gpSelect_MovementItem_SendScan()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendScan (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendScan(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Ord Integer
             , PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, Article_all TVarChar , EAN TVarChar 
             , GoodsGroupNameFull TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , Amount TFloat
             , PartNumber TVarChar
             , OperDate_protocol TDateTime, UserName_protocol TVarChar
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
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , MILO_PartionCell.ObjectId                    AS PartionCellId
                           , MovementItem.isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Scan()
                                            AND MovementItem.isErased   = tmpIsErased.isErased

                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                           AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
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
           , ROW_NUMBER() OVER (ORDER BY tmpMI.Id ASC) :: Integer AS Ord
           
           , tmpMI.PartionId
           --, zfFormat_BarCode (zc_BarCodePref_Object(), ObjectString_EAN.ValueData) AS IdBarCode
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI.Amount                                               AS Amount

           , tmpMI.PartNumber             ::TVarChar

           , tmpProtocol.OperDate  AS OperDate_protocol
           , Object_User.ValueData AS UserName_protocol
           
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

            LEFT JOIN ObjectLink AS OL_Goods_Partner
                                 ON OL_Goods_Partner.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId  = tmpMI.Id  
            
       ORDER BY 2 DESC
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.04.24                                                       *
*/

-- тест
-- 

SELECT * FROM gpSelect_MovementItem_SendScan (inMovementId := 3179 , inIsErased := 'False' ,  inSession := zfCalc_UserAdmin());