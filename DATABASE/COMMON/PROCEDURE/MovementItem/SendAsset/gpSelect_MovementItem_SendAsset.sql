-- Function: gpSelect_MovementItem_SendAsset()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendAsset (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendAsset(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , ContainerId Integer
             , Amount TFloat
             , AmountRemains TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbFromId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется
     SELECT MovementLinkObject_From.ObjectId
            INTO vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

    -- Результат
     RETURN QUERY
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , MIFloat_ContainerId.ValueData      :: Integer AS ContainerId
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                   )

          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , SUM (Container.Amount) AS Amount
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                    AND Container.Amount   <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbFromId
                           GROUP BY tmpMI_Goods.MovementItemId
                          )

       -- Результат
       SELECT
             tmpMI_Goods.MovementItemId         AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Asset_AssetGroup.ValueData         AS GoodsGroupNameFull

           , tmpMI_Goods.ContainerId
           , tmpMI_Goods.Amount                 AS Amount
           , tmpRemains.Amount :: TFloat        AS AmountRemains
           
           , tmpMI_Goods.isErased               AS isErased

       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
             
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
            LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.20         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SendAsset (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_SendAsset (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')