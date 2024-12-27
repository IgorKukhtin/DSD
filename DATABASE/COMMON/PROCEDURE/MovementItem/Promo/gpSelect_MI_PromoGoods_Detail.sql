-- Function: gpSelect_MI_PromoGoods_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор 
      , ParentId            Integer --Главный элемент документа (товары)
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkName       TVarChar --Торговая марка
      , GoodsWeight         TFloat -- вес товара
      , Amount              TFloat -- Кол-во реализация (факт)
      , AmountIn            TFloat -- Кол-во возврат (факт)
      , AmountReal          TFloat -- Объем продаж в аналогичный период, кг (итого
      , OperDate            TDateTime  -- месяц
      , isErased            Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        WITH
        tmpMI_Detail AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Detail()
                            AND MovementItem.isErased = FALSE
                         )

      , tmpMIFloat AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_AmountIn()
                                                        , zc_MIFloat_AmountReal()
                                                        )
                       )
                             
      , tmpMIDate AS (SELECT MovementItemDate.*
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                        AND MovementItemDate.DescId IN (zc_MIDate_OperDate()
                                                       )
                      )


        SELECT MovementItem.Id                        AS Id                  --идентификатор 
             , MovementItem.ParentId                  AS ParentId            --
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес

             , MovementItem.Amount          ::TFloat     AS Amount
             , MIFloat_AmountIn.ValueData   ::TFloat     AS AmountIn
             , MIFloat_AmountReal.ValueData ::TFloat     AS AmountReal
             , MIDate_OperDate.ValueData    ::TDateTime  AS OperDate
             , MovementItem.isErased                     AS isErased
        FROM tmpMI_Detail AS MovementItem
             LEFT JOIN tmpMIFloat AS MIFloat_AmountIn
                                  ON MIFloat_AmountIn.MovementItemId = MovementItem.Id 
                                 AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
             LEFT JOIN tmpMIFloat AS MIFloat_AmountReal
                                  ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                 AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
             LEFT JOIN tmpMIDate AS MIDate_OperDate
                                 ON MIDate_OperDate.MovementItemId = MovementItem.Id 
                                AND MIDate_OperDate.DescId = zc_MIDate_OperDate() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                              
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

       
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PromoGoods_Detail (5083159, zfCalc_UserAdmin());
