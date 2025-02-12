 -- Function: gpInsertUpdate_MI_Promo_Param()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_Param (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_Param(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());

     -- данные по документам Данные Sale / Order / ReturnIn где установлен признак "акция"
     CREATE TEMP TABLE _tmpData (GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOut TFloat, AmountIn TFloat, ChangePercent TFloat) ON COMMIT DROP;

     -- Данные Sale / Order / ReturnIn
     INSERT INTO _tmpData (GoodsId, GoodsKindId, AmountOrder, AmountOut, AmountIn, ChangePercent)
        SELECT MovementItem.ObjectId                         AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , SUM (CASE WHEN Movement.DescId = zc_Movement_OrderExternal() THEN COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrder
             , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountOut
             , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()      THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountIn
             , MAX (COALESCE (MIFloat_ChangePercent.ValueData, 0)) AS ChangePercent
        FROM MovementItemFloat AS MIFloat_PromoMovement
             INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_PromoMovement.MovementItemId
                                    AND MovementItem.isErased = FALSE
             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_Sale(), zc_Movement_ReturnIn())
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
        WHERE MIFloat_PromoMovement.ValueData = inMovementId
          AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
        GROUP BY MovementItem.ObjectId
               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                ;
/*
     -- Результат - если нет товара в док.акция записываем новый
     PERFORM gpInsertUpdate_MovementItem_PromoGoods (ioId                 := 0
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := tmp.GoodsId
                                                   , inAmount             := tmp.Amount
                                                   , ioPrice              := tmp.Price
                                                   , inPriceSale          := tmp.PriceSale
                                                   , inPriceTender        := tmp.PriceTender
                                                   , inAmountReal         := 0 :: TFloat
                                                   , inAmountPlanMin      := 0 :: TFloat
                                                   , inAmountPlanMax      := 0 :: TFloat
                                                   , ioGoodsKindId        := tmp.GoodsKindId
                                                   , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                   , inComment            := NULL
                                                   , inSession            := CASE WHEN inSession = zfCalc_UserAdmin() THEN '-12345' ELSE inSession END
                                                    )
     FROM (WITH tmpData AS (SELECT _tmpData.*
                            FROM _tmpData
                                 LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                                        ON MI_PromoGoods.MovementId           = inMovementId
                                                                       AND MI_PromoGoods.GoodsId              = _tmpData.GoodsId
                                                                       AND (MI_PromoGoods.GoodsKindCompleteId = _tmpData.GoodsKindId
                                                                         OR COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) = 0
                                                                           )
                                                                       AND MI_PromoGoods.isErased             = FALSE
                            WHERE MI_PromoGoods.Id IS NULL
                           )
              , tmpFind AS (SELECT tmpData.GoodsId     AS GoodsId
                                 , MI_PromoGoods.Amount
                                 , MI_PromoGoods.Price
                                 , MI_PromoGoods.PriceSale
                                 , MIFloat_PriceTender.ValueData AS PriceTender
                                 , MI_PromoGoods.GoodsKindId
                                   --  № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY tmpData.GoodsId ORDER BY MI_PromoGoods.Amount DESC) AS Ord
                            FROM tmpData
                                 INNER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                                         ON MI_PromoGoods.MovementId           = inMovementId
                                                                        AND MI_PromoGoods.GoodsId              = tmpData.GoodsId
                                                                        AND MI_PromoGoods.isErased             = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_PriceTender
                                                             ON MIFloat_PriceTender.MovementItemId = MI_PromoGoods.Id
                                                            AND MIFloat_PriceTender.DescId         = zc_MIFloat_PriceTender()
                           )
           -- Результат
           SELECT tmpData.GoodsId                                  AS GoodsId
                , tmpData.GoodsKindId                              AS GoodsKindCompleteId
                , COALESCE (tmpFind.Amount, tmpData.ChangePercent) AS Amount
                , COALESCE (tmpFind.Price, 0)                      AS Price
                , COALESCE (tmpFind.PriceSale, 0)                  AS PriceSale
                , COALESCE (tmpFind.PriceTender, 0)                AS PriceTender
                , tmpFind.GoodsKindId
           FROM tmpData
                LEFT JOIN tmpFind ON tmpFind.GoodsId = tmpData.GoodsId
                                 AND tmpFind.Ord     = 1
          ) AS tmp
    ;
*/
     -- Результат - записываем в MovementItem Акция
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut()  , tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountOut, 0) END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountOrder, 0) END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn()   , tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountIn, 0) END)
     FROM (WITH tmpData_sum AS (SELECT _tmpData.GoodsId, SUM (_tmpData.AmountOrder) AS AmountOrder, SUM (_tmpData.AmountOut) AS AmountOut, SUM (_tmpData.AmountIn) AS AmountIn
                                FROM _tmpData
                                GROUP BY _tmpData.GoodsId
                               )
              , tmpData_promo AS (SELECT MI_PromoGoods.Id
                                       , MI_PromoGoods.GoodsId
                                       , CASE WHEN MI_PromoGoods.GoodsKindId > 0 THEN MI_PromoGoods.GoodsKindId ELSE MI_PromoGoods.GoodsKindCompleteId END AS GoodsKindId
                                     --, MI_PromoGoods.GoodsKindCompleteId
                                       , MI_PromoGoods.isErased
                                         --  № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY MI_PromoGoods.GoodsId ORDER BY MI_PromoGoods.Amount DESC) AS Ord
                                  FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                                  WHERE MI_PromoGoods.MovementId = inMovementId
                                    AND MI_PromoGoods.isErased   = FALSE
                                 )
              , tmpData_notFind AS (SELECT _tmpData.GoodsId, SUM (_tmpData.AmountOrder) AS AmountOrder, SUM (_tmpData.AmountOut) AS AmountOut, SUM (_tmpData.AmountIn) AS AmountIn
                                    FROM _tmpData
                                         LEFT JOIN tmpData_promo ON tmpData_promo.GoodsId             = _tmpData.GoodsId
                                                              --AND tmpData_promo.GoodsKindCompleteId = _tmpData.GoodsKindId
                                                                AND tmpData_promo.GoodsKindId         = _tmpData.GoodsKindId
                                    WHERE tmpData_promo.GoodsId IS NULL
                                    GROUP BY _tmpData.GoodsId
                                   )
           -- если в продажах "другие" виды упаковки
           /*SELECT MI_PromoGoods.Id
                , MI_PromoGoods.isErased
                , CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_sum.AmountOut,   0) ELSE 0 END AS AmountOut     -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                , CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_sum.AmountOrder, 0) ELSE 0 END AS AmountOrder   -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                , CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_sum.AmountIn,    0) ELSE 0 END AS AmountIn      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
           FROM tmpData_promo AS MI_PromoGoods
                JOIN tmpData_notFind ON tmpData_notFind.GoodsId = MI_PromoGoods.GoodsId
                LEFT JOIN tmpData_sum ON tmpData_sum.GoodsId = MI_PromoGoods.GoodsId
           -- WHERE MI_PromoGoods.Ord = 1

          UNION ALL*/
           -- если в продажах "такие же" виды упаковки
           SELECT MI_PromoGoods.Id
                , MI_PromoGoods.isErased
                , COALESCE (_tmpData.AmountOut,   0) + CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_notFind.AmountOut,   0) ELSE 0 END  AS AmountOut      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                , COALESCE (_tmpData.AmountOrder, 0) + CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_notFind.AmountOrder, 0) ELSE 0 END  AS AmountOrder    -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                , COALESCE (_tmpData.AmountIn,    0) + CASE WHEN MI_PromoGoods.Ord = 1 THEN COALESCE (tmpData_notFind.AmountIn,    0) ELSE 0 END  AS AmountIn       -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
           FROM tmpData_promo AS MI_PromoGoods
                LEFT JOIN tmpData_notFind ON tmpData_notFind.GoodsId = MI_PromoGoods.GoodsId
                LEFT JOIN _tmpData ON _tmpData.GoodsId     = MI_PromoGoods.GoodsId
                                --AND _tmpData.GoodsKindId = MI_PromoGoods.GoodsKindCompleteId
                                  AND _tmpData.GoodsKindId = MI_PromoGoods.GoodsKindId
           -- WHERE tmpData_notFind.GoodsId IS NULL
          ) AS tmp
    ;

    -- Пересчет
    PERFORM gpInsertUpdate_MI_Promo_Detail (inMovementId:= inMovementId, inSession:= inSession);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 21.07.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Promo_Param (inMovementId:= 5047886 , inSession:= zfCalc_UserAdmin())
