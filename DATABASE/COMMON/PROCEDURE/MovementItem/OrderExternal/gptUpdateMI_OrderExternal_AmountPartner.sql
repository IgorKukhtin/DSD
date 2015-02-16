
DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountPartner (Integer,TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gptUpdateMI_OrderExternal_AmountPartner(
 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS--RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());

    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat) ON COMMIT DROP;
    
   INSERT INTO tmpAll ( MovementItemId, GoodsId, GoodsKindId, AmountPartner)   --, Amount
                                 SELECT tmp.MovementItemId
                                       , COALESCE (tmp.GoodsId,tmpOrders.GoodsId) as GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpOrders.GoodsKindId) GoodsKindId
                                       , tmpOrders.AmountPartner
                                       --, tmp.Amount
                                  From (
                                         SELECT MovementItem.ObjectId            AS GoodsId
                                              , MILinkObject_GoodsKind.ObjectId  AS GoodsKindId
                                              , SUM(MovementItem.Amount+MIFloat_AmountSecond.ValueData)::TFloat AS AmountPartner
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
                                            Where Movement.OperDate = inOperDate
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
                                                   , inAmount_Param       := Coalesce(tmpAll.AmountPartner,0)::TFloat
                                                   , inDescId_Param       := zc_MIFloat_AmountPartner()--'::TVarChar
                                                   , inUserId             := vbUserId
                                                    ) 
                      FROM tmpAll;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.02.15         *
*/

-- тест
-- SELECT * FROM gptUpdateMI_OrderExternal_AmountPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
 