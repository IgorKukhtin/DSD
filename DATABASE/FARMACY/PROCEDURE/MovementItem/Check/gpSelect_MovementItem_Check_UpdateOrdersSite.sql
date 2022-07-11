-- Function: gpSelect_MovementItem_Check_UpdateOrdersSite()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_UpdateOrdersSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_UpdateOrdersSite(
    IN inMovementId       Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Price TFloat
             , Amount TFloat
             , AmountOrder TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    SELECT
           MovementItem.Id
         , MovementItem.GoodsId
         , MovementItem.GoodsCode
         , MovementItem.GoodsName
         , MovementItem.Price
         , MovementItem.Amount
         , MovementItem.AmountOrder
         , MovementItem.isErased
     FROM MovementItem_Check_View AS MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND COALESCE (MovementItem.AmountOrder, 0) > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpSelect_MovementItem_Check_UpdateOrdersSite (inMovementId:= 28455544, inSession:= '3')