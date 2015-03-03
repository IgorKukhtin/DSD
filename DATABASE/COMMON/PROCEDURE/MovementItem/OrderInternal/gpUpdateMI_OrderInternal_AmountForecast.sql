-- Function: gpUpdateMI_OrderInternal_AmountForecast()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecast(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStartDate           TDateTime , -- Дата документа
    IN inEndDate             TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPriceListId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- 
     vbOperDate:= (SELECT ValueData FROM MovementDate WHERE MovementId = inMovementId AND DescId = zc_MovementDate_OperDatePartner());


    -- таблица -
 /*  CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecast TFloat) ON COMMIT DROP;
    
   INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecast)
                                 SELECT MovementItem.Id                               AS MovementItemId 
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , MovementItem.Amount
                                 FROM MovementItem 
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                
                     ;

       -- сохранили
       PERFORM lpUpdate_MovementItem_OrderInternal_Property (inId                 := tmpAll.MovementItemId
                                                           , inMovementId         := inMovementId
                                                           , inGoodsId            := tmpAll.GoodsId
                                                           , inGoodsKindId        := tmpAll.GoodsKindId
                                                           , inAmount_Param       := tmpAll.AmountForecast
                                                           , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                           , inAmount_ParamOrder  := tmpAll.AmountForecastOrder
                                                           , inDescId_ParamOrder  := zc_MIFloat_AmountForecastOrder()

                                                           , inUserId             := vbUserId
                                                            ) 
       FROM tmpAll
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpAll.GoodsId

      ;
*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.03.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountForecast (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
 