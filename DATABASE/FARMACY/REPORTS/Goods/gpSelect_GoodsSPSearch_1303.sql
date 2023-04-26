-- Function: gpSelect_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPSearch_1303 (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPSearch_1303(
    IN inText        TVarChar     , -- ��������
    IN inSession     TVarChar       -- ������ ������������
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
             
             , isOrder408    Boolean

             , Color_Count   Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbMovementId Integer;
    DECLARE vbMovement408Id Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSPSearch_1303());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT Movement.Id                           AS Id
    INTO vbMovementId
    FROM Movement 

         LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

         LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
      AND Movement.StatusId = zc_Enum_Status_Complete()
      AND MovementDate_OperDateStart.ValueData <= CURRENT_DATE
      AND MovementDate_OperDateEnd.ValueData >= CURRENT_DATE 
    ORDER BY Movement.OperDate DESC
    LIMIT 1;

    SELECT Movement.Id                           AS Id
    INTO vbMovement408Id
    FROM Movement 

         LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

         LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

    WHERE Movement.DescId = zc_Movement_GoodsSP408_1303()
      AND Movement.StatusId <> zc_Enum_Status_Erased()
      AND MovementDate_OperDateStart.ValueData <= CURRENT_DATE
      AND MovementDate_OperDateEnd.ValueData >= CURRENT_DATE 
    ORDER BY Movement.OperDate DESC
    LIMIT 1;
    
    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '��� ��������� "������ ������� ���. ������� 1303 ��� ������"';
    END IF;
    
    IF COALESCE(inText, '') = '' 
    THEN
      RETURN;
    END IF;
    
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

                                  , COALESCE (Object_IntenalSP_1303.Id ,0)          ::Integer  AS IntenalSP_1303Id
                                  , COALESCE (Object_IntenalSP_1303.ValueData,'')   ::TVarChar AS IntenalSP_1303Name
                                  , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
                                  , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
                                  
                                  , MovementItem.MovementId <> vbMovementId               AS isOrder408
                                  
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId 
                                                       ORDER BY CASE WHEN MovementItem.MovementId = vbMovementId THEN 0 ELSE 1 END) AS Ord

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

                                   LEFT JOIN MovementItemLinkObject AS MI_IntenalSP_1303
                                                                    ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                                                   AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
                                   LEFT JOIN Object AS Object_IntenalSP_1303 ON Object_IntenalSP_1303.Id = MI_IntenalSP_1303.ObjectId 

                                   LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                                                    ON MI_BrandSP.MovementItemId = MovementItem.Id
                                                                   AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
                                   LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId in (vbMovementId, COALESCE(vbMovement408Id, 0))
                                 AND MovementItem.isErased = FALSE
                                 AND (MovementItem.MovementId = vbMovementId OR COALESCE (MIFloat_PriceOptSP.ValueData, 0) > 0)
                                 AND (COALESCE (Object_IntenalSP_1303.ValueData,'') ILIKE '%'||inText||'%'
                                   OR COALESCE (Object_BrandSP.ValueData,'') ILIKE '%'||inText||'%'))
      , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                              WHERE MovementItemId IN (SELECT DISTINCT tmpMovementItem.Id FROM tmpMovementItem))

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

             , MovementItem.IntenalSP_1303Id                         AS IntenalSP_1303Id
             , MovementItem.IntenalSP_1303Name                       AS IntenalSP_1303Name
             , MovementItem.BrandSPId                                AS BrandSPId
             , MovementItem.BrandSPName                              AS BrandSPName
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
             
             , MovementItem.isOrder408 AS isOrder408

             , zc_Color_White() AS Color_Count
             
             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpMovementItem AS MovementItem
 
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

             LEFT JOIN MovementItemString AS MIString_CodeATX
                                          ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                         AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
             LEFT JOIN MovementItemString AS MIString_ReestrSP
                                          ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()

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
             
        --WHERE MovementItem.Ord = 1

        ORDER BY MovementItem.Col

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.06.22                                                       *
*/

--����
-- 

select * from gpSelect_GoodsSPSearch_1303(inText := '���' ,  inSession := '3');