-- Function: gpInsertUpdate_MovementItem_UnnamedEnterprises_AllGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_UnnamedEnterprises_AllGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_UnnamedEnterprises_AllGoods(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , Remains TFloat
             , Price TFloat
             , MovementItemId Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_UnnamedEnterprises());
    vbUserId := inSession;

    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_Unit
    WHERE MovementLinkObject_Unit.MovementId = inMovementId
      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();
      
    IF COALESCE (inMovementId, 0) = 0 OR COALESCE (vbUnitId, 0) = 0
    THEN
      Return;
    END IF;


    -- Remains
    CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS
    SELECT Container.Objectid             AS GoodsId
         , SUM(Container.Amount)::TFloat  AS Remains
    FROM Container 
    WHERE Container.WhereObjectId = vbUnitId
      AND Container.DescId = zc_Container_Count()
      AND Container.Amount <> 0
    GROUP BY Container.Objectid
    HAVING SUM(Container.Amount) <> 0;

    ANALYSE tmpRemains;

    --raise notice 'tmpRemains: % <%>', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpRemains);

    -- tmpPrice
    CREATE TEMP TABLE tmpPrice ON COMMIT DROP AS
    SELECT Price_Goods.ChildObjectId                AS GoodsId
         , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                              AND ObjectFloat_Goods_Price.ValueData > 0
                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                             ELSE ROUND (Price_Value.ValueData, 2)
                             END :: TFloat                           AS Price
    FROM ObjectLink AS ObjectLink_Price_Unit
         LEFT JOIN ObjectLink AS Price_Goods
                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
         -- Фикс цена для всей Сети
         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                               AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                 ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
    WHERE ObjectLink_Price_Unit.ChildObjectId = vbUnitId
      AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit();

    ANALYSE tmpPrice;

    --raise notice 'tmpPrice: % <%>', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpPrice);

    RETURN QUERY
    SELECT tmpRemains.GoodsId 
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , tmpRemains.Remains 
         , tmpPrice.Price
         , lpInsertUpdate_MovementItem_UnnamedEnterprises (ioId                 := COALESCE (MovementItem.Id, 0)
                                                         , inMovementId         := inMovementId
                                                         , inGoodsId            := tmpRemains.GoodsId 
                                                         , inAmount             := tmpRemains.Remains 
                                                         , inAmountOrder        := COALESCE(MIFloat_AmountOrder.ValueData, 0)
                                                         , inPrice              := tmpPrice.Price
                                                         , inSumm               := ROUND(COALESCE(tmpRemains.Remains, 0)*COALESCE(tmpPrice.Price, 0), 2)
                                                         , inSummOrder          := ROUND(COALESCE(MIFloat_AmountOrder.ValueData, 0) * COALESCE(tmpPrice.Price, 0), 2)
                                                         , inNDSKindId          := Object_Goods_Main.NDSKindId 
                                                         , inUserId             := vbUserId
                                                          )
    FROM tmpRemains
     
         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemains.GoodsId

         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemains.GoodsId 
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         LEFT JOIN MovementItem ON MovementItem.MovementID = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.ObjectId = tmpRemains.GoodsId

         LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                               
    WHERE tmpRemains.Remains <> COALESCE (MovementItem.Amount, 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.10.23                                                      *
*/


-- тест
-- 
select * from gpInsertUpdate_MovementItem_UnnamedEnterprises_AllGoods(inMovementId := 33731374  ,  inSession := '3');


