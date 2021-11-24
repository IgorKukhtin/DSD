 -- Function: gpSelect_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_RepriceSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_RepriceSite(
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
             , IsTop_Goods Boolean
             , isResolution_224 boolean
             , isPromoBonus boolean
             , isJuridicalTwo Boolean
             , JuridicalTwoId Integer, JuridicalTwoName TVarChar
             , JuridicalTwo_GoodsName TVarChar
             , ContractTwoId Integer, ContractTwoName TVarChar
             , Juridical_PriceTwo TFloat, ExpirationDateTwo TDateTime
             , isPromo boolean
             , Color_calc Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_RepriceSite());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH GoodsPromo AS (SELECT DISTINCT tmp.GoodsId
                        FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                         )
     , tmpLinkGoods AS (select *
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
                  -COALESCE(MIFloat_Price.ValueData, 0)))   ::TFloat            AS SummRepriceSite

             , COALESCE (MIDate_ExpirationDate.ValueData, Null) ::TDateTime     AS ExpirationDate
             , COALESCE (MIDate_MinExpirationDate.ValueData, Null) ::TDateTime  AS MinExpirationDate
             , ObjectFloat_NDSKind_NDS.ValueData                                AS NDS
             , CASE WHEN MIFloat_Price.ValueData <> 0
                    THEN ((MIFloat_PriceSale.ValueData - MIFloat_Price.ValueData )*100 / MIFloat_Price.ValueData )
                    ELSE 100 END            ::TFloat                            AS PriceDiff
             , COALESCE(Object_Juridical.Id ,0)  ::Integer                      AS JuridicalId
             , COALESCE(Object_Juridical.ValueData,'')::TVarChar                AS JuridicalName
             , tmpLinkGoods.Juridical_GoodsName ::TVarChar                      AS Juridical_GoodsName
             , COALESCE(Object_Contract.Id ,0)  ::Integer                       AS ContractId
             , COALESCE(Object_Contract.ValueData,'')::TVarChar                 AS ContractName

             , tmpLinkGoods.MakerName              ::TVarChar AS MakerName

             , COALESCE(Object_Goods.IsTop, false)                              AS IsTop_Goods
             , Object_Goods_Main.isResolution_224                               AS isResolution_224
             , COALESCE(MIBoolean_PromoBonus.ValueData, False)                  AS isPromoBonus

             , COALESCE(MIBoolean_JuridicalTwo.ValueData, False)                AS isJuridicalTwo
             , COALESCE(Object_JuridicalTwo.Id ,0)  ::Integer                   AS JuridicalTwoId
             , COALESCE(Object_JuridicalTwo.ValueData,'')::TVarChar             AS JuridicalTwoName
             , tmpLinkGoodsTwo.Juridical_GoodsName ::TVarChar                   AS JuridicalTwo_GoodsName
             , COALESCE(Object_ContractTwo.Id ,0)  ::Integer                    AS ContractTwoId
             , COALESCE(Object_ContractTwo.ValueData,'')::TVarChar              AS ContractTwoName

             , MIFloat_JuridicalPriceTwo.ValueData                              AS Juridical_PriceTwo
             , COALESCE (MIDate_ExpirationDateTwo.ValueData, Null) ::TDateTime  AS ExpirationDateTwo
             
             , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

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

            LEFT JOIN Object_Goods_Retail AS Object_Goods
                                          ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods.Id

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

            LEFT JOIN MovementItemBoolean AS MIBoolean_JuridicalTwo
                                          ON MIBoolean_JuridicalTwo.MovementItemId = MovementItem.Id
                                         AND MIBoolean_JuridicalTwo.DescId         = zc_MIBoolean_JuridicalTwo()

            LEFT JOIN MovementItemLinkObject AS MI_JuridicalTwo
                                             ON MI_JuridicalTwo.MovementItemId = MovementItem.Id
                                            AND MI_JuridicalTwo.DescId = zc_MILinkObject_JuridicalTwo()
            LEFT JOIN Object AS Object_JuridicalTwo ON Object_JuridicalTwo.Id = MI_JuridicalTwo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MI_ContractTwo
                                             ON MI_ContractTwo.MovementItemId = MovementItem.Id
                                            AND MI_ContractTwo.DescId = zc_MILinkObject_ContractTwo()
            LEFT JOIN Object AS Object_ContractTwo ON Object_ContractTwo.Id = MI_ContractTwo.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceTwo
                                    ON MIFloat_JuridicalPriceTwo.MovementItemId = MovementItem.Id
                                   AND MIFloat_JuridicalPriceTwo.DescId = zc_MIFloat_JuridicalPriceTwo()

            LEFT JOIN MovementItemDate AS MIDate_ExpirationDateTwo
                                       ON MIDate_ExpirationDateTwo.MovementItemId = MovementItem.Id
                                      AND MIDate_ExpirationDateTwo.DescId = zc_MIDate_ExpirationDateTwo()

            LEFT JOIN tmpLinkGoods ON tmpLinkGoods.GoodsId = MovementItem.ObjectId
                                  AND tmpLinkGoods.JuridicalId = Object_Juridical.Id

            LEFT JOIN tmpLinkGoods AS tmpLinkGoodsTwo 
                                   ON tmpLinkGoodsTwo.GoodsId = MovementItem.ObjectId
                                  AND tmpLinkGoodsTwo.JuridicalId = Object_JuridicalTwo.Id

            LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                          ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                         AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()

            LEFT JOIN MovementItemBoolean AS MIBoolean_PromoBonus
                                          ON MIBoolean_PromoBonus.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PromoBonus.DescId         = zc_MIBoolean_PromoBonus()

            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                   ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()

         WHERE MovementItem.DescId = zc_MI_Master()
           AND MovementItem.MovementId = inMovementId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_RepriceSite (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.06.21                                                      *  
*/

-- ТЕСТ
-- 
select * from gpSelect_MovementItem_RepriceSite(inMovementId := 11512270 ,  inSession := '3');