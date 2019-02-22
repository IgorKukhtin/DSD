 -- Function: gpSelect_MovementItem_Reprice_XML()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Reprice_XML (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Reprice_XML(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
               GoodsCode Integer
             , GoodsName TVarChar

             , Amount TFloat
             , PriceOld TFloat
             , PriceNew TFloat
             , SummReprice TFloat

             , Juridical_Price TFloat
             , MarginPercent TFloat
             , NDS TFloat
             , SummNDS TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Reprice());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpLinkGoods AS (select *
                          FROM (SELECT ROW_NUMBER() OVER (PARTITION BY LinkGoods.GoodsId,  Juridical.Id ORDER BY  LinkGoods_Main.GoodsMainId desc ) as nom
                                 , LinkGoods_Main.GoodsMainId
                                 , LinkGoods.GoodsId
                                 , LinkGoods_Main.GoodsName AS Juridical_GoodsName
                                 , LinkGoods_Main.MakerName AS MakerName
                                 , Juridical.Id AS  JuridicalId
                                 , Juridical.Valuedata AS  JuridicalName
                                FROM MovementItem
                                     Inner join Object_LinkGoods_View AS LinkGoods ON LinkGoods.GoodsId = MovementItem.ObjectId
                                     Inner join  Object_LinkGoods_View AS LinkGoods_Main ON LinkGoods_Main.GoodsMainId = LinkGoods.GoodsMainId
                                     left join Object AS Juridical ON Juridical.Id = LinkGoods_Main.ObjectId
                                WHERE MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.MovementId = inMovementId
                                ORDER BY  LinkGoods_Main.GoodsMainId desc
                               ) AS tmp
                          WHERE tmp.nom = 1
                          )
     , DD AS(
        SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
            )
     , MarginCondition AS (
        SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
            )
     , GoodsPrice AS (
        SELECT
            MovementItem.ObjectId AS GoodsId,
            COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP,
            COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
        FROM MovementItem
             INNER JOIN Movement ON  Movement.ID = MovementItem.MovementID
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   ON ObjectLink_Price_Goods.ChildObjectId = MovementItem.ObjectId
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId =  MovementLinkObject_Unit.ObjectId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0)
             )


        SELECT
               Object_Goods.goodscodeInt                         AS GoodsCode
             , Object_Goods.goodsname                            AS GoodsName
             , COALESCE(MovementItem.Amount,0)::TFloat           AS Amount
             , MIFloat_Price.ValueData                           AS PriceOld
             , MIFloat_PriceSale.ValueData                       AS PriceNew
             , (MovementItem.Amount*
                 (COALESCE(MIFloat_PriceSale.ValueData, 0)
                  -COALESCE(MIFloat_Price.ValueData, 0)))   ::TFloat            AS SummReprice
             , MIFloat_JuridicalPrice.ValueData                  AS Juridical_Price
             , CASE WHEN COALESCE(ObjectBoolean_Goods_TOP.ValueData, false) = TRUE
                         THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (ObjectFloat_Goods_PercentMarkup.ValueData, 0))
                    ELSE CASE WHEN COALESCE (MarginCondition.MarginPercent, 0) <> 0
                                THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_ContractPercent.ValueData, 0)
                           ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_JuridicalPercent.ValueData, 0)
                      END
               END::TFloat AS MarginPercent

             , Object_Goods.NDS
             , Round((MovementItem.Amount*
                 (COALESCE(MIFloat_PriceSale.ValueData, 0)
                  -COALESCE(MIFloat_Price.ValueData, 0))) * Object_Goods.NDS / (100 + Object_Goods.NDS), 2)::TFloat AS SummNDS
        FROM  MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                    ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                   AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPercent
                                        ON MIFloat_JuridicalPercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_JuridicalPercent.DescId = zc_MIFloat_JuridicalPercent()
            LEFT JOIN MovementItemFloat AS MIFloat_ContractPercent
                                        ON MIFloat_ContractPercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContractPercent.DescId = zc_MIFloat_ContractPercent()

            LEFT JOIN Object_Goods_View AS Object_Goods
                                        ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
           -- LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

            LEFT JOIN MovementItemLinkObject AS MI_Juridical
                                             ON MI_Juridical.MovementItemId = MovementItem.Id
                                            AND MI_Juridical.DescId = zc_MILinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MI_Juridical.ObjectId

            LEFT JOIN tmpLinkGoods ON tmpLinkGoods.GoodsId = MovementItem.ObjectId
                                  AND tmpLinkGoods.JuridicalId = Object_Juridical.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = MovementItem.MovementId
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                     ON Object_MarginCategoryLink_unit.UnitId = MovementLinkObject_Unit.ObjectId
                                                    AND Object_MarginCategoryLink_unit.JuridicalId = Object_Juridical.Id
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                    AND Object_MarginCategoryLink_all.JuridicalId = Object_Juridical.Id
                                                    AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                    AND (MIFloat_PriceSale.ValueData  * (100 + ObjectFloat_NDSKind_NDS.ValueData  )/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

            LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                          ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                         AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = MovementItem.ObjectId
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

            LEFT JOIN GoodsPrice AS SelectMinPrice_AllGoods
                                 ON SelectMinPrice_AllGoods.GoodsId = MovementItem.ObjectId

            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                   ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()

         WHERE MovementItem.DescId = zc_MI_Master()
           AND MovementItem.MovementId = inMovementId
           AND COALESCE(MIBoolean_ClippedReprice.ValueData, False) = FALSE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Reprice_XML (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 14.02.19                                                                          *
*/

--ТЕСТ
--select * from gpSelect_MovementItem_Reprice_XML(inMovementId := 12431477,  inSession := '3');