-- Function: gpSelect_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChoiceCell (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChoiceCell(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar 
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar 
             , GoodsKindeId Integer, GoodsKindeName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       SELECT
             MovementItem.Id                      AS Id
           , Object_ChoiceCell.Id                 AS ChoiceCellId
           , Object_ChoiceCell.ObjectCode         AS ChoiceCellCode
           , Object_ChoiceCell.ValueData          AS ChoiceCellName 
           
           , Object_Goods.Id          		      AS GoodsId
           , Object_Goods.ObjectCode  		      AS GoodsCode
           , Object_Goods.ValueData   		      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id                  AS GoodsKindeId
           , Object_GoodsKind.ValueData           AS GoodsKindeName
           , MIDate_PartionGoods.ValueData        AS PartionGoodsDate
           , MIDate_PartionGoods_next.ValueData   AS PartionGoodsDate_next

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate
           
           , MovementItem.isErased                                AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_ChoiceCell ON Object_ChoiceCell.Id = MovementItem.ObjectId

           
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods_next
                                       ON MIDate_PartionGoods_next.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods_next.DescId = zc_MIDate_PartionGoods_next()

           LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                            ON MILO_Goods.MovementItemId = MovementItem.Id
                                           AND MILO_Goods.DescId = zc_MILinkObject_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILO_Goods.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                            ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                             ON MILO_Update.MovementItemId = MovementItem.Id
                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
            
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
         ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ChoiceCell (inMovementId:= 1, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
