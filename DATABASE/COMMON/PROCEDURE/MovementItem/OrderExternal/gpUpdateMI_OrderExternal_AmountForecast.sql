-- Function: gpUpdateMI_OrderExternal_AmountForecast()

DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderExternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderExternal_AmountForecast(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());

     --
     vbPriceListId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PriceList());
     vbOperDate:= (SELECT ValueData FROM MovementDate WHERE MovementId = inMovementId AND DescId = zc_MovementDate_OperDatePartner());


    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecast TFloat) ON COMMIT DROP;

   INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecast)
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
                                       , COALESCE (tmp.GoodsId,tmpAll.GoodsId)          AS GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpAll.GoodsKindId) AS GoodsKindId
                                       , COALESCE (tmpAll.AmountOrder, 0)               AS AmountForecastOrder
                                       , COALESCE (tmpAll.AmountSale, 0)                AS AmountForecast
                                 FROM (SELECT tmpAll.GoodsId
                                            , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN tmpAll.GoodsKindId ELSE 0 END AS GoodsKindId
                                            , SUM (tmpAll.AmountOrder) AS AmountOrder
                                            , SUM (tmpAll.AmountSale)  AS AmountSale
                                       FROM
                                      (SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountOrder
                                            , 0                                                                        AS AmountSale
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = inUnitId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                                      UNION ALL
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountSale
                                       FROM MovementDate AS MovementDate_OperDatePartner
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = MovementDate_OperDatePartner.MovementId
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                         AND MovementLinkObject_From.ObjectId = inUnitId
                                            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                               AND Movement.DescId = zc_Movement_Sale()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) <> 0
                                       ) AS tmpAll
                                       LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpAll.GoodsId
                                       GROUP BY tmpAll.GoodsId
                                              , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN tmpAll.GoodsKindId ELSE 0 END
                                       ) AS tmpAll
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
                                ) AS tmp  ON tmp.GoodsId = tmpAll.GoodsId
                                         AND tmp.GoodsKindId = tmpAll.GoodsKindId
                     ;


       -- таблица -  Цены из прайса
      CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect;


       -- сохранили
       PERFORM lpUpdate_MovementItem_OrderExternal_Property (inId                 := tmpAll.MovementItemId
                                                           , inMovementId         := inMovementId
                                                           , inGoodsId            := tmpAll.GoodsId
                                                           , inGoodsKindId        := tmpAll.GoodsKindId
                                                           , inAmount_Param       := tmpAll.AmountForecast
                                                           , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                           , inAmount_ParamOrder  := tmpAll.AmountForecastOrder
                                                           , inDescId_ParamOrder  := zc_MIFloat_AmountForecastOrder()
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
 16.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderExternal_AmountForecast (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
