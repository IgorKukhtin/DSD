-- Function: gpSelect_MI_Income_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_Income_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Income_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , InvNumber_OrderClient_Full TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
   , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )


     SELECT
         MovementItem.Id
       , MovementItem.ParentId
       , MovementItem.GoodsId      AS GoodsId
       , Object_Goods.ObjectCode   AS GoodsCode
       , Object_Goods.ValueData    AS GoodsName
       , MovementItem.Amount           ::TFloat
       , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient_Full
       , MovementItem.isErased

     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
          LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
          LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_Income_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
