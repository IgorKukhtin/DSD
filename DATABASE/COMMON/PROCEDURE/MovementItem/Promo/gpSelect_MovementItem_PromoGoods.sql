-- Function: gpSelect_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id              Integer --идентификатор
      , MovementId      Integer --ИД документа <Акция>
      , GoodsId         Integer --ИД объекта <товар>
      , GoodsCode       Integer --код объекта  <товар>
      , GoodsName       TVarChar --наименование объекта <товар>
      , Amount          TFloat --% скидки на товар
      , Price           TFloat --Цена в прайсе
      , PriceWithOutVAT TFloat --Цена отгрузки без учета НДС, с учетом скидки, грн
      , PriceWithVAT    TFloat --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , AmountReal      TFloat --Объем продаж в аналогичный период, кг
      , AmountPlanMin   TFloat --Минимум планируемого объема продаж на акционный период (в кг)
      , AmountPlanMax   TFloat --Максимум планируемого объема продаж на акционный период (в кг)
      , GoodsKindId     Integer --ИД обьекта <Вид товара>
      , GoodsKindName   TVarChar --Наименование обьекта <Вид товара>
      , isErased        Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MI_PromoGoods.Id               --идентификатор
          , MI_PromoGoods.MovementId       --ИД документа <Акция>
          , MI_PromoGoods.GoodsId          --ИД объекта <товар>
          , MI_PromoGoods.GoodsCode        --код объекта  <товар>
          , MI_PromoGoods.GoodsName        --наименование объекта <товар>
          , MI_PromoGoods.Amount           --% скидки на товар
          , MI_PromoGoods.Price            --Цена в прайсе
          , MI_PromoGoods.PriceWithOutVAT  --Цена отгрузки без учета НДС, с учетом скидки, грн
          , MI_PromoGoods.PriceWithVAT     --Цена отгрузки с учетом НДС, с учетом скидки, грн
          , MI_PromoGoods.AmountReal       --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountPlanMin    --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMax    --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.GoodsKindId      --ИД обьекта <Вид товара>
          , MI_PromoGoods.GoodsKindName    --Наименование обьекта <Вид товара>
          , MI_PromoGoods.isErased          --удален
        FROM
            MovementItem_PromoGoods_View AS MI_PromoGoods
        WHERE
            MI_PromoGoods.MovementId = inMovementId
            AND
            (
                MI_PromoGoods.isErased = FALSE
                OR
                inIsErased = TRUE
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 05.11.15                                                          *
*/