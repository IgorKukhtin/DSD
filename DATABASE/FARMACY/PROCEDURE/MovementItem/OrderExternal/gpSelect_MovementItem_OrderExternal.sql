-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsId Integer, PartnerGoodsCode TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat, PartionGoodsDate TDateTime
             ,Comment TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

     RETURN QUERY
       SELECT
             tmpMI.Id            AS Id
           , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
           , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
           , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
           , tmpMI.PartnerGoodsId       AS PartnerGoodsId 
           , tmpMI.PartnerGoodsCode     AS PartnerGoodsCode
           , tmpMI.Amount               AS Amount
           , tmpMI.Price                AS Price
           , tmpMI.Summ::TFloat         AS Summ
           , tmpMI.PartionGoodsDate     AS PartionGoodsDate
           , tmpMI.Comment              AS Comment
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods() AND inShowAll = true AND 
                   Object_Goods.isErased = false ) AS tmpGoods

            FULL JOIN (SELECT 
                              MovementItem.Id 
                            , MovementItem.PartnerGoodsCode
                            , MovementItem.PartnerGoodsId
                            , MovementItem.GoodsCode
                            , MovementItem.GoodsName
                            , MovementItem.Amount
                            , MovementItem.Price
                            , MovementItem.Summ
                            , MovementItem.isErased
                            , MovementItem.GoodsId
                            , MovementItem.PartionGoodsDate
                            , MovementItem.Comment
                            
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem_OrderExternal_View AS MovementItem 
                                              ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId  = tmpGoods.GoodsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.12.14                         *
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
