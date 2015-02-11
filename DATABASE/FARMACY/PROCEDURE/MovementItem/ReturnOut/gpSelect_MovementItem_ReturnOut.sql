-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     IF inShowAll THEN

     RETURN QUERY
              SELECT
             MovementItem_ReturnOut.Id
           , MovementItem_Income.Id  
           , COALESCE(MovementItem_ReturnOut.GoodsId, MovementItem_Income.GoodsId) AS GoodsId
           , COALESCE(MovementItem_ReturnOut.GoodsCode, MovementItem_Income.GoodsCode) AS GoodsCode
           , COALESCE(MovementItem_ReturnOut.GoodsName, MovementItem_Income.GoodsName) AS GoodsName
           , MovementItem_ReturnOut.Amount
           , COALESCE(MovementItem_ReturnOut.Price, MovementItem_Income.Price) AS Price
           , MovementItem_ReturnOut.AmountSumm
           , MovementItem_ReturnOut.isErased

       FROM MovementItem_Income_View AS MovementItem_Income

      FULL JOIN MovementItem_ReturnOut_View AS MovementItem_ReturnOut ON MovementItem_ReturnOut.MovementId = inMovementId
                                                                     AND MovementItem_ReturnOut.ParentId = MovementItem_Income.Id
       LEFT JOIN (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                                                     ON MovementItem_ReturnOut.isErased   = tmpIsErased.isErased
       WHERE MovementItem_Income.MovementId = (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId );

     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id
           , MovementItem.ParentId  
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem_ReturnOut_View AS MovementItem ON MovementItem.MovementId = inMovementId
                                                            AND MovementItem.isErased   = tmpIsErased.isErased;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.15                         *
 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
