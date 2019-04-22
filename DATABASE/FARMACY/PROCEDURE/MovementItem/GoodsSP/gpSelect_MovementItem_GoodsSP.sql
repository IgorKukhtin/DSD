 -- Function: gpSelect_MovementItem_GoodsSP()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsSP (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsSP(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , ColSP         TFloat
             , CountSP       TFloat
             , PriceOptSP    TFloat
             , PriceRetSP    TFloat
             , DailyNormSP   TFloat
             , DailyCompensationSP  TFloat
             , PriceSP       TFloat
             , PaymentSP     TFloat
             , GroupSP       TFloat
             , Pack          TVarChar
             , CodeATX       TVarChar
             , MakerSP       TVarChar
             , ReestrSP      TVarChar
             , ReestrDateSP  TVarChar
             , IdSP          TVarChar
             , IntenalSPId   Integer 
             , IntenalSPName TVarChar
             , BrandSPId     Integer 
             , BrandSPName   TVarChar
             , KindOutSPId   Integer 
             , KindOutSPName TVarChar
             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll THEN
    
    RETURN QUERY
    WITH 
        tmpGoodsMain AS (SELECT ObjectBoolean_Goods_isMain.ObjectId AS Id
                         FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                              INNER JOIN Object AS Object_Goods 
                                                ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                               AND (Object_Goods.isErased = inIsErased OR inIsErased = TRUE)
                         WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                         )

        SELECT COALESCE (MovementItem.Id, 0)                         AS Id
             , Object_Goods.      Id                                 AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , Object_Goods.ValueData                                AS GoodsName

             , MIFloat_ColSP.ValueData                               AS ColSP
             , MIFloat_CountSP.ValueData                             AS CountSP
             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
             , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
             , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
             , MIFloat_PriceSP.ValueData                             AS PriceSP
             , MIFloat_PaymentSP.ValueData                           AS PaymentSP
             , MIFloat_GroupSP.ValueData                             AS GroupSP

             , MIString_Pack.ValueData                               AS Pack
             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_MakerSP.ValueData                            AS MakerSP
             , MIString_ReestrSP.ValueData                           AS ReestrSP
             , MIString_ReestrDateSP.ValueData                       AS ReestrDateSP
             , COALESCE (MIString_IdSP.ValueData, '')     ::TVarChar AS IdSP

             , COALESCE (Object_IntenalSP.Id ,0)          ::Integer  AS IntenalSPId
             , COALESCE (Object_IntenalSP.ValueData,'')   ::TVarChar AS IntenalSPName

             , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
             , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName

             , COALESCE (Object_KindOutSP.Id ,0)          ::Integer  AS KindOutSPId
             , COALESCE (Object_KindOutSP.ValueData,'')   ::TVarChar AS KindOutSPName

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM tmpGoodsMain
             LEFT JOIN MovementItem ON MovementItem.ObjectId = tmpGoodsMain.Id
                                   AND MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                       
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsMain.Id
             
             LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                         ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
             LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                         ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                         ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                         ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()  
             LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                         ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP() 
             LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                         ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP() 
             LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                         ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
             LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                         ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
             LEFT JOIN MovementItemFloat AS MIFloat_GroupSP
                                         ON MIFloat_GroupSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_GroupSP.DescId = zc_MIFloat_GroupSP()

             LEFT JOIN MovementItemString AS MIString_Pack
                                          ON MIString_Pack.MovementItemId = MovementItem.Id
                                         AND MIString_Pack.DescId = zc_MIString_Pack()
             LEFT JOIN MovementItemString AS MIString_CodeATX
                                          ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                         AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
             LEFT JOIN MovementItemString AS MIString_MakerSP
                                          ON MIString_MakerSP.MovementItemId = MovementItem.Id
                                         AND MIString_MakerSP.DescId = zc_MIString_MakerSP()
             LEFT JOIN MovementItemString AS MIString_ReestrSP
                                          ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()
             LEFT JOIN MovementItemString AS MIString_ReestrDateSP
                                          ON MIString_ReestrDateSP.MovementItemId = MovementItem.Id
                                         AND MIString_ReestrDateSP.DescId = zc_MIString_ReestrDateSP()
             LEFT JOIN MovementItemString AS MIString_IdSP
                                          ON MIString_IdSP.MovementItemId = MovementItem.Id
                                         AND MIString_IdSP.DescId = zc_MIString_IdSP()

             LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                              ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                             AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
             LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                              ON MI_BrandSP.MovementItemId = MovementItem.Id
                                             AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
             LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

             LEFT JOIN MovementItemLinkObject AS MI_KindOutSP
                                              ON MI_KindOutSP.MovementItemId = MovementItem.Id
                                             AND MI_KindOutSP.DescId = zc_MILinkObject_KindOutSP()
             LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = MI_KindOutSP.ObjectId 
            ;

    ELSE
    
    RETURN QUERY

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.ObjectId                                 AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , Object_Goods.ValueData                                AS GoodsName

             , MIFloat_ColSP.ValueData                               AS ColSP
             , MIFloat_CountSP.ValueData                             AS CountSP
             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
             , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
             , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
             , MIFloat_PriceSP.ValueData                             AS PriceSP
             , MIFloat_PaymentSP.ValueData                           AS PaymentSP
             , MIFloat_GroupSP.ValueData                             AS GroupSP

             , MIString_Pack.ValueData                               AS Pack
             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_MakerSP.ValueData                            AS MakerSP
             , MIString_ReestrSP.ValueData                           AS ReestrSP
             , MIString_ReestrDateSP.ValueData                       AS ReestrDateSP
             , COALESCE (MIString_IdSP.ValueData, '')     ::TVarChar AS IdSP

             , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
             , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName

             , COALESCE(Object_BrandSP.Id ,0)             ::Integer  AS BrandSPId
             , COALESCE(Object_BrandSP.ValueData,'')      ::TVarChar AS BrandSPName

             , COALESCE(Object_KindOutSP.Id ,0)           ::Integer  AS KindOutSPId
             , COALESCE(Object_KindOutSP.ValueData,'')    ::TVarChar AS KindOutSPName

             , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased

        FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            
            LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                        ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
            LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                        ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                        ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()  
            LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                        ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP() 
            LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                        ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP() 
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                        ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                        ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
            LEFT JOIN MovementItemFloat AS MIFloat_GroupSP
                                        ON MIFloat_GroupSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_GroupSP.DescId = zc_MIFloat_GroupSP()

            LEFT JOIN MovementItemString AS MIString_Pack
                                         ON MIString_Pack.MovementItemId = MovementItem.Id
                                        AND MIString_Pack.DescId = zc_MIString_Pack()
            LEFT JOIN MovementItemString AS MIString_CodeATX
                                         ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                        AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
            LEFT JOIN MovementItemString AS MIString_MakerSP
                                         ON MIString_MakerSP.MovementItemId = MovementItem.Id
                                        AND MIString_MakerSP.DescId = zc_MIString_MakerSP()
            LEFT JOIN MovementItemString AS MIString_ReestrSP
                                         ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                        AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()
            LEFT JOIN MovementItemString AS MIString_ReestrDateSP
                                         ON MIString_ReestrDateSP.MovementItemId = MovementItem.Id
                                        AND MIString_ReestrDateSP.DescId = zc_MIString_ReestrDateSP()
             LEFT JOIN MovementItemString AS MIString_IdSP
                                          ON MIString_IdSP.MovementItemId = MovementItem.Id
                                         AND MIString_IdSP.DescId = zc_MIString_IdSP()

            LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                             ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                            AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                             ON MI_BrandSP.MovementItemId = MovementItem.Id
                                            AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
            LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MI_KindOutSP
                                             ON MI_KindOutSP.MovementItemId = MovementItem.Id
                                            AND MI_KindOutSP.DescId = zc_MILinkObject_KindOutSP()
            LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = MI_KindOutSP.ObjectId 

         WHERE MovementItem.DescId = zc_MI_Master()
           AND MovementItem.MovementId = inMovementId
           AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            ;
    END IF;            

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.04.19         * add IdSP
 14.08.18         *
*/

--����
-- SELECT * FROM gpSelect_MovementItem_GoodsSP (inMovementId:= 0, inShowAll:= true, inIsErased:= FALSE, inSession:= '3')