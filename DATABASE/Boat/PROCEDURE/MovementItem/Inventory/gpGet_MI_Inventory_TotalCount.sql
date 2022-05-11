-- Function: gpGet_MI_Inventory_TotalCount()

DROP FUNCTION IF EXISTS gpGet_MI_Inventory_TotalCount (Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Inventory_TotalCount (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Inventory_TotalCount(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inGoodsId           Integer    ,
    IN inPartNumber        TVarChar   , --
    IN inOperCount         TFloat     , --
   OUT outTotalCount       TFloat     , --
   OUT outAmountRemains    TFloat     , --
   OUT outAmountDiff       TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbAmount   TFloat;
  DECLARE vbUnitId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Данные для остатков
     SELECT Movement.OperDate, MLO_Unit.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;


     --
     vbAmount:= COALESCE ((SELECT SUM (MovementItem.Amount)
                           FROM MovementItem
                                LEFT JOIN MovementItemString AS MIString_PartNumber
                                                             ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE
                             AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                           ), 0);
     outAmountRemains:= COALESCE ((SELECT SUM (Container.Amount)
                                   FROM Container
                                        LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                     ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                                    AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                   WHERE Container.WhereObjectId = vbUnitId
                                     AND Container.DescId        = zc_Container_Count()
                                     AND Container.ObjectId      = inGoodsId
                                     AND COALESCE (MIString_PartNumber.ValueData, '') = COALESCE (inPartNumber,'')
                                   GROUP BY Container.ObjectId
                                          , COALESCE (MIString_PartNumber.ValueData, '')
                                  ), 0);

     --
     outTotalCount := COALESCE (inOperCount, 0) + vbAmount;
     --
     outAmountDiff:= outTotalCount - outAmountRemains;

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