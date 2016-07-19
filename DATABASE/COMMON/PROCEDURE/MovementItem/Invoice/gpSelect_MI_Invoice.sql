-- Function: gpSelect_MI_Invoice()

DROP FUNCTION IF EXISTS gpSelect_MI_Invoice (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Invoice (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Invoice(
    IN inMovementId       Integer      , -- ключ Документа
    IN inOrderIncomeId    Integer      ,
    IN inIsErased         Boolean      , --
    IN inShowAll          Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MIId_OrderIncome Integer, InvNumber_OrderIncome TVarChar
             , Amount TFloat, AmountOrderIncome TFloat, Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSummOrderIncome TFloat
             , Comment TVarChar, CommentOrderIncome TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NameBeforeId Integer, NameBeforeCode Integer, NameBeforeName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AssetId Integer, AssetName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_Invoice());
     vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll = TRUE THEN
       --
      RETURN QUERY
      WITH
              tmpMI AS (SELECT MovementItem.Id                              AS MovementItemId
                             , MovementItem.Amount                 :: TFloat AS Amount  
                             , COALESCE(MIFloat_Price.ValueData,0)           :: TFloat AS Price
                             , COALESCE(MIFloat_CountForPrice.ValueData, 1)  :: TFloat AS CountForPrice 
                             , MILinkObject_Goods.ObjectId                   AS GoodsId
                             , MovementItem.ObjectId                         AS MeasureId
                             , MILinkObject_NameBefore.ObjectId              AS NameBeforeId
                             , MILinkObject_Unit.ObjectId                    AS UnitId
                             , MILinkObject_Asset.ObjectId                   AS AssetId
                             , MovementItem.isErased
                             , MIFloat_OrderIncome.ValueData                 AS MIId_OrderIncome

                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
                                  -- это ссылка на док. "заявка поставщику"
                                  LEFT JOIN MovementItemFloat AS MIFloat_OrderIncome
                                                              ON MIFloat_OrderIncome.MovementItemId = MovementItem.Id
                                                             AND MIFloat_OrderIncome.DescId = zc_MIFloat_MovementItemId()
                     )
   , tmpMI_parent AS (SELECT   MovementItem.Id                               AS MovementItemId
                             , MovementItem.Amount                 :: TFloat AS Amount  
                             , COALESCE(MIFloat_Price.ValueData,0)           :: TFloat AS Price
                             , COALESCE(MIFloat_CountForPrice.ValueData, 1)  :: TFloat AS CountForPrice 
                             , MILinkObject_Goods.ObjectId                   AS GoodsId
                             , MovementItem.ObjectId                         AS MeasureId
                             , MILinkObject_NameBefore.ObjectId              AS NameBeforeId
                             , MILinkObject_Unit.ObjectId                    AS UnitId
                             , MILinkObject_Asset.ObjectId                   AS AssetId
                      FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                      WHERE MovementItem.MovementId = inOrderIncomeId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )

   , tmpMI_parent_find AS (SELECT tmp.MovementItemId
                                , tmpMI_parent.MovementItemId AS MIparentId
                                , tmpMI_parent.GoodsId
                                , tmpMI_parent.Amount
                                , tmpMI_parent.CountForPrice 
                                , tmpMI_parent.MeasureId
                                , tmpMI_parent.NameBeforeId
                                , tmpMI_parent.UnitId
                                , tmpMI_parent.AssetId
                                , tmpMI_parent.Price
                           FROM tmpMI_parent
                                LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId, tmpMI.GoodsId, tmpMI.MeasureId, tmpMI.Price, tmpMI.NameBeforeId, tmpMI.UnitId, tmpMI.AssetId 
                                           FROM tmpMI WHERE tmpMI.isErased = FALSE GROUP BY tmpMI.GoodsId, tmpMI.MeasureId, tmpMI.Price, tmpMI.NameBeforeId, tmpMI.UnitId, tmpMI.AssetId 
                                          ) AS tmp ON COALESCE(tmp.GoodsId,0)     = COALESCE(tmpMI_parent.GoodsId,0)
                                                  AND COALESCE(tmp.MeasureId,0)   = COALESCE(tmpMI_parent.MeasureId,0)
                                                  AND COALESCE(tmp.NameBeforeId,0) = COALESCE(tmpMI_parent.NameBeforeId,0)
                                                  AND COALESCE(tmp.UnitId,0) = COALESCE(tmpMI_parent.UnitId,0)
                                                  AND COALESCE(tmp.AssetId,0) = COALESCE(tmpMI_parent.AssetId,0)
                                                  AND COALESCE(tmp.Price,0)   = COALESCE(tmpMI_parent.Price,0)
                          )

   , tmpResult AS (SELECT tmpMI.MovementItemId
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent_find.GoodsId)            AS GoodsId
                        , tmpMI.Amount                                                   AS Amount
                        , tmpMI_parent_find.Amount                                       AS AmountOrderIncome
                        , COALESCE (tmpMI.MeasureId, tmpMI_parent_find.MeasureId)        AS MeasureId
                        , COALESCE (tmpMI.NameBeforeId, tmpMI_parent_find.NameBeforeId)  AS NameBeforeId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent_find.UnitId)     AS UnitId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent_find.AssetId)   AS AssetId
                        , COALESCE (tmpMI.Price, tmpMI_parent_find.Price)       AS Price 
                        , COALESCE (tmpMI_parent_find.Price,0)                  AS PriceOrderIncome
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent_find.CountForPrice)  AS CountForPrice
                        , COALESCE (tmpMI.isErased, FALSE)                      AS isErased
                        , COALESCE (tmpMI.MIId_OrderIncome, tmpMI_parent_find.MIparentId)  :: Integer AS MIId_OrderIncome
                   FROM tmpMI
                        FULL JOIN tmpMI_parent_find ON tmpMI_parent_find.MovementItemId = tmpMI.MovementItemId
                  )

        SELECT
             tmpResult.MovementItemId               AS Id
           , tmpResult.MIId_OrderIncome             AS MIId_OrderIncome
           , zfCalc_PartionMovementName (Movement_OrderIncome.DescId, MovementDesc.ItemName, Movement_OrderIncome.InvNumber, Movement_OrderIncome.OperDate) AS InvNumber_OrderIncome
           , tmpResult.Amount             :: TFloat AS Amount  
           , tmpResult.AmountOrderIncome  :: TFloat AS AmountOrderIncome
           , tmpResult.Price              :: TFloat AS Price
           , tmpResult.CountForPrice      :: TFloat AS CountForPrice 
           , CASE WHEN COALESCE(tmpResult.CountForPrice, 1) > 0
                  THEN CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) / COALESCE(tmpResult.CountForPrice, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , CASE WHEN COALESCE(tmpResult.CountForPrice, 1) > 0
                  THEN CAST (tmpResult.AmountOrderIncome * COALESCE(tmpResult.PriceOrderIncome,0) / COALESCE(tmpResult.CountForPrice, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpResult.AmountOrderIncome * COALESCE(tmpResult.PriceOrderIncome,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSummOrderIncome

           , MIString_Comment.ValueData            :: TVarChar AS Comment
           , MIString_CommentOrderIncome.ValueData :: TVarChar AS CommentOrderIncome

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName

           , Object_NameBefore.Id                AS NameBeforeId
           , Object_NameBefore.ObjectCode        AS NameBeforeCode
           , Object_NameBefore.ValueData         AS NameBeforeName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName

           , tmpResult.isErased

       FROM tmpResult
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpResult.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemString AS MIString_CommentOrderIncome
                                         ON MIString_CommentOrderIncome.MovementItemId =  tmpResult.MIId_OrderIncome
                                        AND MIString_CommentOrderIncome.DescId = zc_MIString_Comment()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id =  tmpResult.MeasureId
            LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = tmpResult.NameBeforeId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpResult.AssetId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =tmpResult.UnitId
            
            LEFT JOIN MovementItem AS MI_OrderIncome ON MI_OrderIncome.Id = tmpResult.MIId_OrderIncome
            LEFT JOIN Movement AS Movement_OrderIncome ON Movement_OrderIncome.Id = MI_OrderIncome.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_OrderIncome.DescId

          ;

   ELSE
      RETURN QUERY
        SELECT
             MovementItem.Id     AS Id
           , MIFloat_OrderIncome.ValueData                  :: Integer AS MIId_OrderIncome
           , zfCalc_PartionMovementName (Movement_OrderIncome.DescId, MovementDesc.ItemName, Movement_OrderIncome.InvNumber, Movement_OrderIncome.OperDate) AS InvNumber_OrderIncome
           , MovementItem.Amount                            :: TFloat  AS Amount   
           , MI_OrderIncome.Amount                          :: TFloat  AS AmountOrderIncome
           , COALESCE(MIFloat_Price.ValueData,0)            :: TFloat  AS Price
           , COALESCE(MIFloat_CountForPrice.ValueData, 1)   :: TFloat  AS CountForPrice 
           , CASE WHEN COALESCE(MIFloat_CountForPrice.ValueData, 1) > 0
                  THEN CAST (MovementItem.Amount * COALESCE(MIFloat_Price.ValueData,0) / COALESCE(MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                  ELSE CAST (MovementItem.Amount * COALESCE(MIFloat_Price.ValueData,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , CASE WHEN COALESCE(MIFloat_CountForPriceOrderIncome.ValueData, 1) > 0
                  THEN CAST (MI_OrderIncome.Amount * COALESCE(MIFloat_PriceOrderIncome.ValueData,0) / COALESCE(MIFloat_CountForPriceOrderIncome.ValueData, 1) AS NUMERIC (16, 2))
                  ELSE CAST (MI_OrderIncome.Amount * COALESCE(MIFloat_PriceOrderIncome.ValueData,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSummOrderIncome

           , MIString_Comment.ValueData            :: TVarChar AS Comment
           , MIString_CommentOrderIncome.ValueData :: TVarChar AS CommentOrderIncome

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName

           , Object_NameBefore.Id                AS NameBeforeId
           , Object_NameBefore.ObjectCode        AS NameBeforeCode
           , Object_NameBefore.ValueData         AS NameBeforeName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                             ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                            AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
            LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = MILinkObject_NameBefore.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            -- это ссылка на док. "заявка поставщику"
            LEFT JOIN MovementItemFloat AS MIFloat_OrderIncome
                                        ON MIFloat_OrderIncome.MovementItemId = MovementItem.Id
                                       AND MIFloat_OrderIncome.DescId = zc_MIFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_OrderIncome ON MI_OrderIncome.Id = MIFloat_OrderIncome.ValueData :: Integer
            LEFT JOIN MovementItemFloat AS MIFloat_PriceOrderIncome
                                        ON MIFloat_PriceOrderIncome.MovementItemId = MI_OrderIncome.Id
                                       AND MIFloat_PriceOrderIncome.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPriceOrderIncome
                                        ON MIFloat_CountForPriceOrderIncome.MovementItemId = MI_OrderIncome.Id
                                       AND MIFloat_CountForPriceOrderIncome.DescId = zc_MIFloat_CountForPrice()  
            LEFT JOIN MovementItemString AS MIString_CommentOrderIncome
                                         ON MIString_CommentOrderIncome.MovementItemId = MI_OrderIncome.Id
                                        AND MIString_CommentOrderIncome.DescId = zc_MIString_Comment()
            
            LEFT JOIN Movement AS Movement_OrderIncome ON Movement_OrderIncome.Id = MI_OrderIncome.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_OrderIncome.DescId

              
          ;
 END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 15.07.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_Invoice (0,False, '3');