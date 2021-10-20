-- Function: gpSelect_MI_PromoPlan_Master()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoPlan_Master (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoPlan_Master(
    IN inMovementId  Integer      , -- ключ Документа Акция
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkName       TVarChar --Торговая марка
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара> 
      , GoodsWeight         TFloat -- 
      , Amount              TFloat
      , AmountPartner       TFloat
      , OperDate            TDateTime --ДДата продажа
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
                             
        SELECT MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
             , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес

             , MovementItem.Amount                    AS Amount
             , MIFloat_AmountPartner.ValueData        AS AmountPartner

             , MIDate_OperDate.ValueData              AS OperDate
   
             , MovementItem.isErased                  AS isErased            -- Удален
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)

             LEFT JOIN MovementItemDate AS MIDate_OperDate
                                        ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id 
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

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

        WHERE Movement.DescId = zc_Movement_PromoPlan()
          AND Movement.ParentId = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PromoPlan_Master (5083159 , FALSE, zfCalc_UserAdmin());