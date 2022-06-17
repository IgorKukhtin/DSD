-- Function: gpSelect_MI_OrderExternalChild()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderExternalChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderExternalChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, LineNum Integer
			 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Amount TFloat, AmountSecond TFloat
             , MovementId_income Integer, InvNumber_income TVarChar, OperDate_income TDateTime
             , isErased Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);


    -- Результат 
     RETURN QUERY
      WITH 
            -- Существующие MovementItem
            tmpMI_Child AS (SELECT MovementItem.Id
                                 , MovementItem.ParentId
                                 , MovementItem.ObjectId   AS GoodsId
                                 , MovementItem.Amount     AS Amount
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                            )
          , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )

          , tmpMI_Float AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_AmountSecond()
                                                             , zc_MIFloat_MovementId()
                                                              )
                           )

          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ParentId
                           , MovementItem.GoodsId                          AS GoodsId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MIFloat_AmountSecond.ValueData                AS AmountSecond
                           , MIFloat_Movement.ValueData                    AS MovementId_income
                           , MovementItem.isErased
                      FROM tmpMI_Child AS MovementItem
                           LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         
                           LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                                 ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                           LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                 ON MIFloat_Movement.MovementItemId = MovementItem.Id
                                                AND MIFloat_Movement.DescId = zc_MIFloat_MovementId()
                      )

       --Результат
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , tmpMI.ParentId       :: Integer
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName

           , tmpMI.Amount :: TFloat             AS Amount
           , tmpMI.AmountSecond :: TFloat       AS AmountSecond

           , Movement_Income.Id                 AS MovementId_income
           , Movement_Income.InvNumber          AS InvNumber_income
           , Movement_Income.OperDate           AS OperDate_income
		   , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpMI.MovementId_income
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderExternalChild (inMovementId:= 25173, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
