 -- Function: gpSelect_MovementItem_GoodsSP408_1303()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSP408_1303 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSP408_1303(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar

             , Col           Integer
             , PriceOptSP    TFloat
             , ExchangeRate  TFloat
             , OrderNumberSP Integer

             , CodeATX       TVarChar
             , ReestrSP      TVarChar

             , ValiditySP       TDateTime
             , OrderDateSP      TDateTime

             , IntenalSP_1303Id   Integer 
             , IntenalSP_1303Name TVarChar
             , BrandSPId     Integer 
             , BrandSPName   TVarChar
             , KindOutSP_1303Id   Integer 
             , KindOutSP_1303Name TVarChar
             , Dosage_1303Id   Integer 
             , Dosage_1303Name TVarChar             
             , CountSP_1303Id   Integer 
             , CountSP_1303Name TVarChar             
             , MakerCountrySP_1303Id   Integer 
             , MakerCountrySP_1303Name TVarChar             
             , CurrencyId   Integer 
             , CurrencyName TVarChar             

             , MorionCode    Integer
             , NDS           TFloat
             , PriceOOC      TFloat
             , PriceSale     TFloat
             
             , DoubleId      Integer
             , isSale        Boolean
             
             , Color_Count   Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP408_1303());
    vbUserId:= lpGetUserBySession (inSession);

    
    RETURN QUERY
    WITH 
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovementItem AS ( SELECT MovementItem.Id

                                  , MovementItem.ObjectId

                                  , MovementItem.Amount::Integer                          AS Col

                                  , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                  , MIFloat_ExchangeRate.ValueData                        AS ExchangeRate
                                  , MIFloat_OrderNumberSP.ValueData::Integer              AS OrderNumberSP

                                  , MIDate_OrderDateSP.ValueData                          AS OrderDateSP
                                  , MIDate_ValiditySP.ValueData                           AS ValiditySP

                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MIDate_OrderDateSP.ValueData DESC) AS Ord
                                  , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
                              FROM MovementItem
                       
                                   LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                               ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                   LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                               ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ExchangeRate
                                                               ON MIFloat_ExchangeRate.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ExchangeRate.DescId = zc_MIFloat_ExchangeRate()

                                   LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                              ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()
                                   LEFT JOIN MovementItemDate AS MIDate_ValiditySP
                                                              ON MIDate_ValiditySP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ValiditySP.DescId = zc_MIDate_ValiditySP()

                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND (MovementItem.isErased = FALSE  OR inIsErased = TRUE))
      , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                              WHERE MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem))
      , tmpDouble AS (SELECT MovementItem.ObjectId
                           , ROW_NUMBER() OVER (ORDER BY MovementItem.ObjectId)::Integer AS DoubleId
                      FROM tmpMovementItem AS MovementItem
                      GROUP BY MovementItem.ObjectId
                      HAVING COUNT(*) > 1
                     )
        -- выбираем продажи по товарам соц.проекта
      , tmpSaleAll AS (SELECT Movement_Sale.Id
                   FROM Movement AS Movement_Sale

                        INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                      ON MovementLinkObject_SPKind.MovementId = Movement_Sale.Id
                                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                     AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()


                   WHERE Movement_Sale.DescId in (zc_Movement_Sale(), zc_Movement_Check())
                     AND Movement_Sale.OperDate >= '15.02.2022'
                     AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                  )
      -- выбираем продажи по товарам соц.проекта
      , tmpMI_Sale AS (SELECT DISTINCT Object_Goods.GoodsMainId     AS GoodsId
                        FROM tmpSaleAll AS Movement_Sale
                             INNER JOIN MovementItem AS MI_Sale
                                                     ON MI_Sale.MovementId = Movement_Sale.Id
                                                    AND MI_Sale.DescId = zc_MI_Master()
                                                    AND MI_Sale.isErased = FALSE
                                                    AND MI_Sale.Amount > 0
                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MI_Sale.ObjectId
                       )

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.ObjectId                                 AS GoodsId
             , Object_Goods.ObjectCode                               AS GoodsCode
             , Object_Goods.Name                                     AS GoodsName

             , MovementItem.Col                                      AS Col

             , MovementItem.PriceOptSP                               AS PriceOptSP
             , MovementItem.ExchangeRate                             AS ExchangeRate
             , MovementItem.OrderNumberSP                            AS OrderNumberSP

             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_ReestrSP.ValueData                           AS ReestrSP

             , MovementItem.ValiditySP                               AS ValiditySP
             , MovementItem.OrderDateSP                              AS OrderDateSP

             , COALESCE (Object_IntenalSP_1303.Id ,0)          ::Integer  AS IntenalSP_1303Id
             , COALESCE (Object_IntenalSP_1303.ValueData,'')   ::TVarChar AS IntenalSP_1303Name
             , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
             , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
             , COALESCE (Object_KindOutSP_1303.Id ,0)          ::Integer  AS KindOutSP_1303Id
             , COALESCE (Object_KindOutSP_1303.ValueData,'')   ::TVarChar AS KindOutSP_1303Name
             , COALESCE (Object_Dosage_1303.Id ,0)          ::Integer  AS Dosage_1303Id
             , COALESCE (Object_Dosage_1303.ValueData,'')   ::TVarChar AS Dosage_1303Name
             , COALESCE (Object_CountSP_1303.Id ,0)          ::Integer  AS CountSP_1303Id
             , COALESCE (Object_CountSP_1303.ValueData,'')   ::TVarChar AS CountSP_1303Name
             , COALESCE (Object_MakerCountrySP_1303.Id ,0)          ::Integer  AS MakerCountrySP_1303Id
             , COALESCE (Object_MakerCountrySP_1303.ValueData,'')   ::TVarChar AS MakerCountrySP_1303Name
             , COALESCE (Object_Currency.Id ,0)          ::Integer  AS CurrencyId
             , COALESCE (Object_Currency.ValueData,'')   ::TVarChar AS CurrencyName

             , Object_Goods.MorionCode 
             , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS
             , CASE WHEN COALESCE (MovementItem.ObjectId, 0) > 0 
                    THEN ROUND(MovementItem.PriceOptSP  * 
                        (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1, 2) END::TFloat AS PriceOOC
             , CASE WHEN COALESCE (MovementItem.ObjectId, 0) > 0 
                    THEN ROUND(MovementItem.PriceOptSP  * 
                        (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1 * 1.1, 2) END::TFloat AS PriceSale

             , tmpDouble.DoubleId                                    AS DoubleId
             , COALESCE (tmpMI_Sale.GoodsId, 0) > 0                  AS isSale       
             
             , zc_Color_White() AS Color_Count


             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
             
        FROM tmpMovementItem AS MovementItem
 
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 

             LEFT JOIN tmpMI_Sale ON tmpMI_Sale.GoodsId = Object_Goods.Id

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

             LEFT JOIN MovementItemString AS MIString_CodeATX
                                          ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                         AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
             LEFT JOIN MovementItemString AS MIString_ReestrSP
                                          ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()


             LEFT JOIN tmpMILinkObject AS MI_IntenalSP_1303
                                              ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                             AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
             LEFT JOIN Object AS Object_IntenalSP_1303 ON Object_IntenalSP_1303.Id = MI_IntenalSP_1303.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_BrandSP
                                              ON MI_BrandSP.MovementItemId = MovementItem.Id
                                             AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
             LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_KindOutSP_1303
                                              ON MI_KindOutSP_1303.MovementItemId = MovementItem.Id
                                             AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()
             LEFT JOIN Object AS Object_KindOutSP_1303 ON Object_KindOutSP_1303.Id = MI_KindOutSP_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                              ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                             AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()
             LEFT JOIN Object AS Object_Dosage_1303 ON Object_Dosage_1303.Id = MI_Dosage_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_CountSP_1303
                                              ON MI_CountSP_1303.MovementItemId = MovementItem.Id
                                             AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()
             LEFT JOIN Object AS Object_CountSP_1303 ON Object_CountSP_1303.Id = MI_CountSP_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_MakerCountrySP_1303
                                              ON MI_MakerCountrySP_1303.MovementItemId = MovementItem.Id
                                             AND MI_MakerCountrySP_1303.DescId = zc_MILinkObject_MakerCountrySP_1303()
             LEFT JOIN Object AS Object_MakerCountrySP_1303 ON Object_MakerCountrySP_1303.Id = MI_MakerCountrySP_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Currency
                                              ON MI_Currency.MovementItemId = MovementItem.Id
                                             AND MI_Currency.DescId = zc_MILinkObject_Currency()
             LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MI_Currency.ObjectId 
             
             LEFT JOIN tmpDouble ON tmpDouble.ObjectId = MovementItem.ObjectId 
        ORDER BY MovementItem.Col

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.04.23                                                       *
*/

--ТЕСТ
-- 
SELECT * FROM gpSelect_MovementItem_GoodsSP408_1303 (inMovementId:= 28341113 , inShowAll:= False, inIsErased:= FALSE, inSession:= '3')