-- Function: gpSelect_MovementItem_PriceCorrective()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceCorrective (Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceCorrective (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PriceCorrective(
    IN inMovementId         Integer      , -- ключ Документа
    IN inMovementId_Parent  Integer      , -- ключ Документа
    IN inOperDate           TDateTime    , -- Дата документа
    IN inShowAll            Boolean      , --
    IN inisErased           Boolean      , --
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, Price TFloat
             , PriceTax_calc TFloat, PriceTo TFloat
             , CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AmountSumm TFloat, isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbShowAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- 
     vbShowAll:= inShowAll;

     -- находим ...
     inMovementId_Parent:= (SELECT COALESCE (Movement.ParentId, 0) FROM Movement WHERE Movement.Id = inMovementId);
     -- меняется параметр
     IF inShowAll = TRUE AND inMovementId_Parent > 0
     THEN
         inShowAll:= FALSE;
     ELSE
         IF inShowAll = TRUE
         THEN
             inShowAll:= inMovementId <> 0;
         END IF;
     END IF;


     --
     IF inShowAll = TRUE THEN

     -- Результат
     RETURN QUERY
       WITH 
       tmpParams AS (SELECT zc_Enum_InfoMoney_30103() AS InfoMoneyId
                     WHERE EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Bread() AND UserId = vbUserId)
                    )

       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           --, CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           , CAST (NULL AS TFloat)      AS Price
           , CAST (NULL AS TFloat)      AS PriceTax_calc
           , CAST (NULL AS TFloat)      AS PriceTo
           , CAST (NULL AS TFloat)      AS CountForPrice
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , CAST (NULL AS TFloat)      AS AmountSumm
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
             FROM Object_InfoMoney_View
                  LEFT JOIN tmpParams ON 1 = 1
                  INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                   AND Object_Goods.isErased = FALSE
                  
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
               AND (tmpParams.InfoMoneyId IS NULL OR tmpParams.InfoMoneyId = Object_InfoMoney_View.InfoMoneyId)
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            --LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate)
            --       AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id				AS Id
           , Object_Goods.Id          			AS GoodsId
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData   			AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount			AS Amount

           , MIFloat_Price.ValueData                  ::TFloat AS Price
           , COALESCE (MIFloat_PriceTax_calc.ValueData,0) ::TFloat AS PriceTax_calc
           , COALESCE (MIFloat_PriceTo.ValueData,0)   ::TFloat AS PriceTo

           , MIFloat_CountForPrice.ValueData 	        AS CountForPrice

           , Object_GoodsKind.Id        		AS GoodsKindId
           , Object_GoodsKind.ValueData 		AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                        THEN CAST ( (COALESCE (MovementItem.Amount, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) 				AS AmountSumm
           , MovementItem.isErased				AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                        ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceTo
                                        ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            ;
     ELSE

     RETURN QUERY
     WITH
       tmpMI AS (SELECT MovementItem.Id				AS MovementItemId
                      , MovementItem.ObjectId			AS GoodsId
                      , MovementItem.Amount			AS Amount
                      , MIFloat_Price.ValueData 	        AS Price
                      , COALESCE (MIFloat_PriceTax_calc.ValueData,0) ::TFloat AS PriceTax_calc
                      , COALESCE (MIFloat_PriceTo.ValueData,0)   ::TFloat AS PriceTo
                      , MIFloat_CountForPrice.ValueData         AS CountForPrice
                      , MILinkObject_GoodsKind.ObjectId         AS GoodsKindId
                      , MovementItem.isErased                   AS isErased
           
                  FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                       JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = tmpIsErased.isErased
                       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                   ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceTo
                                                   ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 )

     , tmpMI_Parent AS (SELECT MovementItem.ObjectId                         AS GoodsId
                             , SUM (MovementItem.Amount)                     AS Amount
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItem.MovementId = inMovementId_Parent
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                        GROUP BY MovementItem.ObjectId
                               , MILinkObject_GoodsKind.ObjectId
                               , MIFloat_Price.ValueData
                       )

     , tmpMI_Parent_find AS (SELECT tmp.MovementItemId
                                  , tmpMI_parent.GoodsId
                                  -- , tmpMI_parent.Amount
                                  , tmpMI_parent.GoodsKindId
                                  , tmpMI_parent.Price
                             FROM tmpMI_Parent
                                  LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price FROM tmpMI WHERE tmpMI.isErased = FALSE GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Price
                                            ) AS tmp ON tmp.GoodsId     = tmpMI_parent.GoodsId
                                                    AND tmp.GoodsKindId = tmpMI_parent.GoodsKindId
                                                    AND tmp.Price       = tmpMI_parent.Price
                            )

     , tmpResult AS (SELECT tmpMI.MovementItemId
                          , COALESCE (tmpMI.GoodsId, tmpMI_Parent_find.GoodsId)         AS GoodsId
                          , CASE WHEN tmpMI.Amount <> 0 THEN tmpMI.Amount ELSE 0 /*tmpMI_Parent_find.Amount*/ END AS Amount
                          , COALESCE (tmpMI.GoodsKindId, tmpMI_Parent_find.GoodsKindId) AS GoodsKindId
                          , COALESCE (tmpMI.Price, tmpMI_Parent_find.Price)             AS Price
                          , COALESCE (tmpMI.PriceTax_calc, 0)                           AS PriceTax_calc
                          , COALESCE (tmpMI.PriceTo, 0)                                 AS PriceTo
                          , COALESCE (tmpMI.CountForPrice, 1)                           AS CountForPrice
                          , COALESCE (tmpMI.isErased, FALSE)                            AS isErased
                     FROM tmpMI
                          FULL JOIN tmpMI_Parent_find ON tmpMI_Parent_find.MovementItemId = tmpMI.MovementItemId
                    )

       SELECT
             tmpResult.MovementItemId		AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpResult.Amount         :: TFloat AS Amount
           , tmpResult.Price          :: TFloat AS Price
           , tmpResult.PriceTax_calc  :: TFloat AS PriceTax_calc
           , tmpResult.PriceTo        :: TFloat AS PriceTo
           , tmpResult.CountForPrice  :: TFloat AS CountForPrice

           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName

           , CAST (CASE WHEN tmpResult.CountForPrice > 0
                        THEN CAST ( (COALESCE (tmpResult.Amount, 0)) * tmpResult.Price / tmpResult.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (tmpResult.Amount, 0)) * tmpResult.Price AS NUMERIC (16, 2))
                   END AS TFloat)               AS AmountSumm
           , tmpResult.isErased                 AS isErased

       FROM tmpResult
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
            
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
       WHERE vbShowAll = TRUE OR tmpResult.MovementItemId > 0
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.02.18         *
 31.03.15         *
 30.05.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PriceCorrective (inMovementId:= 8491746, inMovementId_Parent:= 8322508, inOperDate:= '31.01.2017', inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
