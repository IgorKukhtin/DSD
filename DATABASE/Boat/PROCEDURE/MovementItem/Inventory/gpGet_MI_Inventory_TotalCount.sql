-- Function: gpGet_MI_Inventory_TotalCount()

DROP FUNCTION IF EXISTS gpGet_MI_Inventory_TotalCount (Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Inventory_TotalCount (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Inventory_TotalCount(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inGoodsId           Integer    ,
    IN inPartNumber        TVarChar   , --
    IN inOperCount         TFloat     , --
   OUT outTotalCount       TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     outTotalCount := (COALESCE (inOperCount,0) + COALESCE ((SELECT SUM (MovementItem.Amount)
                                                             FROM MovementItem
                                                                  LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                                               ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                                                              AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                             WHERE MovementItem.MovementId = inMovementId
                                                               AND MovementItem.DescId = zc_MI_Master()
                                                               AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE
                                                               AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                                                             ), 0)
                       );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.22         *
*/

-- тест
--