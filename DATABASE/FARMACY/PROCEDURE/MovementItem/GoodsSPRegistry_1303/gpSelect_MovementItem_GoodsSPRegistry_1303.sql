 -- Function: gpSelect_MovementItem_GoodsSPRegistry_1303()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSPRegistry_1303 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSPRegistry_1303(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             
             , isSale        Boolean

             , PriceOptSP    TFloat
             , ExchangeRate  TFloat
             , OrderNumberSP Integer
             , ID_MED_FORM   Integer
             , MorionSP      Integer

             , CodeATX       TVarChar
             , ReestrSP      TVarChar

             , ReestrDateSP  TDateTime
             , ValiditySP    TDateTime
             , OrderDateSP   TDateTime

             , IntenalSPId   Integer 
             , IntenalSPName TVarChar
             , BrandSPId     Integer 
             , BrandSPName   TVarChar
             , KindOutSP_1303Id   Integer 
             , KindOutSP_1303Name TVarChar
             , Dosage_1303Id   Integer 
             , Dosage_1303Name TVarChar             
             , CountSP_1303Id   Integer 
             , CountSP_1303Name TVarChar             
             , MakerSP_1303Id   Integer 
             , MakerSP_1303Name TVarChar             
             , Country_1303Id   Integer 
             , Country_1303Name TVarChar             
             , CurrencyId   Integer 
             , CurrencyName TVarChar

             , NDS           TFloat
             , PriceSale     TFloat
             , PriceSaleOOC  TFloat
             
             , Color_Count   Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSPRegistry_1303());
    vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll THEN
    
    RETURN QUERY
    WITH 
        -- выбираем продажи по товарам соц.проекта
        tmpSaleAll AS (SELECT Movement_Sale.Id
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
      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovGoodsSP_1303 AS (SELECT Movement.Id                           AS Id
                                    , Movement.OperDate                     AS OperDate
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS ord
                               FROM Movement 
                               WHERE Movement.DescId = zc_Movement_GoodsSP_1303()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                               )
      , tmpMIGoodsSP_1303All AS (SELECT Movement.OperDate                     AS OperDate
                                      , COALESCE (MovementNext.OperDate, zc_DateEnd()) AS DateEnd
                                      , MovementItem.ObjectId                 AS GoodsId
                                      , MovementItem.Amount                   AS PriceSale
                                 FROM tmpMovGoodsSP_1303 AS Movement
                                            
                                      INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.isErased = False
                                                                       
                                      LEFT JOIN tmpMovGoodsSP_1303 AS MovementNext
                                                                   ON MovementNext.Ord =  Movement.Ord + 1
                                  )
      , tmpMIGoodsSP_1303 AS (SELECT MovementItem.GoodsId
                                   , MovementItem.PriceSale
                                   , ROW_NUMBER()OVER(PARTITION BY MovementItem.GoodsId ORDER BY MovementItem.DateEnd DESC) as ORD

                              FROM tmpMIGoodsSP_1303All AS MovementItem
                              WHERE MovementItem.OperDate <= CURRENT_DATE
                                AND MovementItem.DateEnd > CURRENT_DATE
                              )
      , tmpMovementItem AS ( SELECT MovementItem.Id
                                  , MovementItem.ObjectId

                                  , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                  , MIFloat_ExchangeRate.ValueData                        AS ExchangeRate
                                  , MIFloat_OrderNumberSP.ValueData::Integer              AS OrderNumberSP
                                  , MIFloat_ID_MED_FORM.ValueData::Integer                AS ID_MED_FORM
                                  , MIFloat_MorionSP.ValueData::Integer                   AS MorionSP

                                  , MIDate_OrderDateSP.ValueData                          AS OrderDateSP
                                  , MIDate_ReestrDateSP.ValueData                         AS ReestrDateSP
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
                                   LEFT JOIN MovementItemFloat AS MIFloat_ID_MED_FORM
                                                               ON MIFloat_ID_MED_FORM.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ID_MED_FORM.DescId = zc_MIFloat_ID_MED_FORM() 
                                   LEFT JOIN MovementItemFloat AS MIFloat_MorionSP
                                                               ON MIFloat_MorionSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MorionSP.DescId = zc_MIFloat_MorionSP() 

                                   LEFT JOIN MovementItemDate AS MIDate_ReestrDateSP
                                                              ON MIDate_ReestrDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ReestrDateSP.DescId = zc_MIDate_ReestrDateSP()
                                   LEFT JOIN MovementItemDate AS MIDate_ValiditySP
                                                              ON MIDate_ValiditySP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ValiditySP.DescId = zc_MIDate_ValiditySP()
                                   LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                              ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)),
      tmpMICount AS (SELECT MovementItem.ObjectId
                          , COUNT(*)               AS CountGoods
                     FROM tmpMovementItem AS MovementItem
                     GROUP BY MovementItem.ObjectId
                     ) 
                         

        SELECT COALESCE (MovementItem.Id, 0)                         AS Id
             , Object_Goods.      Id                                 AS GoodsId
             , Object_Goods.ObjectCode                               AS GoodsCode
             , Object_Goods.Name                                     AS GoodsName
             
             , COALESCE (tmpMI_Sale.GoodsId, 0) > 0                  AS isSale       

             , MovementItem.PriceOptSP                               AS PriceOptSP
             , MovementItem.ExchangeRate                             AS ExchangeRate
             , MovementItem.OrderNumberSP                            AS OrderNumberSP
             , MovementItem.ID_MED_FORM                              AS ID_MED_FORM
             , MovementItem.MorionSP                                 AS MorionSP

             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_ReestrSP.ValueData                           AS ReestrSP
             
             , MovementItem.ReestrDateSP                             AS ReestrDateSP
             , MovementItem.ValiditySP                               AS ValiditySP
             , MovementItem.OrderDateSP                              AS OrderDateSP

             , COALESCE (Object_IntenalSP.Id ,0)          ::Integer  AS IntenalSPId
             , COALESCE (Object_IntenalSP.ValueData,'')   ::TVarChar AS IntenalSPName
             , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
             , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
             , COALESCE (Object_KindOutSP_1303.Id ,0)          ::Integer  AS KindOutSP_1303Id
             , COALESCE (Object_KindOutSP_1303.ValueData,'')   ::TVarChar AS KindOutSP_1303Name
             , COALESCE (Object_Dosage_1303.Id ,0)          ::Integer  AS Dosage_1303Id
             , COALESCE (Object_Dosage_1303.ValueData,'')   ::TVarChar AS Dosage_1303Name
             , COALESCE (Object_CountSP_1303.Id ,0)          ::Integer  AS CountSP_1303Id
             , COALESCE (Object_CountSP_1303.ValueData,'')   ::TVarChar AS CountSP_1303Name
             , COALESCE (Object_MakerSP_1303.Id ,0)          ::Integer  AS MakerSP_1303Id
             , COALESCE (Object_MakerSP_1303.ValueData,'')   ::TVarChar AS MakerSP_1303Name
             , COALESCE (Object_Country_1303.Id ,0)          ::Integer  AS Country_1303Id
             , COALESCE (Object_Country_1303.ValueData,'')   ::TVarChar AS Country_1303Name
             , COALESCE (Object_Currency.Id ,0)          ::Integer  AS CurrencyId
             , COALESCE (Object_Currency.ValueData,'')   ::TVarChar AS CurrencyName

             , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat       AS NDS
             , ROUND(MovementItem.PriceOptSP  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale
             , MIGoodsSP_1303.PriceSale                                     AS PriceSaleOOC

             , CASE
                  WHEN COALESCE (tmpMICount.CountGoods, 1) > 1 AND MovementItem.Ord = 1
                  THEN zc_Color_Yelow()
                  WHEN COALESCE (tmpMICount.CountGoods, 1) > 1 AND MovementItem.Ord > 1
                  THEN zfCalc_Color (255, 165, 0) -- orange 
                  ELSE zc_Color_White()
               END  AS Color_Count

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM Object_Goods_Main AS Object_Goods
        
             LEFT JOIN tmpMovementItem AS MovementItem 
                                       ON MovementItem.ObjectId = Object_Goods.Id
                                                    
             LEFT JOIN tmpMI_Sale ON tmpMI_Sale.GoodsId = Object_Goods.Id
             
             LEFT JOIN MovementItemString AS MIString_CodeATX
                                          ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                         AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
             LEFT JOIN MovementItemString AS MIString_ReestrSP
                                          ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()

             LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                              ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                             AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
             LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_BrandSP
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

             LEFT JOIN MovementItemLinkObject AS MI_MakerSP_1303
                                              ON MI_MakerSP_1303.MovementItemId = MovementItem.Id
                                             AND MI_MakerSP_1303.DescId = zc_MILinkObject_MakerSP_1303()
             LEFT JOIN Object AS Object_MakerSP_1303 ON Object_MakerSP_1303.Id = MI_MakerSP_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Country_1303
                                              ON MI_Country_1303.MovementItemId = MovementItem.Id
                                             AND MI_Country_1303.DescId = zc_MILinkObject_Country_1303()
             LEFT JOIN Object AS Object_Country_1303 ON Object_Country_1303.Id = MI_Country_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Currency
                                              ON MI_Currency.MovementItemId = MovementItem.Id
                                             AND MI_Currency.DescId = zc_MILinkObject_Currency()
             LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MI_Currency.ObjectId 

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

             LEFT JOIN tmpMIGoodsSP_1303 AS MIGoodsSP_1303
                                         ON MIGoodsSP_1303.GoodsId = MovementItem.ObjectId
                                        AND MIGoodsSP_1303.Ord = 1 

             LEFT JOIN tmpMICount ON tmpMICount.ObjectId = MovementItem.ObjectId

        WHERE Object_Goods.isErased = False;

    ELSE
    
    RETURN QUERY
    WITH 
       -- выбираем продажи по товарам соц.проекта
        tmpSaleAll AS (SELECT Movement_Sale.Id
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
      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovGoodsSP_1303 AS (SELECT Movement.Id                           AS Id
                                    , Movement.OperDate                     AS OperDate
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS ord
                               FROM Movement 
                               WHERE Movement.DescId = zc_Movement_GoodsSP_1303()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                               )
      , tmpMIGoodsSP_1303All AS (SELECT Movement.OperDate                     AS OperDate
                                      , COALESCE (MovementNext.OperDate, zc_DateEnd()) AS DateEnd
                                      , MovementItem.ObjectId                 AS GoodsId
                                      , MovementItem.Amount                   AS PriceSale
                                 FROM tmpMovGoodsSP_1303 AS Movement
                                            
                                      INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.isErased = False
                                                                       
                                      LEFT JOIN tmpMovGoodsSP_1303 AS MovementNext
                                                                   ON MovementNext.Ord =  Movement.Ord + 1
                                  )
      , tmpMIGoodsSP_1303 AS (SELECT MovementItem.GoodsId
                                   , MovementItem.PriceSale
                                   , ROW_NUMBER()OVER(PARTITION BY MovementItem.GoodsId ORDER BY MovementItem.DateEnd DESC) as ORD

                              FROM tmpMIGoodsSP_1303All AS MovementItem
                              WHERE MovementItem.OperDate <= CURRENT_DATE
                                AND MovementItem.DateEnd > CURRENT_DATE
                              )
      , tmpMovementItemAll AS ( SELECT MovementItem.Id
                                     , MovementItem.ObjectId
                                     , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
                                FROM MovementItem
                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND (MovementItem.isErased = FALSE OR inIsErased = TRUE))
      , tmpMovementItem AS ( SELECT MovementItem.Id
                                  , MovementItem.ObjectId

                                  , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                  , MIFloat_ExchangeRate.ValueData                        AS ExchangeRate
                                  , MIFloat_OrderNumberSP.ValueData::Integer              AS OrderNumberSP
                                  , MIFloat_ID_MED_FORM.ValueData::Integer                AS ID_MED_FORM
                                  , MIFloat_MorionSP.ValueData::Integer                   AS MorionSP

                                  , MIDate_OrderDateSP.ValueData                          AS OrderDateSP
                                  , MIDate_ReestrDateSP.ValueData                         AS ReestrDateSP
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
                                   LEFT JOIN MovementItemFloat AS MIFloat_ID_MED_FORM
                                                               ON MIFloat_ID_MED_FORM.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ID_MED_FORM.DescId = zc_MIFloat_ID_MED_FORM() 
                                   LEFT JOIN MovementItemFloat AS MIFloat_MorionSP
                                                               ON MIFloat_MorionSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MorionSP.DescId = zc_MIFloat_MorionSP() 

                                   LEFT JOIN MovementItemDate AS MIDate_ReestrDateSP
                                                              ON MIDate_ReestrDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ReestrDateSP.DescId = zc_MIDate_ReestrDateSP()
                                   LEFT JOIN MovementItemDate AS MIDate_ValiditySP
                                                              ON MIDate_ValiditySP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ValiditySP.DescId = zc_MIDate_ValiditySP()
                                   LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                              ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND (MovementItem.isErased = FALSE  OR inIsErased = TRUE))
      , tmpMICount AS (SELECT MovementItem.ObjectId
                            , COUNT(*)               AS CountGoods
                       FROM tmpMovementItem AS MovementItem
                       GROUP BY MovementItem.ObjectId
                       ) 
      , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                              WHERE MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem))

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.ObjectId                                 AS GoodsId
             , Object_Goods.ObjectCode                               AS GoodsCode
             , Object_Goods.Name                                     AS GoodsName

             , COALESCE (tmpMI_Sale.GoodsId, 0) > 0                  AS isSale       

             , MovementItem.PriceOptSP                               AS PriceOptSP
             , MovementItem.ExchangeRate                             AS ExchangeRate
             , MovementItem.OrderNumberSP                            AS OrderNumberSP
             , MovementItem.ID_MED_FORM::Integer                     AS ID_MED_FORM
             , MovementItem.MorionSP::Integer                        AS MorionSP

             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_ReestrSP.ValueData                           AS ReestrSP

             , MovementItem.ReestrDateSP                         AS ReestrDateSP
             , MovementItem.ValiditySP                           AS ValiditySP
             , MovementItem.OrderDateSP                              AS OrderDateSP

             , COALESCE (Object_IntenalSP.Id ,0)          ::Integer  AS IntenalSPId
             , COALESCE (Object_IntenalSP.ValueData,'')   ::TVarChar AS IntenalSPName
             , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
             , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
             , COALESCE (Object_KindOutSP_1303.Id ,0)          ::Integer  AS KindOutSP_1303Id
             , COALESCE (Object_KindOutSP_1303.ValueData,'')   ::TVarChar AS KindOutSP_1303Name
             , COALESCE (Object_Dosage_1303.Id ,0)          ::Integer  AS Dosage_1303Id
             , COALESCE (Object_Dosage_1303.ValueData,'')   ::TVarChar AS Dosage_1303Name
             , COALESCE (Object_CountSP_1303.Id ,0)          ::Integer  AS CountSP_1303Id
             , COALESCE (Object_CountSP_1303.ValueData,'')   ::TVarChar AS CountSP_1303Name
             , COALESCE (Object_MakerSP_1303.Id ,0)          ::Integer  AS MakerSP_1303Id
             , COALESCE (Object_MakerSP_1303.ValueData,'')   ::TVarChar AS MakerSP_1303Name
             , COALESCE (Object_Country_1303.Id ,0)          ::Integer  AS Country_1303Id
             , COALESCE (Object_Country_1303.ValueData,'')   ::TVarChar AS Country_1303Name
             , COALESCE (Object_Currency.Id ,0)          ::Integer  AS CurrencyId
             , COALESCE (Object_Currency.ValueData,'')   ::TVarChar AS CurrencyName

             , ObjectFloat_NDSKind_NDS.ValueData                    AS NDS
             , ROUND(MovementItem.PriceOptSP  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale
             , MIGoodsSP_1303.PriceSale                                     AS PriceSaleOOC
             
             , CASE
                  WHEN COALESCE (tmpMICount.CountGoods, 1) > 1 AND MovementItem.Ord = 1
                  THEN zc_Color_Yelow()
                  WHEN COALESCE (tmpMICount.CountGoods, 1) > 1 AND MovementItem.Ord > 1
                  THEN zfCalc_Color (255, 165, 0) -- orange 
                  ELSE zc_Color_White()
               END  AS Color_Count


             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpMovementItem AS MovementItem
 
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
            
             LEFT JOIN tmpMI_Sale ON tmpMI_Sale.GoodsId = MovementItem.ObjectId


             LEFT JOIN MovementItemString AS MIString_CodeATX
                                          ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                         AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
             LEFT JOIN MovementItemString AS MIString_ReestrSP
                                          ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()


             LEFT JOIN tmpMILinkObject AS MI_IntenalSP
                                              ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                             AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
             LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 

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

             LEFT JOIN MovementItemLinkObject AS MI_MakerSP_1303
                                              ON MI_MakerSP_1303.MovementItemId = MovementItem.Id
                                             AND MI_MakerSP_1303.DescId = zc_MILinkObject_MakerSP_1303()
             LEFT JOIN Object AS Object_MakerSP_1303 ON Object_MakerSP_1303.Id = MI_MakerSP_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Country_1303
                                              ON MI_Country_1303.MovementItemId = MovementItem.Id
                                             AND MI_Country_1303.DescId = zc_MILinkObject_Country_1303()
             LEFT JOIN Object AS Object_Country_1303 ON Object_Country_1303.Id = MI_Country_1303.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_Currency
                                              ON MI_Currency.MovementItemId = MovementItem.Id
                                             AND MI_Currency.DescId = zc_MILinkObject_Currency()
             LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MI_Currency.ObjectId 

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId
                                  
             LEFT JOIN tmpMIGoodsSP_1303 AS MIGoodsSP_1303
                                         ON MIGoodsSP_1303.GoodsId = MovementItem.ObjectId
                                        AND MIGoodsSP_1303.Ord = 1 
                                        
             LEFT JOIN tmpMICount ON tmpMICount.ObjectId = MovementItem.ObjectId
                       
        WHERE MovementItem.Ord = 1 or COALESCE(MovementItem.ObjectId, 0) = 0 or inIsErased = True

         ;
    END IF;            

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.05.22                                                       *
*/

--ТЕСТ
-- 
SELECT * FROM gpSelect_MovementItem_GoodsSPRegistry_1303 (inMovementId:= 27854839, inShowAll:= False, inIsErased:= FALSE, inSession:= '3')