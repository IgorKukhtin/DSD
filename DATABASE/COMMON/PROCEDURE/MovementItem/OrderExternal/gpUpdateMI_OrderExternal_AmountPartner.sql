-- Function: gpUpdateMI_OrderExternal_AmountPartner()

DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountPartner (Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderExternal_AmountPartner (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderExternal_AmountPartner(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());

    --
    vbPriceListId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PriceList());

    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner)
                                 WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , TRUE AS isGoodsKind
                                                   FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   WHERE ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                     )
                                                  )
                                 SELECT tmp.MovementItemId
                                       , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
                                       , COALESCE (tmpOrder.AmountPartner, 0)             AS AmountPartner
                                 FROM (SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountPartner
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = inUnitId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                            AND tmpGoods.isGoodsKind = TRUE
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate = inOperDate
                                         AND Movement.DescId = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                                       ) AS tmpOrder
                                 FULL JOIN
                                (SELECT MovementItem.Id                               AS MovementItemId
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
                                ) AS tmp  ON tmp.GoodsId = tmpOrder.GoodsId
                                         AND tmp.GoodsKindId = tmpOrder.GoodsKindId
                     ;

       -- таблица -  Цены из прайса
      CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= inOperDate) AS lfSelect;

       -- сохранили
       PERFORM lpUpdate_MovementItem_OrderExternal_Property (inId                 := tmpAll.MovementItemId
                                                           , inMovementId         := inMovementId
                                                           , inGoodsId            := tmpAll.GoodsId
                                                           , inGoodsKindId        := tmpAll.GoodsKindId
                                                           , inAmount_Param       := tmpAll.AmountPartner
                                                           , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                           , inAmount_ParamOrder  := NULL
                                                           , inDescId_ParamOrder  := NULL
                                                           , inPrice              := COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0) :: TFloat
                                                           , inCountForPrice      := 1
                                                           , inUserId             := vbUserId
                                                            )
       FROM tmpAll
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpAll.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL
            LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                   ON tmpPriceList_kind.GoodsId = tmpAll.GoodsId
                                  AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (tmpAll.GoodsKindId, 0)
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.12.19         *
 14.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderExternal_AmountPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
