-- Function: gpSelect_MovementItem_OrderGoods()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , MeasureName TVarChar
             , Amount TFloat, Amount_kg TFloat, Amount_sh TFloat
             , Price TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )

        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName

           , tmpMI.Amount            :: TFloat  AS Amount

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE tmpMI.Amount
             END                      ::TFloat   AS Amount_kg
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN tmpMI.Amount
                  ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,1) <> 0 THEN tmpMI.Amount / COALESCE (ObjectFloat_Weight.ValueData,1) ELSE tmpMI.Amount END
             END                      ::TFloat   AS Amount_sh
             
           , MIFloat_Price.ValueData  ::TFloat   AS Price

           , MIString_Comment.ValueData :: TVarChar AS Comment

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = tmpMI.MovementItemId
                                      AND MIString_Comment.DescId = zc_MIString_Comment()

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
          LEFT JOIN MovementItemDate AS MIDate_Update
                                     ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                    AND MIDate_Update.DescId = zc_MIDate_Update()

          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                           ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_Update
                                           ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_Update.DescId = zc_MILinkObject_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *
*/

-- тест
-- select * from gpSelect_MovementItem_OrderGoods(inMovementId := 18298048 , inIsErased := 'False' ,  inSession := '5')
