-- Function: gpSelect_MI_PromoGoods_Plan()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Plan (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoGoods_Plan(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkName       TVarChar --Торговая марка
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара> 
      , GoodsKindCompleteName  TVarChar --Наименование обьекта <Вид товара(примечание)>
      , GoodsKindName_List     TVarChar --Наименование обьекта <Вид товара (справочно)>
      , GoodsWeight         TFloat -- 
      , AmountPlan1         TFloat -- Кол-во план отгрузки за пн.
      , AmountPlan2         TFloat -- Кол-во план отгрузки за вт.
      , AmountPlan3         TFloat -- Кол-во план отгрузки за ср.
      , AmountPlan4         TFloat -- Кол-во план отгрузки за чт.
      , AmountPlan5         TFloat -- Кол-во план отгрузки за пт.
      , AmountPlan6         TFloat -- Кол-во план отгрузки за сб.
      , AmountPlan7         TFloat -- Кол-во план отгрузки за вс.
      , isErased            Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    CREATE TEMP TABLE _tmpPromoPartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoPartner (PartnerId)
            SELECT MI_PromoPartner.ObjectId        AS PartnerId   --ИД объекта <партнер>
            FROM Movement AS Movement_PromoPartner
                 INNER JOIN MovementItem AS MI_PromoPartner
                                         ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                        AND MI_PromoPartner.DescId = zc_MI_Master()
                                        AND MI_PromoPartner.IsErased = FALSE
            WHERE Movement_PromoPartner.ParentId = inMovementId
              AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData) 
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoPartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoPartner.PartnerId
                                     AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                     
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 INNER JOIN (SELECT MovementItem.ObjectId 
                             FROM MovementItem 
                             WHERE MovementItem.MovementId = inMovementId 
                               AND MovementItem.DescId = zc_MI_Master() 
                               AND MovementItem.isErased = FALSE) AS MI_Master ON MI_Master.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                 INNER JOIN ObjectString AS ObjectString_GoodsKind
                                         ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                        AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                        AND ObjectString_GoodsKind.ValueData <> ''
            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId;
                                       
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList) 
            SELECT DISTINCT _tmpGoodsKind_inf.ValueData AS WordList
            FROM _tmpGoodsKind_inf;
            
    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);

    RETURN QUERY
        WITH
        tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (DISTINCT Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                         FROM _tmpWord_Split_to  
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                         GROUP BY _tmpWord_Split_to.WordList
                         )
      , tmpGoodsKind_list AS (SELECT _tmpGoodsKind_inf.GoodsId
                                   , STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName_List :: TVarChar, ',')  AS GoodsKindName_List
                              FROM _tmpGoodsKind_inf
                                   LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = _tmpGoodsKind_inf.ValueData
                              GROUP BY _tmpGoodsKind_inf.GoodsId
                             )
                             
        SELECT MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
             , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
             , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName       --Наименование обьекта <Вид товара(Примечание)>
             , tmpGoodsKind_list.GoodsKindName_List ::TVarChar                       -- Наименование обьекта <Вид товара (справочно)>
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес
             , MIFloat_Plan1.ValueData                AS AmountPlan1
             , MIFloat_Plan2.ValueData                AS AmountPlan2
             , MIFloat_Plan3.ValueData                AS AmountPlan3
             , MIFloat_Plan4.ValueData                AS AmountPlan4
             , MIFloat_Plan5.ValueData                AS AmountPlan5
             , MIFloat_Plan6.ValueData                AS AmountPlan6
             , MIFloat_Plan7.ValueData                AS AmountPlan7 
                 
             , MovementItem.isErased                  AS isErased            -- Удален
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                         ON MIFloat_Plan1.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                         ON MIFloat_Plan2.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                         ON MIFloat_Plan3.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                         ON MIFloat_Plan4.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                         ON MIFloat_Plan5.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                         ON MIFloat_Plan6.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                         ON MIFloat_Plan7.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                              ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId
                                             
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

             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MovementItem.ObjectId

        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 10.11.17         *
 05.11.15                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PromoGoods_Plan (5083159 , FALSE, zfCalc_UserAdmin());
