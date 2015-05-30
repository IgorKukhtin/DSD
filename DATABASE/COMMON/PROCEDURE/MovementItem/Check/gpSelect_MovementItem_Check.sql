-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check(
    IN inMovementId  Integer      , -- ключ Документа
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

       FROM MovementItem_Check_View AS MovementItem 
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased   = false;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Check (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.15                         *
 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
