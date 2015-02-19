-- Function: gptUpdateMI_OrderExternal_AmountForecast()

DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gptUpdateMI_OrderExternal_AmountForecast(
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
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());

     -- 
     vbPriceListId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PriceList());


RAISE EXCEPTION 'Ошибка.Параметр <Юридическое лицо> не установлен.';
    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecast TFloat) ON COMMIT DROP;
    
   INSERT INTO tmpAll ( MovementItemId, GoodsId, GoodsKindId, AmountForecast)  
                                 SELECT tmp.MovementItemId
                                       , COALESCE (tmp.GoodsId,tmpOrders.GoodsId) as GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpOrders.GoodsKindId) GoodsKindId
                                       , tmpOrders.AmountForecast
                                      
                                  From (
                                         SELECT MovementItem.ObjectId            AS GoodsId
                                              , MILinkObject_GoodsKind.ObjectId  AS GoodsKindId
                                              , SUM(MovementItem.Amount+MIFloat_AmountSecond.ValueData)::TFloat AS AmountForecast
                                         FROM  Movement 
                                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = False
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                            Where Movement.OperDate BETWEEN vbStartDate and vbEndDate
                                              AND Movement.DescId = zc_Movement_OrderExternal()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                                           GROUP BY  MovementItem.ObjectId
                                                   , MILinkObject_GoodsKind.ObjectId
                                           HAVING SUM(MovementItem.Amount+MIFloat_AmountSecond.ValueData) > 0   
                                       ) AS tmpOrders
                              Full Join 

                                (SELECT MovementItem.Id                 AS MovementItemId 
                                      , MovementItem.ObjectId           AS GoodsId
                                      , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                                      , MovementItem.Amount
                                 FROM  MovementItem 
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 Where MovementItem.MovementId = InMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = False
                                ) as tmp  ON tmp.GoodsId = tmpOrders.GoodsId
                                         AND tmp.GoodsKindId = tmpOrders.GoodsKindId
                                      ;                                              
                                       
--  RAISE EXCEPTION 'Ошибка.';
     -- сохранили
       PERFORM lpUpdate_MovementItem_OrderExternal ( inId                 := Coalesce(tmpAll.MovementItemId,0)::Integer
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := tmpAll.GoodsId
                                                   , inGoodsKindId        := Coalesce(tmpAll.GoodsKindId,0)::Integer
                                                   , inAmount_Param       := Coalesce(tmpAll.AmountForecast,0)::TFloat
                                                   , inDescId_Param       := zc_MIFloat_AmountForecast()--'::TVarChar
                                                   , inUserId             := vbUserId
                                                    ) 
                      FROM tmpAll;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.02.15         *
*/

-- тест
-- SELECT * FROM gptUpdateMI_OrderExternal_AmountForecast (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
 