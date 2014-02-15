-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, FuelCode Integer, FuelName TVarChar
             , Amount TFloat, HeadCount TFloat, Count TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar
             , AssetId Integer, AssetName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId := inSession;

     IF inShowAll THEN 

     RETURN QUERY 
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
       SELECT
             MI_Master.Id
           , Goods.Id          AS GoodsId
           , Goods.GoodsCode
           , Goods.GoodsName
           , Goods.FuelCode
           , Goods.FuelName
           , MI_Master.Amount AS Amount
           , MI_Master.Count
           , MI_Master.HeadCount
           , MI_Master.PartionGoods
           , COALESCE(MI_Master.GoodsKindId, Goods.GoodsKindId) AS GoodsKindId 
           , COALESCE(MI_Master.GoodsKindName, Goods.GoodsKindName) AS GoodsKindName
           , MI_Master.AssetId
           , MI_Master.AssetName
           , COALESCE(MI_Master.isErased, FALSE) AS isErased
       FROM (SELECT Object_Goods.Id 
                  , Object_Goods.ObjectCode  AS GoodsCode
                  , Object_Goods.ValueData   AS GoodsName
                  , Object_Fuel.ObjectCode   AS FuelCode
                  , Object_Fuel.ValueData    AS FuelName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId  
                  , Object_GoodsByGoodsKind_View.GoodsKindName
             FROM Object AS Object_Goods
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                       ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                  LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
             WHERE Object_Goods.DescId = zc_Object_Goods()
               AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
            UNION ALL
             SELECT Object_Goods.Id 
                  , Object_Goods.ObjectCode  AS GoodsCode
                  , Object_Goods.ValueData   AS GoodsName
                  , Object_Fuel.ObjectCode   AS FuelCode
                  , Object_Fuel.ValueData    AS FuelName
                  , 0 AS GoodsKindId  
                  , '' :: TVarChar AS GoodsKindName
             FROM ObjectLink AS ObjectLink_TicketFuel_Goods
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_TicketFuel_Goods.ChildObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                       ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                  LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
             WHERE ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
               AND vbUserId IN (SELECT UserId FROM tmpUserTransport)
            ) AS Goods
       FULL JOIN
            (SELECT MovementItem.Id
                  , MovementItem.ObjectId           AS GoodsId
                  , MovementItem.Amount             AS Amount
                  , MIFloat_Count.ValueData         AS Count
                  , MIFloat_HeadCount.ValueData     AS HeadCount
                  , MIString_PartionGoods.ValueData AS PartionGoods
                  , COALESCE(MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , Object_GoodsKind.ValueData AS GoodsKindName
                  , Object_Asset.Id         AS AssetId
                  , Object_Asset.ValueData  AS AssetName
                  , MovementItem.isErased
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId =  zc_MI_Master()
                 AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)) AS MI_Master
            ON Goods.Id = MI_Master.GoodsId AND Goods.GoodsKindId = MI_Master.GoodsKindId;

     ELSE
  
     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , Object_Fuel.ObjectCode   AS FuelCode
           , Object_Fuel.ValueData    AS FuelName
           , MovementItem.Amount
           , MIFloat_Count.ValueData     AS Count
           , MIFloat_HeadCount.ValueData AS HeadCount

           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           
           , Object_Asset.Id         AS AssetId
           , Object_Asset.ValueData  AS AssetName

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
            LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master()
         AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);
 
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add FuelName and tmpUserTransport
 30.10.13                       *            FULL JOIN
 29.10.13                       *            add GoodsKindId
 22.07.13         * add Count                              
 18.07.13         * add Object_Asset               
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
