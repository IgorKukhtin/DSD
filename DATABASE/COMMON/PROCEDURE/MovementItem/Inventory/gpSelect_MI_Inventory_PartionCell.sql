 -- Function: gpSelect_MI_Inventory_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_MI_Inventory_PartionCell (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Inventory_PartionCell(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat

             , isPartionCell_Close_1 Boolean

             , PartionCellId_1     Integer
             , PartionCellCode_1   Integer
             , PartionCellName_1   TVarChar

             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат такой
     RETURN QUERY
        WITH tmpMI_all AS (SELECT MovementItem.*
                           FROM MovementItem
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   IN (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
                          )
           , tmpMILO_all AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIF_all AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIB_all AS (SELECT MovementItemBoolean.*
                           FROM MovementItemBoolean
                           WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMID_all AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
     -- Результат
     SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName
           , Object_GoodsKind.Id                   AS GoodsKindId
           , Object_GoodsKind.ValueData            AS GoodsKindName
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectDate_Value.ValueData    ELSE MIDate_PartionGoods.ValueData   END AS PartionGoodsDate
           , MovementItem.Amount                   AS Amount

           , COALESCE (MIBoolean_PartionCell_Close_1.ValueData, FALSE) ::Boolean AS isPartionCell_Close_1

           , Object_PartionCell_1.Id               AS PartionCellId_1
           , Object_PartionCell_1.ObjectCode       AS PartionCellCode_1
           , Object_PartionCell_1.ValueData        AS PartionCellName_1

           , MovementItem.isErased                 AS isErased

       FROM tmpMI_all AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMID_all AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN tmpMILO_all AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            -- свойства из партии
            LEFT JOIN ObjectDate AS ObjectDate_Value
                                 ON ObjectDate_Value.ObjectId = MILinkObject_PartionGoods.ObjectId                      -- дата
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()


            LEFT JOIN tmpMILO_all AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpMIF_all AS MIFloat_PartionCell
                                        ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MIFloat_PartionCell.ValueData :: Integer

            LEFT JOIN tmpMIB_all AS MIBoolean_PartionCell_Close_1
                                          ON MIBoolean_PartionCell_Close_1.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_1.DescId         = zc_MIBoolean_PartionCell_Close_1()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Inventory_PartionCell (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
