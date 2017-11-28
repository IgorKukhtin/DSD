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
     CREATE TEMP TABLE _tmpData (GoodsId Integer, AmountOrder TFloat, AmountOut TFloat, AmountIn TFloat) ON COMMIT DROP;

     -- Данные Sale / Order / ReturnIn
     INSERT INTO _tmpData (GoodsId, AmountOrder, AmountOut, AmountIn)
        SELECT MovementItem.ObjectId            AS GoodsId
             , SUM( CASE WHEN Movement.DescId = zc_Movement_OrderExternal() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrder
             , SUM( CASE WHEN Movement.DescId = zc_Movement_Sale()          THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END) AS AmountOut
             , SUM( CASE WHEN Movement.DescId = zc_Movement_ReturnIn()      THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END) AS AmountIn
        FROM MovementItemFloat AS MIFloat_PromoMovement
             INNER JOIN MovementItem ON MovementItem.Id = MIFloat_PromoMovement.MovementItemId
             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_Sale(), zc_Movement_ReturnIn())
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        WHERE MIFloat_PromoMovement.ValueData = inMovementId
          AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
        GROUP BY MovementItem.ObjectId;

     -- Результат - если нет товара в док.акция записываем новый
     PERFORM gpInsertUpdate_MovementItem_PromoGoods (ioId                 := 0 :: Integer
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := _tmpData.GoodsId
                                                   , inAmount             := 0 :: TFloat
                                                   , ioPrice              := 0 :: TFloat
                                                   , inPriceSale          := 0 :: TFloat
                                                   , inAmountReal         := 0 :: TFloat
                                                   , inAmountPlanMin      := 0 :: TFloat
                                                   , inAmountPlanMax      := 0 :: TFloat
                                                   , inGoodsKindId        := 0 :: Integer
                                                   , inGoodsKindCompleteId:= 0 :: Integer
                                                   , inComment            := NULL
                                                   , inSession            := CASE WHEN inSession = zfCalc_UserAdmin() THEN '-12345' ELSE inSession END
                                                    )
     FROM _tmpData
          LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods 
                                                 ON MI_PromoGoods.MovementId = inMovementId
                                                AND MI_PromoGoods.GoodsId    = _tmpData.GoodsId
                                                AND MI_PromoGoods.isErased   = FALSE
     WHERE MI_PromoGoods.Id IS NULL
    ;    

     -- Результат - записываем в MovementItem Акция
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut()  , tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountOut, 0) END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountOrder, 0) END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn()   , tmp.Id, CASE WHEN tmp.isErased = TRUE THEN 0 ELSE COALESCE (tmp.AmountIn, 0) END)
     FROM (SELECT MI_PromoGoods.Id
                , MI_PromoGoods.isErased
                , COALESCE (_tmpData.AmountOut, 0)   /* * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END*/ AS AmountOut
                , COALESCE (_tmpData.AmountOrder, 0) /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END*/  AS AmountOrder
                , COALESCE (_tmpData.AmountIn, 0)    /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END*/  AS AmountIn
           FROM MovementItem_PromoGoods_View AS MI_PromoGoods
                LEFT JOIN _tmpData ON _tmpData.GoodsId       = MI_PromoGoods.GoodsId
                    --              AND MI_PromoGoods.isErased = FALSE
                /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = MI_PromoGoods.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                      ON ObjectFloat_Goods_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                                     AND ObjectFloat_Goods_Weight.DescId   = zc_ObjectFloat_Goods_Weight()*/
           WHERE MI_PromoGoods.MovementId = inMovementId
           ) AS tmp
    ;

     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 21.07.17         *
*/

-- тест
--SELECT * FROM gpInsertUpdate_MI_Promo_Param (inMovementId:= 5047886 , inSession:= zfCalc_UserAdmin())
