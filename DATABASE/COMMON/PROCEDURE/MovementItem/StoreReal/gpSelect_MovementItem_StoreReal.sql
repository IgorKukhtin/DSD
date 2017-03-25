-- Function: gpSelect_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_StoreReal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_StoreReal (Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_StoreReal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      ,
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                       Integer
             , LineNum                  Integer
             , GoodsId                  Integer
             , GoodsCode                Integer
             , GoodsName                TVarChar
             , GoodsGroupNameFull       TVarChar
             , Amount                   TFloat
             , GoodsKindId              Integer
             , GoodsKindName            TVarChar
             , MeasureName              TVarChar
             , InfoMoneyCode            Integer
             , InfoMoneyGroupName       TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyName            TVarChar
             , GUID                     TVarChar
             , isErased                 Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_StoreReal());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , MovementItem.Amount                           AS Amount
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MIString_GUID.ValueData                       AS GUID
                                  , MovementItem.isErased
                             FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemString AS MIString_GUID
                                                               ON MIString_GUID.MovementItemId = MovementItem.Id
                                                              AND MIString_GUID.DescId = zc_MIString_GUID()
                            )
        SELECT tmpMI.MovementItemId    AS Id
             , (ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId))::Integer AS LineNum
             , tmpMI.GoodsId
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , tmpMI.Amount
             , tmpMI.GoodsKindId
             , Object_GoodsKind.ValueData AS GoodsKindName
             , Object_Measure.ValueData   AS MeasureName

             , Object_InfoMoney.ObjectCode           AS InfoMoneyCode
             , Object_InfoMoneyGroup.ValueData       AS InfoMoneyGroupName
             , Object_InfoMoneyDestination.ValueData AS InfoMoneyDestinationName
             , Object_InfoMoney.ValueData            AS InfoMoneyName

             , tmpMI.GUID
             , tmpMI.isErased
        FROM tmpMI_Goods AS tmpMI
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination 
                                  ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id 
                                 AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
             LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup 
                                  ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id 
                                 AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
             LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.03.17         *
 28.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_StoreReal (inMovementId:= 5285619, inPriceListId:= 0, inOperDate:= CURRENT_DATE, inShowAll:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
