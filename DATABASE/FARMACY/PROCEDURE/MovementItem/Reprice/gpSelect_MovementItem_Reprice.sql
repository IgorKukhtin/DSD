 -- Function: gpSelect_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Reprice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Reprice(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PriceOld TFloat, PriceNew TFloat, Juridical_Price TFloat, SummReprice TFloat
             , ExpirationDate TDateTime, MinExpirationDate TDateTime
             , NDS TFloat, PriceDiff TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , Juridical_GoodsName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MakerName TVarChar
             , Juridical_Percent TFloat, Contract_Percent TFloat
             , MarginPercent TFloat
             , IsTop_Goods Boolean
             , isResolution_224 boolean
             , isPromoBonus boolean
             , Color_calc Integer
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


        SELECT MovementItem.Id                                   AS Id
             , MovementItem.ObjectId                             AS GoodsId
             , Object_Goods_Main.ObjectCode::INTEGER             AS GoodsCode
             , Object_Goods_Main.Name                            AS GoodsName
             , COALESCE(MovementItem.Amount,0)::TFloat           AS Amount
             , MIFloat_Price.ValueData                           AS PriceOld
             , MIFloat_PriceSale.ValueData                       AS PriceNew
             , MIFloat_JuridicalPrice.ValueData                  AS Juridical_Price
             , (MovementItem.Amount*
                 (COALESCE(MIFloat_PriceSale.ValueData, 0)
                  -COALESCE(MIFloat_Price.ValueData, 0)))   ::TFloat            AS SummReprice

             , COALESCE (MIDate_ExpirationDate.ValueData, Null) ::TDateTime     AS ExpirationDate
             , COALESCE (MIDate_MinExpirationDate.ValueData, Null) ::TDateTime  AS MinExpirationDate
             , ObjectFloat_NDSKind_NDS.ValueData                                AS NDS
             , CASE WHEN MIFloat_Price.ValueData <> 0
                    THEN ((MIFloat_PriceSale.ValueData - MIFloat_Price.ValueData )*100 / MIFloat_Price.ValueData )
                    ELSE 100 END            ::TFloat                            AS PriceDiff
             , COALESCE(Object_Juridical.Id ,0)  ::Integer                      AS JuridicalId
             , COALESCE(Object_Juridical.ValueData,'')::TVarChar                AS JuridicalName
             , tmpLinkGoods.Juridical_GoodsName ::TVarChar AS Juridical_GoodsName
             , COALESCE(Object_Contract.Id ,0)  ::Integer                       AS ContractId
             , COALESCE(Object_Contract.ValueData,'')::TVarChar                 AS ContractName

             , tmpLinkGoods.MakerName              ::TVarChar AS MakerName
             , MIFloat_JuridicalPercent.ValueData  ::TFloat   AS Juridical_Percent
             , MIFloat_ContractPercent.ValueData   ::TFloat   AS Contract_Percent

             , CASE WHEN COALESCE(Object_Goods.IsTop, false) = TRUE
                         THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (ObjectFloat_Goods_PercentMarkup.ValueData, 0))
                    ELSE CASE WHEN COALESCE (MarginCondition.MarginPercent, 0) <> 0
                                THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_ContractPercent.ValueData, 0)
                           ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_JuridicalPercent.ValueData, 0)
                      END
               END::TFloat AS MarginPercent

             , COALESCE(Object_Goods.IsTop, false)                              AS IsTop_Goods
             , Object_Goods_Main.isResolution_224                               AS isResolution_224
             , COALESCE(MIBoolean_PromoBonus.ValueData, False)                  AS isPromoBonus
             , CASE WHEN COALESCE(MIBoolean_ClippedReprice.ValueData, False) = TRUE THEN zc_Color_Yelow() ELSE zc_Color_White() END AS Color_calc
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

            LEFT JOIN Object_Goods_Retail AS Object_Goods
                                          ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()
            LEFT JOIN MovementItemDate AS MIDate_MinExpirationDate
                                       ON MIDate_MinExpirationDate.MovementItemId = MovementItem.Id
                                      AND MIDate_MinExpirationDate.DescId = zc_MIDate_MinExpirationDate()
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

            LEFT JOIN MovementItemLinkObject AS MI_Contract
                                             ON MI_Contract.MovementItemId = MovementItem.Id
                                            AND MI_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MI_Contract.ObjectId

            LEFT JOIN tmpLinkGoods ON tmpLinkGoods.GoodsId = MovementItem.ObjectId
                                  AND tmpLinkGoods.JuridicalId = Object_Juridical.Id


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = MovementItem.MovementId
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            /*LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                  ON ObjectFloat_Juridical_Percent.ObjectId = Object_Juridical.Id
                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                  ON ObjectFloat_Contract_Percent.ObjectId = Object_Contract.Id
                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()*/

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                     ON Object_MarginCategoryLink_unit.UnitId = MovementLinkObject_Unit.ObjectId -- 377605/*inUnitId*/
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

            LEFT JOIN MovementItemBoolean AS MIBoolean_PromoBonus
                                          ON MIBoolean_PromoBonus.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PromoBonus.DescId         = zc_MIBoolean_PromoBonus()

            LEFT JOIN GoodsPrice AS SelectMinPrice_AllGoods
                                 ON SelectMinPrice_AllGoods.GoodsId = MovementItem.ObjectId

            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                   ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()

         WHERE MovementItem.DescId = zc_MI_Master()
           AND MovementItem.MovementId = inMovementId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Reprice (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 29.10.18                                                                          *
 25.10.18                                                                          *
 17.02.16         *
 27.11.15                                                          *
*/

-- ТЕСТ
-- select * from gpSelect_MovementItem_Reprice(inMovementId := 11512270 ,  inSession := '3') where GoodsCode = 23901;