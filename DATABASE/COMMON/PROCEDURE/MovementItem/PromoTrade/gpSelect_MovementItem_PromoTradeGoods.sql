-- Function: gpSelect_MovementItem_PromoTradeGoods()

-- DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeGoods_Plan (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoTradeGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoTradeGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Ord                 Integer
      , Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения  
      , GoodsKindId            Integer --ИД обьекта <Вид товара>
      , GoodsKindName          TVarChar --Наименование обьекта <Вид товара>      
      , TradeMarkId Integer, TradeMarkName       TVarChar --Торговая марка 
      , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar, GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar 
      , GoodsGroupDirectionId Integer, GoodsGroupDirectionName TVarChar

      , Amount             TFloat --Кол-во кг
      , Summ               TFloat --Сумма, грн
      , PartnerCount       TFloat --Количество ТТ   
      
      , AmountSale         TFloat -- Объем продаж (статистика за 3м.)    
      , SummSale           TFloat --
      , AmountReturnIn     TFloat -- Объем возвраты  даж (статистика за 3м.)

      , Comment            TVarChar --Комментарий       
      , isErased           Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoTradeGoods());
    vbUserId:= lpGetUserBySession (inSession);



    RETURN QUERY

        SELECT ROW_NUMBER() OVER (ORDER BY MovementItem.Id) ::Integer AS Ord
             , MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения   
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId                 --ИД обьекта <Вид товара>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --Наименование обьекта <Вид товара>
             , Object_TradeMark.Id                    AS TradeMarkId
             , Object_TradeMark.ValueData                AS TradeMark           --Торговая марка   
             , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
             , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
             , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
             , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
             , Object_GoodsGroupDirection.Id             AS GoodsGroupDirectionId
             , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
            
             , MovementItem.Amount            ::TFloat AS Amount           --% скидки на товар
             , MIFloat_Summ.ValueData         ::TFloat AS Summ             -- Общая скидка для покупателя, %
             , MIFloat_PartnerCount.ValueData ::TFloat AS PartnerCount     -- Цена в прайсе 
             , MIFloat_AmountSale.ValueData     ::TFloat AS AmountSale             --
             , MIFloat_SummSale.ValueData       ::TFloat AS SummSale             --
             , MIFloat_AmountReturnIn.ValueData ::TFloat AS AmountReturnIn

             , MIString_Comment.ValueData              AS Comment                     -- Примечание
             , MovementItem.isErased                   AS isErased                    -- Удален
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_PartnerCount
                                         ON MIFloat_PartnerCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_PartnerCount.DescId = zc_MIFloat_PartnerCount()
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountSale
                                         ON MIFloat_AmountSale.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountSale.DescId = zc_MIFloat_AmountSale()
             LEFT JOIN MovementItemFloat AS MIFloat_SummSale
                                         ON MIFloat_SummSale.MovementItemId = MovementItem.Id
                                        AND MIFloat_SummSale.DescId = zc_MIFloat_SummSale()                
             LEFT JOIN MovementItemFloat AS MIFloat_AmountReturnIn
                                         ON MIFloat_AmountReturnIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountReturnIn.DescId = zc_MIFloat_AmountReturnIn()  


             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                ON MIString_Comment.MovementItemId = MovementItem.ID
                                               AND MIString_Comment.DescId = zc_MIString_Comment()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure
                              ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --                                
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection() 
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)

        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/
-- тест
-- SELECT * FROM gpSelect_MovementItem_PromoTradeGoods (5083159 , FALSE, zfCalc_UserAdmin());
