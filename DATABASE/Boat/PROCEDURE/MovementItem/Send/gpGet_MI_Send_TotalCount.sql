-- Function: gpGet_MI_Send_TotalCount()

DROP FUNCTION IF EXISTS gpGet_MI_Send_TotalCount (Integer, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send_TotalCount(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inMovementItemId    Integer    ,
    IN inGoodsId           Integer    ,
    IN inPartNumber        TVarChar   , --
    IN inOperCount         TFloat     , --
   OUT outTotalCount       TFloat     , --
   OUT outAmountRemains    TFloat     , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId   Integer;
  DECLARE vbAmount   TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Данные для остатков
     /*SELECT Movement.OperDate, MLO_From.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From
                                       ON MLO_From.MovementId = inMovementId
                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;*/


     --
     vbAmount:= COALESCE ((SELECT SUM (MovementItem.Amount)
                           FROM MovementItem
                                LEFT JOIN MovementItemString AS MIString_PartNumber
                                                             ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                            AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.ObjectId   = inGoodsId
                             AND MovementItem.isErased   = FALSE
                             -- без этого элемента
                             AND MovementItem.Id         <> COALESCE (inMovementItemId, 0)
                             -- + ВСЕ S/N
                             -- AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                           ), 0);
     -- Остаток
     outAmountRemains:= COALESCE ((SELECT SUM (Container.Amount)
                                   FROM Container
                                        LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                     ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                                    AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                   WHERE Container.WhereObjectId = zc_Unit_Sklad() -- Всегда для этого Склада
                                     AND Container.DescId        = zc_Container_Count()
                                     -- для ОДНОГО товара
                                     AND Container.ObjectId      = inGoodsId
                                     -- + ВСЕ S/N
                                     -- AND COALESCE (MIString_PartNumber.ValueData, '') = COALESCE (inPartNumber,'')
                                   GROUP BY Container.ObjectId
                                  ), 0);

     --
     outTotalCount := COALESCE (inOperCount, 0) + vbAmount;

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