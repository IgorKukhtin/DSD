-- Function: gpSelect_MovementItem_OrderGoods()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , MeasureName TVarChar
             , Amount TFloat, Amount_kg TFloat, Amount_sh TFloat
             , Price TFloat, Summa TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbPriceListId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);

     --Данные из шапки документа
       SELECT Movement.OperDate ::TDateTime       AS OperDate
            , MovementLinkObject_PriceList.ObjectId     ::Integer  AS PriceListId
     INTO vbOperDate, vbPriceListId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderGoods();

     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM ObjectBoolean AS MB WHERE MB.ObjectId = vbPriceListId AND MB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     
     -- Результат
     IF inShowAll THEN
     RETURN QUERY
       WITH 
       -- Цены из прайса
       tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                             , lfSelect.GoodsKindId AS GoodsKindId
                             , lfSelect.ValuePrice  AS Price_PriceList
                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect 
                       )
       -- Ограничение для ГП - какие товары показать
     , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                    , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                               FROM ObjectBoolean AS ObjectBoolean_Order
                                    LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                               WHERE ObjectBoolean_Order.ValueData = TRUE
                                 AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                 -- AND vbIsOrderDnepr = TRUE
                              )

       -- Существующие MovementItem
     , tmpMI_G AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount     AS Amount
                        , MovementItem.isErased
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                        INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
                   )
     , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                      AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                    )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_Price())
                      )
     , tmpMI_String AS (SELECT MovementItemString.*
                        FROM MovementItemString
                        WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                          AND MovementItemString.DescId IN (zc_MIString_Comment())
                       )

     , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                      , MovementItem.GoodsId                          AS GoodsId
                      , MovementItem.Amount                           AS Amount
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                      , MIString_Comment.ValueData        :: TVarChar AS Comment
                      , MovementItem.isErased
                 FROM tmpMI_G AS MovementItem
                      LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN tmpMI_Float AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                      LEFT JOIN tmpMI_String AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                 )

       SELECT
             0 :: Integer               AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , 0 :: TFloat AS Amount
           , 0 :: TFloat AS Amount_kg
           , 0 :: TFloat AS Amount_sh
           , COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist) :: TFloat AS Price
           , 0 :: TFloat AS Summa
           , '' :: TVarChar AS Comment

           , '' ::TVarChar       AS InsertName
           , '' ::TVarChar       AS UpdateName
           , CURRENT_TIMESTAMP ::TDateTime AS InsertDate
           , NULL ::TDateTime    AS UpdateDate

           , FALSE AS isErased
       FROM tmpGoodsByGoodsKind AS tmpGoods

            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId                   = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
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
             
           , tmpMI.Price  ::TFloat   AS Price
           , (COALESCE (tmpMI.Amount,0) * tmpMI.Price) ::TFloat AS Summa

           , tmpMI.Comment  :: TVarChar AS Comment

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

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

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
     ELSE

     -- Результат другой
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
           , (COALESCE (tmpMI.Amount,0) * MIFloat_Price.ValueData) ::TFloat AS Summa
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

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *
*/

-- тест
-- select * from gpSelect_MovementItem_OrderGoods(inMovementId := 18298048 , inShowAll:= False, inIsErased := 'False' ,  inSession := '5')
