-- Function: gpSelect_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
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
      , Amount              TFloat --% скидки на товар
      , Price               TFloat --Цена в прайсе
      , PriceSale           TFloat --Цена на полке
      , PriceWithOutVAT     TFloat --Цена отгрузки без учета НДС, с учетом скидки, грн
      , PriceWithVAT        TFloat --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , AmountReal          TFloat --Объем продаж в аналогичный период, кг
      , AmountRealWeight    TFloat --Объем продаж в аналогичный период, кг Вес
      , AmountRetIn         TFloat --Объем возврат в аналогичный период, кг
      , AmountRetInWeight   TFloat --Объем возврат в аналогичный период, кг Вес
      , AmountPlanMin       TFloat --Минимум планируемого объема продаж на акционный период (в кг)
      , AmountPlanMinWeight TFloat --Минимум планируемого объема продаж на акционный период (в кг) Вес
      , AmountPlanMax       TFloat --Максимум планируемого объема продаж на акционный период (в кг)
      , AmountPlanMaxWeight TFloat --Максимум планируемого объема продаж на акционный период (в кг) Вес
      , AmountOrder         TFloat --Кол-во заявка (факт)
      , AmountOrderWeight   TFloat --Кол-во заявка (факт) Вес
      , AmountOut           TFloat --Кол-во реализация (факт)
      , AmountOutWeight     TFloat --Кол-во реализация (факт) Вес
      , AmountIn            TFloat --Кол-во возврат (факт)
      , AmountInWeight      TFloat --Кол-во возврат (факт) Вес
      , GoodsKindId         Integer --ИД обьекта <Вид товара>
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара>
      , GoodsKindName_List  TVarChar --Наименование обьекта <Вид товара (справочно)>
      , Comment             TVarChar --Комментарий
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
      
             
        SELECT
            MI_PromoGoods.Id                     -- идентификатор
          , MI_PromoGoods.MovementId             -- ИД документа <Акция>
          , MI_PromoGoods.GoodsId                -- ИД объекта <товар>
          , MI_PromoGoods.GoodsCode              -- код объекта  <товар>
          , MI_PromoGoods.GoodsName              -- наименование объекта <товар>
          , MI_PromoGoods.Measure                -- Единица измерения
          , MI_PromoGoods.TradeMark              -- Торговая марка
          , MI_PromoGoods.Amount                 -- % скидки на товар
          , MI_PromoGoods.Price                  -- Цена в прайсе
          , MI_PromoGoods.PriceSale              -- Цена на полке
          , MI_PromoGoods.PriceWithOutVAT        -- Цена отгрузки без учета НДС, с учетом скидки, грн
          , MI_PromoGoods.PriceWithVAT           -- Цена отгрузки с учетом НДС, с учетом скидки, грн
          , MI_PromoGoods.AmountReal             -- Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight       -- Объем продаж в аналогичный период, кг Вес
          , MI_PromoGoods.AmountRetIn            -- Объем возврат в аналогичный период, кг
          , MI_PromoGoods.AmountRetInWeight      -- Объем возврат в аналогичный период, кг Вес
          , MI_PromoGoods.AmountPlanMin          -- Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight    -- Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax          -- Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight    -- Максимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountOrder            -- Кол-во заявка (факт)
          , MI_PromoGoods.AmountOrderWeight      -- Кол-во заявка (факт) Вес
          , MI_PromoGoods.AmountOut              -- Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight        -- Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn               -- Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight         -- Кол-во возврат (факт) Вес
          , MI_PromoGoods.GoodsKindId            -- ИД обьекта <Вид товара>
          , MI_PromoGoods.GoodsKindName          -- Наименование обьекта <Вид товара>
          , tmpGoodsKind_list.GoodsKindName_List ::TVarChar  -- Наименование обьекта <Вид товара (справочно)>
          , MI_PromoGoods.Comment                -- Комментарий
          , MI_PromoGoods.isErased                -- удален
          
        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MI_PromoGoods.GoodsId
        WHERE MI_PromoGoods.MovementId = inMovementId
          AND (MI_PromoGoods.isErased = FALSE OR inIsErased = TRUE);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 05.11.15                                                          *
*/
-- тест
-- SELECT * FROM gpSelect_MovementItem_PromoGoods (5083159 , FALSE, zfCalc_UserAdmin());
