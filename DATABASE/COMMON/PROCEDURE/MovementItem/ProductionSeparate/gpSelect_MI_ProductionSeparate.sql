-- Function: gpSelect_MI_ProductionSeparate()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionSeparate (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionSeparate(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inIsErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;

   DECLARE vbIsSummIn Boolean;
   DECLARE vbIs_pl    Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   vbIsSummIn:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) OR vbUserId = 343013; -- Нагорная Я.Г.


   IF inShowAll = TRUE
   THEN
       OPEN Cursor1 FOR
       WITH -- себестоимость 
            tmpSummIn AS (SELECT MIContainer.MovementItemId, -1 * SUM (MIContainer.Amount) AS SummIn
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId = inMovementId
                            AND MIContainer.DescId     = zc_MIContainer_Summ()
                            AND MIContainer.isActive   = FALSE
                            AND vbIsSummIn             = TRUE
                          GROUP BY MIContainer.MovementItemId
                         )
       SELECT
             0                                      AS Id
           , 0                                      AS LineNum
           , tmpGoods.GoodsId                       AS GoodsId
           , tmpGoods.GoodsCode                     AS GoodsCode
           , tmpGoods.GoodsName                     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , 0                                      AS GoodsKindId
           , CAST ('' AS TVarChar)                  AS GoodsKindName

           , 0                                      AS StorageLineId_old
           , 0                                      AS StorageLineId
           , CAST ('' AS TVarChar)                  AS StorageLineName


           , CAST (NULL AS TFloat)                  AS Amount
           , 0                            :: TFloat AS PriceIn
           , 0                            :: TFloat AS SummIn
           , CAST (NULL AS TFloat)                  AS LiveWeight
           , CAST (NULL AS TFloat)                  AS HeadCount
           
           , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods()
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
            
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
             MovementItem.Id                        AS Id
--           , 0 AS LineNum
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS LineNum
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName

           , Object_StorageLine.Id                  AS StorageLineId_old
           , Object_StorageLine.Id                  AS StorageLineId
           , Object_StorageLine.ValueData           AS StorageLineName

           , MovementItem.Amount                    AS Amount
           , CASE WHEN MovementItem.Amount <> 0 THEN tmpSummIn.SummIn / MovementItem.Amount ELSE 0 END :: TFloat AS PriceIn
           , tmpSummIn.SummIn             :: TFloat AS SummIn
           , MIFloat_LiveWeight.ValueData           AS LiveWeight
           , MIFloat_HeadCount.ValueData            AS HeadCount

           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpSummIn ON tmpSummIn.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = MILinkObject_StorageLine.ObjectId

       ORDER BY 2--MovementItem.Id
            ;
    RETURN NEXT Cursor1;


   ELSE

    OPEN Cursor1 FOR
       WITH -- себестоимость 
            tmpSummIn AS (SELECT MIContainer.MovementItemId, -1 * SUM (MIContainer.Amount) AS SummIn
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId
                               AND MIContainer.DescId     = zc_MIContainer_Summ()
                               AND MIContainer.isActive   = FALSE
                               AND vbIsSummIn             = TRUE
                             GROUP BY MIContainer.MovementItemId
                             )
       SELECT
             MovementItem.Id					AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
           , Object_Goods.Id          			 AS GoodsId
           , Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName

           , Object_StorageLine.Id                       AS StorageLineId_old
           , Object_StorageLine.Id                       AS StorageLineId
           , Object_StorageLine.ValueData                AS StorageLineName

           , MovementItem.Amount			 AS Amount
           , CASE WHEN MovementItem.Amount <> 0 THEN tmpSummIn.SummIn / MovementItem.Amount ELSE 0 END :: TFloat AS PriceIn
           , tmpSummIn.SummIn                  :: TFloat AS SummIn
           , MIFloat_LiveWeight.ValueData                AS LiveWeight
           , MIFloat_HeadCount.ValueData 		 AS HeadCount
           , MovementItem.isErased                       AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpSummIn ON tmpSummIn.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = MILinkObject_StorageLine.ObjectId

       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor1;
   END IF;


    -- Если нужен zc_PriceList_ProductionSeparateHist
    vbIs_pl:= EXISTS (SELECT 1
                      FROM MovementItem
                           INNER JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                          ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                         AND MIBoolean_Calculated.ValueData      = TRUE
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                     );

    OPEN Cursor2 FOR
       WITH -- себестоимость 
            tmpSummIn AS (SELECT MIContainer.MovementItemId, 1 * SUM (MIContainer.Amount) AS SummIn
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId
                               AND MIContainer.DescId     = zc_MIContainer_Summ()
                               AND MIContainer.isActive   = TRUE
                               AND vbIsSummIn             = TRUE
                             GROUP BY MIContainer.MovementItemId
                             )
          , tmpPriceSeparateHist AS (SELECT * 
                                     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= CASE WHEN vbIs_pl = TRUE THEN zc_PriceList_ProductionSeparateHist() ELSE zc_PriceList_ProductionSeparate() END
                                                                              , inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                               ))

          
       SELECT
             MovementItem.Id			         AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
           , MovementItem.ParentId                       AS ParentId
           , Object_Goods.Id          			 AS GoodsId
           , Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName

           , CASE WHEN ObjectLink_GoodsGroup.ChildObjectId = 1918 THEN Object_GoodsGroup.ObjectCode ELSE 0 END ::Integer AS GoodsGroupCode
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName

           , Object_StorageLine.Id                       AS StorageLineId_old
           , Object_StorageLine.Id                       AS StorageLineId
           , Object_StorageLine.ValueData                AS StorageLineName

           , MovementItem.Amount			 AS Amount
           , CASE WHEN MovementItem.Amount <> 0 THEN tmpSummIn.SummIn / MovementItem.Amount ELSE 0 END :: TFloat AS PriceIn
           , tmpSummIn.SummIn :: TFloat                  AS SummIn
           , COALESCE (tmpPriceSeparateHist_kind.ValuePrice, tmpPriceSeparateHist.ValuePrice, 0)  :: TFloat AS PriceIn_hist
           , (MovementItem.Amount * COALESCE (tmpPriceSeparateHist_kind.ValuePrice, tmpPriceSeparateHist.ValuePrice, 0)):: TFloat AS SummIn_hist
           , MIFloat_LiveWeight.ValueData                AS LiveWeight
           , MIFloat_HeadCount.ValueData 		 AS HeadCount
           , COALESCE (MIBoolean_Calculated.ValueData, FALSE) ::Boolean AS isCalculated
           , MovementItem.isErased                       AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpSummIn ON tmpSummIn.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = MILinkObject_StorageLine.ObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                          ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

            -- привязываем цены 2 раза по виду товара и без                            
            LEFT JOIN tmpPriceSeparateHist ON tmpPriceSeparateHist.GoodsId   = MovementItem.ObjectId
                                          AND tmpPriceSeparateHist.GoodsKindId IS NULL
            LEFT JOIN tmpPriceSeparateHist AS tmpPriceSeparateHist_kind
                                           ON tmpPriceSeparateHist_kind.GoodsId   = MovementItem.ObjectId 
                                          AND COALESCE (tmpPriceSeparateHist_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)
            --сортировка по коду группы
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()

       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_ProductionSeparate (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.12.19         *
 07.10.18         * add isCalculated
 25.01.18         * StorageLineId_old
 26.05.17         * add StorageLine
 11.03.17         *
 31.03.15         * 
 02.06.14                                                       *
 27.05.14                                                       * поменял все
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionSeparate (inMovementId:= 1, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '2')
