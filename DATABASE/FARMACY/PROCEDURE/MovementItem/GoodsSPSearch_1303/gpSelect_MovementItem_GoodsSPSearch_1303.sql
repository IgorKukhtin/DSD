 -- Function: gpSelect_MovementItem_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSPSearch_1303 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSPSearch_1303(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer

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
             
             , Color_Count   Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSPSearch_1303());
    vbUserId:= lpGetUserBySession (inSession);

    
    RETURN QUERY
    WITH 
        tmpMovementItem AS ( SELECT MovementItem.Id

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

        SELECT MovementItem.Id                                       AS Id

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

             
             , zc_Color_White() AS Color_Count


             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpMovementItem AS MovementItem
 

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

                       
       -- WHERE MovementItem.Ord = 1 or COALESCE(MovementItem.ObjectId, 0) = 0 or inIsErased = True

         ;

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
SELECT * FROM gpSelect_MovementItem_GoodsSPSearch_1303 (inMovementId:= 27854839, inShowAll:= False, inIsErased:= FALSE, inSession:= '3')