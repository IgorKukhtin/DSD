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
             , Amount TFloat, AmountOrderIncome TFloat, Price TFloat, PriceOrderIncome TFloat, CountForPrice TFloat, CountForPriceOrderIncome TFloat
             , AmountSumm TFloat, AmountSummOrderIncome TFloat
             , Comment TVarChar, CommentOrderIncome TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NameBeforeId Integer, NameBeforeCode Integer, NameBeforeName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar, InvNumber TVarChar
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


     --
     RETURN QUERY
         WITH tmpMI AS (SELECT MovementItem.Id                                 AS MovementItemId
                             , COALESCE (MILinkObject_NameBefore.ObjectId, 0)  AS NameBeforeId
                             , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                             , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                             , MovementItem.isErased
                             , CASE WHEN Movement_OrderIncome.StatusId <> zc_Enum_Status_Erased() THEN MI_OrderIncome.Id         ELSE 0 END AS MIId_OrderIncome
                             , CASE WHEN Movement_OrderIncome.StatusId <> zc_Enum_Status_Erased() THEN MI_OrderIncome.MovementId ELSE 0 END AS MovementId_OrderIncome

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
                                  --LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
                                  -- это док. "заявка поставщику"
                                  LEFT JOIN MovementItemFloat AS MIFloat_OrderIncome
                                                              ON MIFloat_OrderIncome.MovementItemId = MovementItem.Id
                                                             AND MIFloat_OrderIncome.DescId = zc_MIFloat_MovementItemId()
                                  LEFT JOIN MovementItem AS MI_OrderIncome ON MI_OrderIncome.Id = MIFloat_OrderIncome.ValueData :: Integer
                                                                          AND MI_OrderIncome.isErased = FALSE
                                  LEFT JOIN Movement AS Movement_OrderIncome ON Movement_OrderIncome.Id = MI_OrderIncome.MovementId
                     )
   -- , tmpMovement_parent AS (SELECT DISTINCT tmpMI.MovementId_OrderIncome AS MovementId FROM tmpMI WHERE tmpMI.MovementId_OrderIncome <> 0 UNION SELECT inOrderIncomeId AS MovementId WHERE inOrderIncomeId <> 0)
   , tmpMI_parent AS (SELECT   MovementItem.Id                                 AS MovementItemId
                             , MovementItem.MovementId                         AS MovementId
                             , COALESCE (MILinkObject_NameBefore.ObjectId, 0)  AS NameBeforeId
                             , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                             , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                      /*FROM tmpMovement_parent
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_parent.MovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE*/
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
   , tmpResult AS (SELECT tmpMI.MovementItemId                                             AS Id
                        , COALESCE (tmpMI.NameBeforeId, tmpMI_parent.NameBeforeId)         AS NameBeforeId
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.MeasureId, tmpMI_parent.MeasureId)               AS MeasureId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent.UnitId)                     AS UnitId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.isErased, FALSE)                                 AS isErased
                        , COALESCE (tmpMI.MIId_OrderIncome, tmpMI_parent.MovementItemId)   AS MIId_OrderIncome
                        , COALESCE (tmpMI.MovementId_OrderIncome, tmpMI_parent.MovementId) AS MovementId_OrderIncome

                        , tmpMI_parent.NameBeforeId  AS NameBeforeId_parent
                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.UnitId        AS UnitId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        FULL JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_OrderIncome
                   WHERE inShowAll = TRUE
                  UNION ALL
                   SELECT tmpMI.MovementItemId                                             AS Id
                        , COALESCE (tmpMI.NameBeforeId, tmpMI_parent.NameBeforeId)         AS NameBeforeId
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.MeasureId, tmpMI_parent.MeasureId)               AS MeasureId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent.UnitId)                     AS UnitId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.isErased, FALSE)                                 AS isErased
                        , COALESCE (tmpMI.MIId_OrderIncome, tmpMI_parent.MovementItemId)   AS MIId_OrderIncome
                        , COALESCE (tmpMI.MovementId_OrderIncome, tmpMI_parent.MovementId) AS MovementId_OrderIncome

                        , tmpMI_parent.NameBeforeId  AS NameBeforeId_parent
                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.MeasureId     AS MeasureId_parent
                        , tmpMI_parent.UnitId        AS UnitId_parent
                        , tmpMI_parent.AssetId       AS AssetId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        LEFT JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_OrderIncome
                   WHERE inShowAll = FALSE
                  )
        -- Результат такой
        SELECT
             tmpResult.Id
           , tmpResult.MIId_OrderIncome               AS MIId_OrderIncome
           , zfCalc_PartionMovementName (Movement_OrderIncome.DescId, MovementDesc.ItemName, Movement_OrderIncome.InvNumber, Movement_OrderIncome.OperDate) AS InvNumber_OrderIncome
           , tmpResult.Amount               :: TFloat AS Amount
           , tmpResult.Amount_parent        :: TFloat AS AmountOrderIncome
           , tmpResult.Price                :: TFloat AS Price
           , tmpResult.Price_parent         :: TFloat AS PriceOrderIncome
           , tmpResult.CountForPrice        :: TFloat AS CountForPrice 
           , tmpResult.CountForPrice_parent :: TFloat AS CountForPriceOrderIncome
           , CASE WHEN COALESCE(tmpResult.CountForPrice, 1) > 0
                  THEN CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) / COALESCE(tmpResult.CountForPrice, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , CASE WHEN COALESCE(tmpResult.CountForPrice_parent, 1) > 0
                  THEN CAST (tmpResult.Amount_parent * COALESCE(tmpResult.Price_parent,0) / COALESCE(tmpResult.CountForPrice_parent, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpResult.Amount_parent * COALESCE(tmpResult.Price_parent,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSummOrderIncome

           , MIString_Comment.ValueData            :: TVarChar AS Comment
           , MIString_CommentOrderIncome.ValueData :: TVarChar AS CommentOrderIncome

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , (CASE WHEN tmpResult.Id > 0 AND tmpResult.GoodsId <> tmpResult.GoodsId_parent AND tmpResult.GoodsId_parent > 0 THEN '??? 'ELSE '' END
           || COALESCE (Object_Goods.ValueData, '')
             ) :: TVarChar AS GoodsName

           , Object_Measure.Id                   AS MeasureId
           , (CASE WHEN tmpResult.Id > 0 AND tmpResult.MeasureId <> tmpResult.MeasureId_parent AND tmpResult.MeasureId_parent > 0 THEN '??? ' ELSE '' END
           || COALESCE (Object_Measure.ValueData, '')
             ) :: TVarChar AS MeasureName

           , Object_NameBefore.Id                AS NameBeforeId
           , CASE WHEN Object_NameBefore.ValueData <> '' THEN Object_NameBefore.ObjectCode ELSE Object_Goods.ObjectCode END :: Integer  AS NameBeforeCode
           , (CASE WHEN tmpResult.Id > 0 AND tmpResult.NameBeforeId <> tmpResult.NameBeforeId_parent AND tmpResult.NameBeforeId_parent > 0 THEN '??? 'ELSE '' END
           || CASE WHEN tmpResult.Id > 0 AND tmpResult.GoodsId <> tmpResult.GoodsId_parent AND tmpResult.GoodsId_parent > 0 THEN '??? 'ELSE '' END
           || CASE WHEN Object_NameBefore.ValueData <> '' THEN Object_NameBefore.ValueData ELSE COALESCE (Object_Goods.ValueData, '') END
             ) :: TVarChar AS NameBeforeName

           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , (CASE WHEN tmpResult.Id > 0 AND tmpResult.UnitId <> tmpResult.UnitId_parent AND tmpResult.UnitId_parent > 0 THEN '??? ' ELSE '' END
           || COALESCE (Object_Unit.ValueData, '')
             ) :: TVarChar AS UnitName

           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ObjectCode             AS AssetCode
           , (CASE WHEN tmpResult.Id > 0 AND tmpResult.AssetId <> tmpResult.AssetId_parent AND tmpResult.AssetId_parent > 0 THEN '??? ' ELSE '' END
           || COALESCE (Object_Asset.ValueData, '')
             ) :: TVarChar AS AssetName
           , ObjectString_InvNumber.ValueData    AS InvNumber

           , tmpResult.isErased

       FROM tmpResult
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpResult.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemString AS MIString_CommentOrderIncome
                                         ON MIString_CommentOrderIncome.MovementItemId =  tmpResult.MIId_OrderIncome
                                        AND MIString_CommentOrderIncome.DescId = zc_MIString_Comment()
            LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = tmpResult.NameBeforeId
            LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpResult.GoodsId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpResult.MeasureId
            LEFT JOIN Object AS Object_Unit       ON Object_Unit.Id       = tmpResult.UnitId
            LEFT JOIN Object AS Object_Asset      ON Object_Asset.Id      = tmpResult.AssetId

            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = CASE WHEN COALESCE (tmpResult.AssetId,0) <> 0 THEN tmpResult.AssetId ELSE tmpResult.GoodsId END
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN Movement AS Movement_OrderIncome ON Movement_OrderIncome.Id = tmpResult.MovementId_OrderIncome
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_OrderIncome.DescId
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.20         * add zc_ObjectString_Asset_InvNumber
 15.07.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_Invoice (4065094, 4061606, FALSE, FALSE, zfCalc_UserAdmin());
-- SELECT * from gpSelect_MI_Invoice (4065094, 4061606, FALSE, TRUE, zfCalc_UserAdmin());
